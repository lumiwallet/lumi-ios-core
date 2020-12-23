//
//  AddressesCommon.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

// - MARK: Common

public struct CoinVersionBytesConstant {
    public static let bitcoin_p2pkh: UInt8 = 0x00
    public static let bitcoin_p2sh: UInt8 = 0x05
    public static let bitcoin_p2wpkh: UInt8 = 0x06
    public static let bitcoin_p2wsh: UInt8 = 0x0A
    
    public static let bitcoin_prvkey_version = 0x80
    
    public static let doge_p2pkh: UInt8 = 0x1E
    public static let doge_p2sh: UInt8 = 0x16
    
    public static let doge_prvkey_version: UInt8 = 0x9E
}

// - MARK: Bitcoin

/// Contains constants for work with BitcoinPublicKeyAddress, BitcoinPrivateKeyAddress
/// - publicKeyAddressVersion: 0
/// - publicKeyDataLength: 33
/// - publicKeyHashDataLength: 21
/// - publicKeyScriptHashLength: 21
/// - privateKeyAddressVersion: 128
/// - privateKeyDataLength: 32
public struct BitcoinAddressConstants {
    //BIP-141 Defined witness program version
    static let witnessProgramVersionByte: UInt8 = 0x00
    static let witnessProgramWPKHLength = 20
    static let witnessProgramWSHLength = 32
    
    static let privateKeyAddressVersion: UInt8 = 0x80
    
    static let privateKeyDataLength = 32
    static let publicKeyDataLength = 33
    
    static let publicKeyHashDataLength = 21
    static let publicKeyScriptHashLength = 21
    
    public static let bc1prefix = "bc"
    public static let bc1separator = "1"
    public static let bc1hrp = bc1prefix + bc1separator
}


// - MARK: BitcoinCash

public struct BitcoinCashAddressConstants {
    static let prefix = "bitcoincash"
    static let separator = ":"
}


// - MARK: Ethereum

/// Contains constants for work with EthereumAddress
/// - publicKeyDataLength: 65 (uncompressed public key)
public struct EthereumAddressConstants {
    static let publicKeyDataLength = 65
}
