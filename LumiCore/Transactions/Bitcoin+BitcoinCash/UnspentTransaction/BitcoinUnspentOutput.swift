//
//  BitcoinUnspentOutput.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// Unspent output
/// - address: Bitcoin address to which unspent output belongs
/// - value: value in Satoshi
/// - outputN: output number
/// - script: BitcoinScript object
/// - transactionHash: Transaction hash
public struct BitcoinUnspentOutput {
    public let address: String
    public let value: UInt64
    public let outputN: UInt32
    public let script: BitcoinScript
    public let transactionHash: Data
    
    public init(address: String, value: UInt64, outputN: UInt32, scriptData: Data, hashData: Data) throws {
        self.address = address
        self.value = value
        self.outputN = outputN
        let bitcoinScript = try BitcoinScript(data: scriptData)

        self.script = bitcoinScript
        self.transactionHash = hashData
    }
}


// MARK: - CustomStringConvertible

extension BitcoinUnspentOutput: CustomStringConvertible {
    
    public var description: String {
        """
        BITCOIN_UNSPENT_OUTPUT
        TRANSACTION_HASH: \(transactionHash.hex)
        ADDRESS: \(address)
        VALUE: \(value)
        OUTPUT_N: \(outputN)
        SCRIPT_DATA: \(script.data.hex)
        SCRIPT: \(script)
        """
    }
}
