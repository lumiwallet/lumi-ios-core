//
//  BitcoinTransactionConfiguration.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object containing the settings of the transaction fields, such as version, locktime, witness marker, flag, as well as a set of used script types
public class BitcoinTransactionSettings {
    var version: UInt32 = 1
    var witness: (marker: UInt8, flag: UInt8)?
    var allowedScriptTypes: [BitcoinScript.ScriptType] = [.P2PKH]
    var signatureHashType: SignatureHashType = SignatureHashType(btc: .sighashAll)
    var lockTime: UInt32 = 0
    
    public init() {}
    
    @discardableResult
    public func version(_ int: UInt32) -> BitcoinTransactionSettings {
        version = int
        return self
    }
    
    @discardableResult
    public func witness(marker: UInt8, flag: UInt8) -> BitcoinTransactionSettings {
        witness = (marker: marker, flag: flag)
        return self
    }
    
    @discardableResult
    public func allowed(scriptTypes: [BitcoinScript.ScriptType]) -> BitcoinTransactionSettings {
        allowedScriptTypes = scriptTypes
        return self
    }
    
    @discardableResult
    public func signatureHashType(type: SignatureHashType) -> BitcoinTransactionSettings {
        signatureHashType = type
        return self
    }
    
    @discardableResult
    public func lockTime(_ uint32: UInt32) -> BitcoinTransactionSettings {
        lockTime = uint32
        return self
    }
    
    public class var new: BitcoinTransactionSettings {
        BitcoinTransactionSettings()
    }
    
    public class var bitcoinDefaults: BitcoinTransactionSettings {
        BitcoinTransactionSettings()
    }
    
    public class var bitcoinWitnessDefaults: BitcoinTransactionSettings {
        BitcoinTransactionSettings()
            .witness(marker: 0, flag: 1)
            .allowed(scriptTypes: [.P2PKH, .P2SH, .P2WPKH])
            .signatureHashType(type: SignatureHashType(btc: .sighashAll))
    }
    
    public class var bitcoinCashDefaults: BitcoinTransactionSettings {
        BitcoinTransactionSettings()
            .signatureHashType(type: SignatureHashType(bch: .sighashAll))
    }
    
    public class var dogeDefaults: BitcoinTransactionSettings {
        BitcoinTransactionSettings()
    }
    
    public var isWitness: Bool {
        guard let (marker, flag) = witness, marker == 0x00, flag == 0x01 else {
            return false
        }
        return true
    }
}
