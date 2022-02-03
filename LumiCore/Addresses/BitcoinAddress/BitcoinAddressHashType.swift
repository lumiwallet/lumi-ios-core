//
//  BitcoinAddressHashType.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

public enum BitcoinAddressHashType: String, CaseIterable {
    case P2PKH = "P2PKH"
    case P2SH = "P2SH"
    case P2WPKH = "P2WPKH"
    case P2WSH = "P2WSH"
}

public struct AddressHRP: CustomStringConvertible {
    public var prefix: String
    public var separator: String
    public var description: String { prefix + separator }
    
    public init(prefix: String, separator: String) {
        self.prefix = prefix
        self.separator = separator
    }
}

public enum PublicKeyAddressHashType: CaseIterable {
    public typealias AllCases = [PublicKeyAddressHashType]
    
    public static var allCases: [PublicKeyAddressHashType] {
        BitcoinAddressHashType.allCases.map({
            PublicKeyAddressHashType.bitcoin($0)
        }) +
        BitcoinAddressHashType.allCases.map({
            PublicKeyAddressHashType.bitcoincash($0)
        }) +
        BitcoinAddressHashType.allCases.map({
            PublicKeyAddressHashType.doge($0)
        }) +
        BitcoinAddressHashType.allCases.map({
            PublicKeyAddressHashType.bitcoinvault($0)
        }) +
        BitcoinAddressHashType.allCases.map({
            PublicKeyAddressHashType.litecoin($0)
        })
    }
    
    case bitcoin(_ type: BitcoinAddressHashType)
    case bitcoincash(_ type: BitcoinAddressHashType)
    case doge(_ type: BitcoinAddressHashType)
    case bitcoinvault(_ type: BitcoinAddressHashType)
    case litecoin(_ type: BitcoinAddressHashType)
    
    var version: UInt8 {
        switch self {
        case let .bitcoin(type):
            switch type {
            case .P2PKH: return CoinVersionBytesConstant.bitcoin_p2pkh
            case .P2SH: return CoinVersionBytesConstant.bitcoin_p2sh
            case .P2WPKH: return CoinVersionBytesConstant.bitcoin_p2wpkh
            case .P2WSH: return CoinVersionBytesConstant.bitcoin_p2wsh
            }
        case let .bitcoincash(type):
            switch type {
            case .P2PKH: return CoinVersionBytesConstant.bitcoin_p2pkh
            case .P2SH: return CoinVersionBytesConstant.bitcoin_p2sh
            case .P2WPKH: return CoinVersionBytesConstant.bitcoin_p2wpkh
            case .P2WSH: return CoinVersionBytesConstant.bitcoin_p2wsh
            }
        case let .doge(type):
            switch type {
            case .P2PKH: return CoinVersionBytesConstant.doge_p2pkh
            case .P2SH: return CoinVersionBytesConstant.doge_p2sh
            case .P2WPKH: return CoinVersionBytesConstant.bitcoin_p2wpkh
            case .P2WSH: return CoinVersionBytesConstant.bitcoin_p2wsh
            }
        case let .bitcoinvault(type):
            switch type {
            case .P2PKH: return CoinVersionBytesConstant.bitcoinvault_p2pkh
            case .P2SH: return CoinVersionBytesConstant.bitcoinvault_p2sh
            case .P2WPKH: return CoinVersionBytesConstant.bitcoin_p2wpkh
            case .P2WSH: return CoinVersionBytesConstant.bitcoin_p2wsh
            }
        case let .litecoin(type):
            switch type {
            case .P2PKH: return CoinVersionBytesConstant.litecoin_p2pkh
            case .P2SH: return CoinVersionBytesConstant.litecoin_p2sh
            case .P2WPKH: return CoinVersionBytesConstant.bitcoin_p2wpkh
            case .P2WSH: return CoinVersionBytesConstant.bitcoin_p2wsh
            }
        }
    }
    
    public var hrp: AddressHRP {
        switch self {
        case .bitcoin(.P2WPKH), .bitcoin(.P2WSH):
            return AddressHRP(prefix: "bc", separator: "1")
        case .bitcoincash(.P2PKH), .bitcoincash(.P2SH):
            return AddressHRP(prefix: "bitcoincash", separator: ":")
        case .bitcoinvault(.P2WPKH), .bitcoinvault(.P2WSH):
            return AddressHRP(prefix: "royale", separator: "1")
        case .litecoin(.P2WPKH), .litecoin(.P2SH):
            return AddressHRP(prefix: "ltc", separator: "1")
        default:
            return AddressHRP(prefix: "", separator: "")
        }
    }
    
    var typeValue: BitcoinAddressHashType {
        switch self {
        case let .bitcoin(type): return type
        case let .bitcoincash(type): return type
        case let .doge(type): return type
        case let .bitcoinvault(type): return type
        case let .litecoin(type): return type
        }
    }
    
    public static func generate(version: UInt8) -> PublicKeyAddressHashType? {
        switch version {
        case CoinVersionBytesConstant.bitcoin_p2pkh: return .bitcoin(.P2PKH)
        case CoinVersionBytesConstant.bitcoin_p2sh: return .bitcoin(.P2SH)
        case CoinVersionBytesConstant.doge_p2pkh: return .doge(.P2PKH)
        case CoinVersionBytesConstant.doge_p2sh: return .doge(.P2SH)
        case CoinVersionBytesConstant.bitcoinvault_p2pkh: return .bitcoinvault(.P2PKH)
        case CoinVersionBytesConstant.bitcoinvault_p2sh: return .bitcoinvault(.P2SH)
        case CoinVersionBytesConstant.litecoin_p2pkh: return .litecoin(.P2PKH)
        case CoinVersionBytesConstant.litecoin_p2sh: return .litecoin(.P2SH)
        default:
            return nil
        }
    }
    
    public static func validate(version: UInt8) -> Bool {
        Set(
            [CoinVersionBytesConstant.bitcoin_p2pkh,
            CoinVersionBytesConstant.bitcoin_p2sh,
            CoinVersionBytesConstant.bitcoin_p2wpkh,
            CoinVersionBytesConstant.bitcoin_p2wsh,
            CoinVersionBytesConstant.doge_p2pkh,
            CoinVersionBytesConstant.doge_p2sh,
            CoinVersionBytesConstant.bitcoinvault_p2pkh,
            CoinVersionBytesConstant.bitcoinvault_p2sh,
            CoinVersionBytesConstant.litecoin_p2pkh,
            CoinVersionBytesConstant.litecoin_p2sh]
        ).contains(version)
    }
    
    public var typeBits: UInt8 {
        switch self.typeValue {
        case .P2PKH: return 0
        case .P2SH: return 8
        default: return 0
        }
    }
    
    static public func sizeBits(from data: Data) -> UInt8 {
        switch (data.count * 8) {
        case 160: return 0
        case 192: return 1
        case 224: return 2
        case 256: return 3
        case 320: return 4
        case 384: return 5
        case 448: return 6
        case 512: return 7
        default: return 0
        }
    }
}

