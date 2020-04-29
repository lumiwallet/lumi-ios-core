//
//  BitcoinTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for representing and performing operations with Bitcoin transactions
public class BitcoinTransaction: BitcoinTemplateTransaction {
    
    func makeHash(for script: BitcoinScript, index: Int, hashType: SignatureHashType) -> Data {
        var inputs: [BitcoinTransactionInput] = []
        var outputs: [BitcoinTransactionOutput] = []
        
        if hashType.isAnyOneCanPay {
            inputs = [_inputs[index].makeBlankInput(includeScript: true, hashType: hashType)]
        } else {
            for (inputIndex, input) in _inputs.enumerated() {
                inputs.append(input.makeBlankInput(includeScript: index == inputIndex, hashType: hashType))
            }
        }
        
        if hashType.isSingle {
            let output = _outputs[index]
            outputs = Array(repeating: BitcoinTransactionOutput(), count: index) + [output]
        }
        
        if !hashType.isNone {
            outputs = _outputs
        }
        
        let txpayload = BitcoinTransaction(inputs: inputs, outputs: outputs).payload
        let data = txpayload + UInt32(hashType.outputType).data
        let hash = data.sha256sha256()

        return hash
    }
    
    /// Transaction signing
    /// - Parameter keys: A set of Keys whose public addresses correspond to the inputs used to form the transaction
    public func sign(keys: [Key]) throws -> BitcoinTransaction {
        var signedInputs: [BitcoinTransactionInput] = []
        for (index, input) in _inputs.enumerated() {
            
            let hash = makeHash(for: input.script, index: index, hashType: SignatureHashType(btc: .sighashAll))
            let pubkeyHash = try input.script.getPublicKeyHash()
            
            guard let key = try keys.first(where: {
                let pubKeyAddress = try BitcoinPublicKeyAddress(publicKey: $0.publicKeyCompressed(.CompressedConversion))
                return pubkeyHash == pubKeyAddress.publicKeyHash
            }) else {
                throw BitcoinCreateTransactionError.privateKeyNotFound
            }
            
            var recid: Int = 0
            let signHashType = SignatureHashType.init(btc: .sighashAll).value
            let signature = ECDSAfunctions.sign(target: .bitcoin, data: hash, key: key.data, recid: &recid)
            
            let sigWithHashType = signature + signHashType.data
            let script = BitcoinScript()
            script.addScript(from: sigWithHashType)
            script.addScript(from: key.publicKeyCompressed(.CompressedConversion))
            
            let signedInput = BitcoinTransactionInput(hash: input.previousHash, id: input.previousID, index: input.previousIndex, value: input.value, script: script)
            signedInputs.append(signedInput)
        }
        
        return BitcoinTransaction(inputs: signedInputs, outputs: _outputs)
    }

}


