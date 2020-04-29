//
//  AddressesCommon.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

// - MARK: Bitcoin

/// Contains constants for work with BitcoinPublicKeyAddress, BitcoinPrivateKeyAddress
/// - publicKeyAddressVersion: 0
/// - publicKeyDataLength: 33
/// - publicKeyHashDataLength: 21
/// - publicKeyScriptHashLength: 21
/// - privateKeyAddressVersion: 128
/// - privateKeyDataLength: 32
public struct BitcoinAddressConstants {
    static let publicKeyAddressVersionP2PKH: UInt8 = 0x00
    static let publicKeyAddressVersionP2SH: UInt8 = 0x05
    static let publicKeyAddressVersionP2WPKH: UInt8 = 0x06
    static let publicKeyAddressVersionP2WSH: UInt8 = 0x0A
    
    //BIP-141 Defined witness program version
    static let witnessProgramVersionByte: UInt8 = 0x00
    
    static let privateKeyAddressVersion: UInt8 = 0x80
    
    static let privateKeyDataLength = 32
    static let publicKeyDataLength = 33
    
    static let publicKeyHashDataLength = 21
    static let publicKeyScriptHashLength = 21
    
    static let bitcoinBech32Prefix = "bc"
}


// - MARK: BitcoinCash

public struct BitcoinCashAddressConstants {
    static let bitcoinCashAddressPrefix = "bitcoincash"
}


// - MARK: Ethereum

/// Contains constants for work with EthereumAddress
/// - publicKeyDataLength: 65 (uncompressed public key)
public struct EthereumAddressConstants {
    static let publicKeyDataLength = 65
}
