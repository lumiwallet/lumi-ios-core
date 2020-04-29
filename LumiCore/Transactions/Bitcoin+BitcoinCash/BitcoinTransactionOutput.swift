//
//  BitcoinTransactionOutput.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for representing and working with transaction outputs
public class BitcoinTransactionOutput {
    public let value: UInt64
    public let script: BitcoinScript
    
    /// Init
    public init() {
        value = 0
        script = BitcoinScript()
    }
    
    /// Init
    /// - Parameter amount: Value in Satoshis
    /// - Parameter address: BitcoinPublicKeyAddress object
    public init(amount: UInt64, address: BitcoinPublicKeyAddress) {
        value = amount
        script = BitcoinScript(address: address)
    }
    
    var payload: Data {
        computePayload()
    }
    
    private func computePayload() -> Data {
        var data = Data()

        data += value.data
        data += VarInt(value: script.data.count).data
        data += script.data
        
        return data
    }
}


// MARK: - CustomStringConvertible

extension BitcoinTransactionOutput: CustomStringConvertible {
    public var description: String {
        """
        BITCOIN_TRANSACTION_OUTPUT
        VALUE: \(value)
        SCRIPT_DATA: \(script.data.hex)
        SCRIPT: \(script)
        PAYLOAD: \(payload.hex)
        """
    }
}
