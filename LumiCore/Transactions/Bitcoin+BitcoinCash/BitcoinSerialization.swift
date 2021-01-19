//
//  BitcoinSerialization.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public struct VarInt: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = UInt64
    public let integerValue: UInt64
    public var data: Data
    
    public init(integerLiteral value: UInt64) {
        self.init(value: value)
    }
    
    public init(value: Int) {
        self.init(value: UInt64(value))
    }
    
    public init(value: UInt64) {
        integerValue = value
        
        switch value {
        case 0..<0xfd:
            data = UInt8(value).littleEndian.data
        case 0xfd...0xffff:
            data = UInt8(0xfd).littleEndian.data + UInt16(value).littleEndian.data
        case 0x10000...0xffffffff:
            data = UInt8(0xfe).littleEndian.data + UInt32(value).littleEndian.data
        case 0x100000000...0xffffffffffffffff:
            data = UInt8(0xff).littleEndian.data + UInt64(value).littleEndian.data
        default:
            fatalError("VarInt fatal errror")
        }
    }
    
    public init(data: Data) {
        let prefix = data[0..<1].to(type: UInt8.self)
        switch prefix {
        case 0..<0xfd:
            integerValue = UInt64(prefix)
        case 0xfd:
            integerValue = UInt64(data[1...2].to(type: UInt16.self))
        case 0xfe:
            integerValue = UInt64(data[1...4].to(type: UInt32.self))
        case 0xff:
            integerValue = data[1...8].to(type: UInt64.self)
        default:
            fatalError("VarInt fatal errror")
        }
        self.data = data
    }
    
    public static func value(from input: Data) -> (value: UInt64, length: Int)? {
        let length = input.count
        if length == 0 { return (0,0) }
        
        let size = input[0]
        let _data = input.dropFirst()
        
        switch size {
        case 0..<0xfd:
            return (UInt64(size), 1)
        case 0xfd:
            return length < 3 ? nil : (UInt64(_data.to(type: UInt16.self)), 3)
        case 0xfe:
            return length < 5 ? nil : (UInt64(_data.to(type: UInt32.self)), 5)
        default:
            return length < 9 ? nil : (UInt64(_data.to(type: UInt64.self)), 9)
        }
    }
}

