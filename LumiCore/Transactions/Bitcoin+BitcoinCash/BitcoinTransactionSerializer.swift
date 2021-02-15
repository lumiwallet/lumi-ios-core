//
//  BitcoinTransactionSerializer.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public class BitcoinTransactionSerializer {
    
    public init() {}
    
    public func serialize(_ transaction: BitcoinTransactionProtocol) -> Data {
        var data = Data()
        data += serialize(transaction.version)
        
        if let witness = transaction.settings.witness {
            data += witness.marker.data
            data += witness.flag.data
        }
        
        data += serialize(transaction.inputs)
        data += serialize(transaction.outputs)
        data += serialize((transaction as? BitcoinTransaction)?.witness)
        data += serialize(transaction.lockTime)
        
        return data
    }
    
    public func serialize(_ value: UInt32) -> Data {
        value.data
    }
    
    public func serialize(_ input: BitcoinTransactionInput) -> Data {
        var data = Data()
        
        data += input.previousHash
        data += UInt32(input.previousIndex).data
        data += VarInt(value: input.script.data.count).data
        data += input.script.data
        data += input.sequence.data
        
        return data
    }
    
    public func serialize(_ inputs: [BitcoinTransactionInput]) -> Data {
        VarInt(value: inputs.count).data + inputs.map({ $0.payload }).reduce(Data(), +)
    }
    
    public func serialize(_ output: BitcoinTransactionOutput) -> Data {
        var data = Data()

        data += output.value.data
        data += VarInt(value: output.script.data.count).data
        data += output.script.data
        
        return data
    }
    
    public func serialize(_ outputs: [BitcoinTransactionOutput]) -> Data {
        VarInt(value: outputs.count).data + outputs.map({ $0.payload }).reduce(Data(), +)
    }
    
    public func serialize(_ witness: Data?) -> Data {
        witness ?? Data()
    }
    
    
    public func transaction<Transaction: BitcoinTransactionProtocol>(from data: Data) throws -> Transaction {
        let version = data.subdata(in: 0..<4).to(type: UInt32.self)
        
        let witnessMarker = data[4]
        let witnessFlag = data[5]
        
        var length = 4
        
        let containWitness = witnessMarker == 0x00 && witnessFlag == 0x01
        
        if containWitness {
            length += 2
        }
    
        let txinputs = (try? inputs(from: data.subdata(in: length..<data.count))) ?? []
        
        length += txinputs.map({ $0.payload.count }).reduce(0, +) + 1
        
        let txoutputs = (try? outputs(from: data.subdata(in: length..<data.count))) ?? []
        
        length += txoutputs.map({ $0.payload.count }).reduce(0, +) + 1
        
        var bitcoinWitness: BitcoinWitness?
        if containWitness {
            bitcoinWitness = try witness(from: data.subdata(in: length..<data.count), inputsCount: txinputs.count)
        }

        length += bitcoinWitness?.length ?? 0

        let locktime = data.subdata(in: length..<data.count).to(type: UInt32.self)
        
        let settings = BitcoinTransactionSettings.new
            .version(version)
            .lockTime(locktime)
        
        if containWitness {
            settings
                .witness(marker: witnessMarker, flag: witnessFlag)
                .allowed(scriptTypes: txinputs.map({ $0.script.type }))
        }
        
        let tx = Transaction(inputs: txinputs, outputs: txoutputs, settings: settings)
        
        if let witnessTransaction = (tx as? BitcoinTransaction) {
            witnessTransaction.witness = bitcoinWitness?.data
        }
        
        return tx
    }
    
    public func inputs(from data: Data) throws -> [BitcoinTransactionInput] {
        var _data = data
        guard let inputsCount = VarInt.value(from: _data) else {
            throw BitcoinCreateTransactionError.privateKeyNotFound
        }
        
        _data = _data.subdata(in: 1..<_data.count)
        var _inputs = [BitcoinTransactionInput]()
        
        var offset = 0
        for _ in 0..<Int(inputsCount.value) {
            _data = _data.subdata(in: offset..<_data.count)

            if let _input = try? input(from: _data) {
                offset = _input.payload.count
                _inputs.append(_input)
            }
        }
        
        return _inputs
    }
    
    public func outputs(from data: Data) throws -> [BitcoinTransactionOutput] {
        var _data = data
        
        guard let outputsCount = VarInt.value(from: _data) else {
            throw BitcoinCreateTransactionError.privateKeyNotFound
        }
        
        _data = _data.subdata(in: 1..<_data.count)

        var _outputs = [BitcoinTransactionOutput]()

        var outputOffset = 0
        for _ in 0..<Int(outputsCount.value) {
            _data = _data.subdata(in: outputOffset..<_data.count)

            if let _output = try? output(from: _data) {
                outputOffset = _output.payload.count
                _outputs.append(_output)
            }
        }
        
        return _outputs
    }
    
    public func input(from data: Data) throws -> BitcoinTransactionInput {
        let hashRange = 0..<32
        let indexRange = 32..<36
        let scriptLengthRange = 36..<37
        
        guard let scriptLength = VarInt.value(from: data.subdata(in: scriptLengthRange)) else {
            throw BitcoinCreateTransactionError.privateKeyNotFound
        }
        
        let scriptRange = 37..<(37 + Int(scriptLength.value))
        
        let hash = data.subdata(in: hashRange)
        let index = data.subdata(in: indexRange)
        let script = data.subdata(in: scriptRange)
        
        let sequenceRange = scriptRange.upperBound..<(scriptRange.upperBound) + 4
        
        let sequence = data.subdata(in: sequenceRange)

        return BitcoinTransactionInput(hash: hash,
                                       id: hash.hex,
                                       index: index.to(type: Int.self),
                                       value: 0,
                                       script: (try? BitcoinScript(data: script)) ?? BitcoinScript(),
                                       sequence: sequence.to(type: UInt32.self))
    }
    
    public func output(from data: Data) throws -> BitcoinTransactionOutput {
        let valueRange = 0..<8
        let scriptLengthRange = 8..<9
        
        guard let scriptLength = VarInt.value(from: data.subdata(in: scriptLengthRange)) else {
            throw BitcoinCreateTransactionError.privateKeyNotFound
        }
        
        let scriptRange = 9..<(9 + Int(scriptLength.value))
        
        let value = data.subdata(in: valueRange)
        let script = data.subdata(in: scriptRange)
        
        return BitcoinTransactionOutput(amount: value.to(type: UInt64.self), script: try? BitcoinScript(data: script))
    }
    
    public func witness(from data: Data, inputsCount: Int) throws -> BitcoinWitness {
        var _data = data
        let witness = BitcoinWitness()
        
        for _ in 0..<inputsCount {
            switch _data[0] {
            case 0x00:
                witness.add(components: [_data.subdata(in: 0..<1)])
                
                _data = _data.subdata(in: 1..<_data.count)
                
            default:
                guard let count = VarInt.value(from: _data) else {
                    throw BitcoinCreateTransactionError.privateKeyNotFound
                }
                
                _data = _data.subdata(in: count.length..<_data.count)
    
                var components: [Data] = []
                
                for _ in 0..<Int(count.value) {
                    if let (value, length) = VarInt.value(from: _data) {
                        _data = _data.subdata(in: length..<_data.count)
                        
                        components.append(_data.subdata(in: 0..<Int(value)))
                        _data = _data.subdata(in: Int(value)..<_data.count)
                    }
                }
                
                witness.add(components: components)
            }
        }
        
        return witness
    }
}
