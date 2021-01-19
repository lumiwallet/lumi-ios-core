//
//  BitcoinTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


/// An object for representing and performing operations with Bitcoin transactions
public class BitcoinTransaction: BitcoinTemplateTransaction, BitcoinTransactionProtocol {
    public var witness: Data?
    
    public var id: String {
        Data(transactionHash.reversed()).hex
    }
    
    public var wtxid: String {
        Data(payload.sha256sha256().reversed()).hex
    }
    
    override public var payload: Data {
        BitcoinTransactionSerializer().serialize(self)
    }
    
    public var transactionHash: Data {
        return super.payload.sha256sha256()
    }
    
    /// Init
    /// - Parameter inputs: Set of inputs
    /// - Parameter outputs: Set of outputs
    /// - Parameter witness: Transaction witness data
    /// - Parameter settings: Transaction build settings
    convenience public init(inputs: [BitcoinTransactionInput], outputs: [BitcoinTransactionOutput], witness: Data? = nil, settings: BitcoinTransactionSettings) {
        self.init(inputs: inputs, outputs: outputs, settings: settings)
        self.witness = witness
    }
    
    /// Transaction signing
    /// - Parameter keys: A set of Keys whose public addresses correspond to the inputs used to form the transaction
    /// - Parameter signatureHashType: Hash type for signature
    public func sign(keys: [Key], signatureHashType: SignatureHashType = SignatureHashType(btc: .sighashAll)) throws -> BitcoinTransaction {
        let serializer = BitcoinTransactionSerializer()
        
        let isWitness = settings.isWitness
        let witnessScript = BitcoinWitness()
        
        var signedInputs: [BitcoinTransactionInput] = []
        
        for (index, input) in inputs.enumerated() {
            
            let pubkeyHash = try input.script.getPublicKeyHash()
            let scriptType = input.script.type
            
            guard let key = keys.first(where: {
                var publicKeyHash: Data
                switch scriptType {
                case .P2PK, .P2PKH, .P2WPKH:
                    publicKeyHash = BitcoinPublicKeyAddress.p2pkh(from: $0.publicKeyCompressed(.CompressedConversion))
                case .P2SH:
                    publicKeyHash = BitcoinPublicKeyAddress.p2sh(from: $0.publicKeyCompressed(.CompressedConversion))
                case .P2WSH:
                    publicKeyHash = BitcoinPublicKeyAddress.p2wsh(from: $0.publicKeyCompressed(.CompressedConversion))
                case .none:
                    return false
                }
                
                return pubkeyHash == publicKeyHash
            }) else {
                throw BitcoinCreateTransactionError.privateKeyNotFound
            }

            let hash = SignatureHashBuilder(transaction: self, serializer: serializer).hash(for: input.script, key: key, index: index, hashType: signatureHashType)
        
            
            var recid: Int = 0
            let signHashType = SignatureHashType.init(btc: .sighashAll).value
            let signature = ECDSAfunctions.sign(target: .bitcoin, data: hash, key: key.data, recid: &recid)
            
            
            let sigWithHashType = signature + signHashType.data
            
            let script = BitcoinScript()
            let publicKeyCompressed = key.publicKeyCompressed(.CompressedConversion)
            
            switch input.script.type {
            case .P2PK:
                script.addScript(from: sigWithHashType)
                
                if isWitness {
                    witnessScript.add(components: [Data([0x00])])
                }
            case .P2PKH:
                script.addScript(from: sigWithHashType)
                script.addScript(from: publicKeyCompressed)
                
                if isWitness {
                    witnessScript.add(components: [Data([0x00])])
                }
            case .P2WPKH:
                
                if isWitness {
                    witnessScript.add(components: [sigWithHashType, publicKeyCompressed])
                }
            case .P2SH:
                let keyhash = Data(hex: "0x0014") + publicKeyCompressed.ripemd160sha256()
                script.addScript(from: keyhash)
                
                if isWitness {
                    witnessScript.add(components: [sigWithHashType, publicKeyCompressed])
                }
            case .P2WSH:
                
                if isWitness {
                    witnessScript.add(components: [sigWithHashType, publicKeyCompressed])
                }
            default:
                throw BitcoinCreateTransactionError.privateKeyNotFound
            }
            
            let signedInput = BitcoinTransactionInput(hash: input.previousHash, id: input.previousID, index: input.previousIndex, value: input.value, script: script, sequence: input.sequence)
            signedInputs.append(signedInput)
        }
        
        return BitcoinTransaction(inputs: signedInputs, outputs: outputs, witness: witnessScript.data, settings: settings)
    }

}


extension BitcoinTransaction: CustomStringConvertible {
    public var description: String {
        """
        BITCOIN TRANSACTION
        WITNESS_HASH: \(wtxid)
        HASH: \(transactionHash.hex)
        VERSION: \(version)
        MARKER: \(settings.witness?.marker)
        FLAG: \(settings.witness?.flag)
        INPUTS: \(inputs)
        OUTPUTS: \(outputs)
        WITNESS: \(witness?.hex)
        LOCKTIME: \(lockTime)
        PAYLOAD: \(payload.hex)
        """
    }
}
