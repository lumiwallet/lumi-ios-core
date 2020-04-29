//
//  BitcoinCashTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for representing and performing operations with BitcoinCash transactions
public class BitcoinCashTransaction: BitcoinTemplateTransaction {
    
    //Used for SignatureHashType == .sighashALL only
    func makeHash(for script: BitcoinScript, index: Int, hashType: SignatureHashType) -> Data {
        var data = Data()
        
        //1.Version
        let txversion = version.littleEndian.data
        data.append(txversion)
        
        //2.PrevOutsHash
        var inputsData = Data()
        _inputs.forEach({
            inputsData.append($0.previousHash + UInt32($0.previousIndex).littleEndian.data)
        })
        
        let prevOutsHash = inputsData.sha256sha256()
        data.append(prevOutsHash)
        
        let sequenceData = Data(repeating: UInt8.max, count: _inputs.count * 4)
        //3.SequenceHash
        let sequenceHash = sequenceData.sha256sha256()
        data.append(sequenceHash)
        
        //4.PreviousTransactionHash
        data.append(_inputs[index].previousHash)
    
        //5.InputIndex
        let inputIndex = UInt32(_inputs[index].previousIndex).littleEndian.data
        data.append(inputIndex)
        
        //6.ScriptDataCount
        let scriptDataCount = UInt8(_inputs[index].script.data.count).data
        data.append(scriptDataCount)
        
        //7.ScriptData
        data.append(_inputs[index].script.data)
        
        //8.Amount
        let amountData = _inputs[index].value.littleEndian.data
        data.append(amountData)
        
        //9.Sequence
        data.append(_inputs[index].sequence.littleEndian.data)
        
        //10.OutputsHash
        var outputsData = Data()
        _outputs.forEach({
            outputsData.append($0.payload)
        })
        let outputsHash = outputsData.sha256sha256()
        data.append(outputsHash)
        
        //11.Locktime
        let locktime = UInt32(lockTime).data
        data.append(locktime)
        
        //12.Type
        let typeData = UInt32(hashType.value).data
        data.append(typeData)
        
        return data.sha256sha256()
    }
    
    /// Transaction signing
    /// - Parameter keys: A set of Keys whose public addresses correspond to the inputs used to form the transaction
    public func sign(keys: [Key]) throws -> BitcoinCashTransaction {
        var signedInputs: [BitcoinTransactionInput] = []
        for (index, input) in _inputs.enumerated() {
            
            let hash = makeHash(for: input.script, index: index, hashType: SignatureHashType(bch: .sighashAll))
            let pubkeyHash = try input.script.getPublicKeyHash()
            
            guard let key = try keys.first(where: {
                let pubKeyAddress = try BitcoinPublicKeyAddress(publicKey: $0.publicKeyCompressed(.CompressedConversion))
                return pubkeyHash == pubKeyAddress.publicKeyHash
            }) else {
                throw BitcoinCreateTransactionError.privateKeyNotFound
            }

            var recid: Int = 0
            let signHashType = SignatureHashType.init(bch: .sighashAll).value
            let signature = ECDSAfunctions.sign(target: .bitcoin, data: hash, key: key.data, recid: &recid)
            
            let sigWithHashType = signature + signHashType.data
            let script = BitcoinScript()
            script.addScript(from: sigWithHashType)
            script.addScript(from: key.publicKeyCompressed(.CompressedConversion))
            
            let signedInput = BitcoinTransactionInput(hash: input.previousHash, id: input.previousID, index: input.previousIndex, value: input.value, script: script)
            signedInputs.append(signedInput)
        }
        
        return BitcoinCashTransaction(inputs: signedInputs, outputs: _outputs)
    }

}
