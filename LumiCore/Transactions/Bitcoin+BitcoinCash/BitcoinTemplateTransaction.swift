//
//  BitcoinTemplateTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// Basic class for the bitcoin similar transactions
public class BitcoinTemplateTransaction {
    public static let bitcoinTransactionVersion: UInt32 = 1
    
    public let _inputs: [BitcoinTransactionInput]
    public let _outputs: [BitcoinTransactionOutput]
    
    public var version: UInt32
    public var lockTime: Int
    
    public var payload: Data {
        computePayload()
    }
    
    public var transactionHash: Data {
        return payload.sha256sha256()
    }
    
    public var id: String {
        let reversed = Data(transactionHash.reversed())
        return reversed.hex
    }
    
    /// Init
    /// - Parameter inputs: Set of inputs
    /// - Parameter outputs: Set of outputs
    public required init(inputs: [BitcoinTransactionInput], outputs: [BitcoinTransactionOutput]) {
        _inputs = inputs
        _outputs = outputs
        
        version = BitcoinTransaction.bitcoinTransactionVersion
        lockTime = 0
    }
    
    private func computePayload() -> Data {
        var data = Data()
        
        data += version.data
        let inputsCountData = VarInt(value: _inputs.count).data
        data += inputsCountData
        
        for input in _inputs {
            data += input.payload
        }
        
        let outputsCountData = VarInt(value: _outputs.count).data
        data += outputsCountData
        
        for output in _outputs {
            data += output.payload
        }
        
        let lockTimeData = UInt32(lockTime).data
        data += lockTimeData
        
        return data
    }
    
}

extension BitcoinTemplateTransaction: CustomStringConvertible {
    public var description: String {
        """
        BTC/BCH TRANSACTION
        HASH: \(transactionHash.hex)
        VERSION: \(version)
        INPUTS: \(_inputs)
        OUTPUTS: \(_outputs)
        LOCKTIME: \(lockTime)
        PAYLOAD: \(payload.hex)
        """
    }
}
