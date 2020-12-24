//
//  BitcoinSignatureHashBuilder.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public class SignatureHashBuilder<Transaction: BitcoinTransactionProtocol> {
    let transaction: Transaction
    let serializer: BitcoinTransactionSerializer
    
    public init(transaction: Transaction, serializer: BitcoinTransactionSerializer) {
        self.transaction = transaction
        self.serializer = serializer
    }
    
    public func hash(for script: BitcoinScript, key: Key, index: Int, hashType: SignatureHashType) -> Data {
        switch transaction {
        case is BitcoinTransaction:
            switch script.type {
            case .P2WPKH, .P2WSH, .P2SH:
                let scriptCode =  Data(hex: "0x1976a914") + key.publicKeyCompressed(.CompressedConversion).ripemd160sha256() + Data(hex: "0x88ac")
                return signatureHashBitcoinWitness(for: script, scriptCode: scriptCode, index: index, hashType: hashType)
            default:
                return signatureHashBitcoin(for: script, index: index, hashType: hashType)
            }
            
        case is BitcoinCashTransaction:
            return signatureHashBitcoinCash(for: script, index: index, hashType: hashType)
            
        default:
            return Data()
        }
    }
    
    private func signatureHashBitcoin(for script: BitcoinScript, index: Int, hashType: SignatureHashType) -> Data {
        var inputs: [BitcoinTransactionInput] = []
        var outputs: [BitcoinTransactionOutput] = []

        if hashType.isAnyOneCanPay {
            inputs = [transaction.inputs[index].makeBlankInput(includeScript: true, hashType: hashType)]
        } else {
            for (inputIndex, input) in transaction.inputs.enumerated() {
                inputs.append(input.makeBlankInput(includeScript: index == inputIndex, hashType: hashType))
            }
        }

        if hashType.isSingle {
            let output = transaction.outputs[index]
            outputs = Array(repeating: BitcoinTransactionOutput(), count: index) + [output]
        }

        if !hashType.isNone {
            outputs = transaction.outputs
        }

        let txpayload = serializer.serialize(transaction.version) +
                        serializer.serialize(inputs) +
                        serializer.serialize(outputs) +
                        serializer.serialize(transaction.lockTime)
        
        let data = txpayload + UInt32(hashType.outputType).data
        let hash = data.sha256sha256()

        return hash
    }
    
    private func signatureHashBitcoinWitness(for script: BitcoinScript, scriptCode: Data, index: Int, hashType: SignatureHashType) -> Data {
        var inputs: [BitcoinTransactionInput] = []

        var payload = Data()
        
        //1.Version of the transaction (4-byte little endian)
        payload.append(transaction.version.littleEndian.data)

        //2.HashPrevouts (32-byte hash)
        for (inputIndex, input) in transaction.inputs.enumerated() {
            inputs.append(input.makeBlankInput(includeScript: index == inputIndex, hashType: hashType))
        }

        if !hashType.isAnyOneCanPay {
            var inputsData = Data()

            inputs.forEach({
                inputsData.append($0.previousHash + UInt32($0.previousIndex).littleEndian.data)
            })
            let prevOutsHash = inputsData.sha256sha256()
            payload.append(prevOutsHash)
        } else {
            payload.append(Data(count: 32))
        }
        
        //3.HashSequence (32-byte hash)
        if !hashType.isAnyOneCanPay && !hashType.isSingle && !hashType.isNone {
            var sequenceData = Data()
            inputs.forEach({
                sequenceData.append($0.sequence.data)
            })

            let sequenceHash = sequenceData.sha256sha256()
            payload.append(sequenceHash)
        } else {
            payload.append(Data(count: 32))
        }

        //4.Outpoint (32-byte hash + 4-byte little endian)
        let outpoint = inputs[index].previousHash + UInt32(inputs[index].previousIndex).littleEndian.data
        payload.append(outpoint)

        //5.ScriptCode of the input (serialized as scripts inside CTxOuts)
        payload.append(scriptCode)

        //6.Value of the output spent by this input (8-byte little endian)
        let amount = inputs[index].value.littleEndian.data
        payload.append(amount)

        //7.Sequence of the input (4-byte little endian)
        let sequence = inputs[index].sequence.littleEndian.data
        payload.append(sequence)

        //8.HashOutputs (32-byte hash)
        if !hashType.isSingle && !hashType.isNone {
            var outputsData = Data()
            transaction.outputs.forEach({
                outputsData.append($0.payload)
            })
            let outputsHash = outputsData.sha256sha256()

            payload.append(outputsHash)
        } else if hashType.isSingle && index < transaction.outputs.count {
            var outputsData = Data()
            outputsData.append(transaction.outputs[index].payload)

            let outputsHash = outputsData.sha256sha256()

            payload.append(outputsHash)
        } else {
            payload.append(Data(count: 32))
        }

        //9.Locktime of the transaction (4-byte little endian)
        let hashLockTime = UInt32(transaction.lockTime).littleEndian.data
        payload.append(hashLockTime)

        //10.Sighash type of the signature (4-byte little endian)
        let typeData = UInt32(hashType.value).data
        payload.append(typeData)

        return payload.sha256sha256()
    }
    
    private func signatureHashBitcoinCash(for script: BitcoinScript, index: Int, hashType: SignatureHashType) -> Data {
        var data = Data()
        
        //1.Version
        let txversion = transaction.version.littleEndian.data
        data.append(txversion)
        
        //2.PrevOutsHash
        var inputsData = Data()
        transaction.inputs.forEach({
            inputsData.append($0.previousHash + UInt32($0.previousIndex).littleEndian.data)
        })
        
        let prevOutsHash = inputsData.sha256sha256()
        data.append(prevOutsHash)
        
        let sequenceData = Data(repeating: UInt8.max, count: transaction.inputs.count * 4)
        //3.SequenceHash
        let sequenceHash = sequenceData.sha256sha256()
        data.append(sequenceHash)
        
        //4.PreviousTransactionHash
        data.append(transaction.inputs[index].previousHash)
    
        //5.InputIndex
        let inputIndex = UInt32(transaction.inputs[index].previousIndex).littleEndian.data
        data.append(inputIndex)
        
        //6.ScriptDataCount
        let scriptDataCount = UInt8(transaction.inputs[index].script.data.count).data
        data.append(scriptDataCount)
        
        //7.ScriptData
        data.append(transaction.inputs[index].script.data)
        
        //8.Amount
        let amountData = transaction.inputs[index].value.littleEndian.data
        data.append(amountData)
        
        //9.Sequence
        data.append(transaction.inputs[index].sequence.littleEndian.data)
        
        //10.OutputsHash
        var outputsData = Data()
        transaction.outputs.forEach({
            outputsData.append($0.payload)
        })
        let outputsHash = outputsData.sha256sha256()
        data.append(outputsHash)
        
        //11.Locktime
        let locktime = UInt32(transaction.lockTime).data
        data.append(locktime)
        
        //12.Type
        let typeData = UInt32(hashType.value).data
        data.append(typeData)
        
        return data.sha256sha256()
    }
}
