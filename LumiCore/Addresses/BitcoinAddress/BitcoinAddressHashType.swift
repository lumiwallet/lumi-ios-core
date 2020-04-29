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
    
    public init?(versionByte: UInt8) {
        switch versionByte {
        case BitcoinAddressConstants.publicKeyAddressVersionP2PKH: self = .P2PKH
        case BitcoinAddressConstants.publicKeyAddressVersionP2SH: self = .P2SH
        default:
            return nil
        }
    }
    
    public var typeBits: UInt8 {
        switch self {
        case .P2PKH: return 0
        case .P2SH: return 8
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
    
    public var versionByte: UInt8 {
        switch self {
        case .P2PKH: return BitcoinAddressConstants.publicKeyAddressVersionP2PKH
        case .P2SH: return BitcoinAddressConstants.publicKeyAddressVersionP2SH
        }
    }
}

