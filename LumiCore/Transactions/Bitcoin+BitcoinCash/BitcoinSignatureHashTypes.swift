//
//  BitcoinSignatureHashTypes.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public enum SignatureHashTypesCoins {
    case bitcoin
    case bitcoincash
}


public struct SignatureHashType {
    private static let _sighashAll: UInt8 = 0x01
    private static let _sighashNone: UInt8 = 0x02
    private static let _sighashSingle: UInt8 = 0x03
    private static let _sighashForkId: UInt8 = 0x40
    private static let _sighashAnyOneCanPay: UInt8 = 0x80
    
    private static let _sighashOutputMask: UInt8 = 0x1f
    
    public enum Bitcoin: UInt8 {
        case sighashAll = 0x01
        case sighashNone = 0x02
        case sighashSingle = 0x03
        case sighashAnyOneCanPay = 0x80
    }
    
    public enum BitcoinCash: UInt8 {
        case sighashAll = 0x41            // 0x01 | 0x40
        case sighashNone = 0x42           // 0x02 | 0x40
        case sighashSingle = 0x43         // 0x03 | 0x40
        case sighashAnyOneCanPay = 0xc0   // 0x80 | 0x40
    }
    
    public let value: UInt8
    
    public init(btc: SignatureHashType.Bitcoin) {
        value = btc.rawValue
    }
    
    public init(bch: SignatureHashType.BitcoinCash) {
        value = bch.rawValue
    }
    
    public var outputType: UInt8 {
        value & SignatureHashType._sighashOutputMask
    }
    
    public var isAll: Bool {
        outputType == SignatureHashType._sighashAll
    }
    
    public var isSingle: Bool {
        outputType == SignatureHashType._sighashSingle
    }
    
    public var isNone: Bool {
        outputType == SignatureHashType._sighashNone
    }
    
    public var isForkId: Bool {
        (value & SignatureHashType._sighashForkId) != 0
    }
    
    public var isAnyOneCanPay: Bool {
        (value & SignatureHashType._sighashAnyOneCanPay) != 0
    }
}

