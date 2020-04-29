//
//  BitcoinTransactionInput.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for representing and working with transaction inputs
public class BitcoinTransactionInput {
    let previousHash: Data
    let previousID: String
    let previousIndex: Int
    
    let script: BitcoinScript
    var sequence: UInt32 = 0xffffffff
    
    let value: UInt64
    
    /// Init
    /// - Parameter hash: Previous transaction hash
    /// - Parameter id: Previous transaction id
    /// - Parameter index: Previous index in transaction
    /// - Parameter value: Value in Satoshis
    /// - Parameter script: BitcoinScript object
    public init(hash: Data, id: String, index: Int, value: UInt64, script: BitcoinScript) {
        previousHash = hash
        previousID = id
        previousIndex = index
        
        self.value = value
        self.script = script
    }
    
    /// Init
    /// - Parameter hash: Previous transaction hash
    /// - Parameter id: Previous transaction id
    /// - Parameter index: Previous index in transaction
    /// - Parameter value: Value in Satoshis
    /// - Parameter script: BitcoinScript object
    /// - Parameter sequence: Sequence
    public init(hash: Data, id: String, index: Int, value: UInt64, script: BitcoinScript, sequence: UInt32) {
        previousHash = hash
        previousID = id
        previousIndex = index
        
        self.value = value
        self.script = script
        self.sequence = sequence
    }
    
    public func makeBlankInput(includeScript: Bool, hashType: SignatureHashType) -> BitcoinTransactionInput {
        if includeScript {
            let seq: UInt32 = sequence
            return BitcoinTransactionInput(hash: previousHash, id: previousID, index: previousIndex, value: value, script: script.script(without: OPCode.OP_CODESEPARATOR), sequence: seq)
        }
        
        if hashType.isNone || hashType.isSingle {
            let seq: UInt32 = 0
            return BitcoinTransactionInput(hash: previousHash, id: previousID, index: previousIndex, value: value, script: BitcoinScript(), sequence: seq)
        }
        
        return BitcoinTransactionInput(hash: previousHash, id: previousID, index: previousIndex, value: value, script: BitcoinScript(), sequence: sequence)
    }
    
    /// Convenience init
    /// - Parameter hash: Previous transaction hash
    /// - Parameter id: Previous transaction id
    /// - Parameter index: Previous transaction id
    /// - Parameter value: Value in Satoshis
    /// - Parameter scriptData: Script data
    public convenience init(hash: Data, id: String, index: Int, value: UInt64, scriptData: Data) throws {
        let _script = try BitcoinScript(data: scriptData)
        self.init(hash: hash, id: id, index: index, value: value, script: _script)
    }
    
    public var payload: Data {
        computePayload()
    }
    
    private func computePayload() -> Data {
        var data = Data()
        
        data += previousHash
        data += UInt32(previousIndex).data
        data += VarInt(value: script.data.count).data
        data += script.data
        data += sequence.data
        
        return data
    }
}


// MARK: - CustomStringConvertible

extension BitcoinTransactionInput: CustomStringConvertible {
    public var description: String {
        """
        BITCOIN_TRANSACTION_INPUT
        PREVIOUS_HASH: \(previousHash.hex)
        PREVIOUS_ID: \(previousID)
        PREVIOUS_INDEX: \(previousIndex)
        VALUE: \(value)
        SEQUENCE: \(sequence)
        SCRIPT_DATA: \(script.data.hex)
        SCRIPT: \(script)
        PAYLOAD: \(payload.hex)
        """
    }
}
