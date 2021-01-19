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
    
    public init(amount: UInt64, script: BitcoinScript?) {
        self.value = amount
        self.script = script ?? BitcoinScript()
    }
    
    var payload: Data {
        BitcoinTransactionSerializer().serialize(self)
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
