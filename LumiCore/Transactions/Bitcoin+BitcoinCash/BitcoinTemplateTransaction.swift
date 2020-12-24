//
//  BitcoinTemplateTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public protocol BitcoinTransactionProtocol: class {
    var settings: BitcoinTransactionSettings { get }
    
    var version: UInt32 { get }
    
    var inputs: [BitcoinTransactionInput] { get }
    var outputs: [BitcoinTransactionOutput] { get }
    
    var lockTime: UInt32 { get }
    
    var id: String { get }
    
    var payload: Data { get }
    var transactionHash: Data { get }
    
    init(inputs: [BitcoinTransactionInput], outputs: [BitcoinTransactionOutput], settings: BitcoinTransactionSettings)
}

/// Basic class for the bitcoin similar transactions
public class BitcoinTemplateTransaction {
    public var settings: BitcoinTransactionSettings
    
    public let inputs: [BitcoinTransactionInput]
    public let outputs: [BitcoinTransactionOutput]
    
    public var version: UInt32 {
        settings.version
    }
    
    public var lockTime: UInt32 {
        settings.lockTime
    }
    
    public var payload: Data {
        let serializer = BitcoinTransactionSerializer()
        var result = serializer.serialize(version)
        result += serializer.serialize(inputs)
        result += serializer.serialize(outputs)
        result += serializer.serialize(lockTime)
        return result
    }
    
    /// Init
    /// - Parameter inputs: Set of inputs
    /// - Parameter outputs: Set of outputs
    public required init(inputs: [BitcoinTransactionInput], outputs: [BitcoinTransactionOutput]) {
        self.settings = BitcoinTransactionSettings.bitcoinDefaults
        
        self.inputs = inputs
        self.outputs = outputs
    }
    
    required public init(inputs: [BitcoinTransactionInput], outputs: [BitcoinTransactionOutput], settings: BitcoinTransactionSettings) {
        self.settings = settings
        
        self.inputs = inputs
        self.outputs = outputs
    }
}
