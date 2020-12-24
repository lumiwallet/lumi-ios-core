//
//  BitcoinCashTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for representing and performing operations with BitcoinCash transactions
public class BitcoinCashTransaction: BitcoinTemplateTransaction, BitcoinTransactionProtocol {
    
    public var id: String {
        Data(transactionHash.reversed()).hex
    }
    
    public var transactionHash: Data {
        return payload.sha256sha256()
    }
    
    /// Transaction signing
    /// - Parameter keys: A set of Keys whose public addresses correspond to the inputs used to form the transaction
    public func sign(keys: [Key]) throws -> BitcoinCashTransaction {
        let serializer = BitcoinTransactionSerializer()
        
        var signedInputs: [BitcoinTransactionInput] = []
        for (index, input) in inputs.enumerated() {
            let pubkeyHash = try input.script.getPublicKeyHash()
            
            let scriptType = input.script.type
            
            guard let key = keys.first(where: {
                var publicKeyHash: Data
                switch scriptType {
                case .P2PK, .P2PKH, .P2WPKH:
                    publicKeyHash = BitcoinPublicKeyAddress.p2pkh(from: $0.publicKeyCompressed(.CompressedConversion))
                case .P2SH, .P2WSH, .none:
                    return false
                }
                
                return pubkeyHash == publicKeyHash
            }) else {
                throw BitcoinCreateTransactionError.privateKeyNotFound
            }
            
            let hash = SignatureHashBuilder(transaction: self, serializer: serializer).hash(for: input.script, key: key, index: index, hashType: SignatureHashType(bch: .sighashAll))

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
        
        return BitcoinCashTransaction(inputs: signedInputs, outputs: outputs, settings: settings)
    }

}


extension BitcoinCashTransaction: CustomStringConvertible {
    public var description: String {
        """
        BITCOINCASH TRANSACTION
        HASH: \(transactionHash.hex)
        VERSION: \(version)
        INPUTS: \(inputs)
        OUTPUTS: \(outputs)
        LOCKTIME: \(lockTime)
        PAYLOAD: \(payload.hex)
        """
    }
}
