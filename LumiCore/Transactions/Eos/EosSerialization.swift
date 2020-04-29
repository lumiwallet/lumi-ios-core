//
//  EosSerialization.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


class EosSerialization {
    var buffer: [UInt8]
    
    public init() {
        buffer = []
    }
    
    public func write(byte: IntegerLiteralType) {
        buffer.append(UInt8(byte))
    }
    
    public func write(short: IntegerLiteralType) {
        for i in [0, 8] {
            write(byte: (short >> i) & 0xff)
        }
    }
    
    public func write(int32: IntegerLiteralType) {
        for i in [0, 8, 16, 24] {
            write(byte: (int32 >> i) & 0xff)
        }
    }
    
    public func write(int64: IntegerLiteralType) {
        for i in [0, 8, 16, 24, 32, 40, 48, 56] {
            write(byte: (int64 >> i) & 0xff)
        }
    }
    
    public func write(uint: IntegerLiteralType) {
        var value = UInt64(uint)
        repeat {
            var byte = UInt8(value & 0x7f)
            value >>= 7
            byte |= (UInt8(value & (1 << 7)))
            write(byte: IntegerLiteralType(byte))
        } while value != 0
    }
    
    public func write(char: CUnsignedChar) {
        buffer.append(char)
    }
    
    public func write(data: Data) {
        if data.isEmpty {
            write(uint: 0)
        } else {
            write(uint: data.count)
            buffer.append(contentsOf: [UInt8](data))
        }
    }

    public func append(data: Data) {
        buffer.append(contentsOf: [UInt8](data))
    }
    
    public func write(string: String) {
        if string.isEmpty {
            write(uint: 0)
        } else {
            write(uint: string.count)
            guard let data = string.data(using: .utf8) else {
                return
            }
            buffer.append(contentsOf: [UInt8](data))
        }
    }
    
    public func long(from typeName: String) -> IntegerLiteralType {
        let maxIndex = 12
        var intCh: Int = 0
        var result: Int = 0
        
        for i in 0...maxIndex + 1 {
            if i < typeName.count && i <= maxIndex {
                let ch = typeName[typeName.index(typeName.startIndex, offsetBy: i)]
                intCh = Int(symbol(from: ch))
            }
            
            if i < maxIndex {
                intCh &= 0x1f
                intCh <<= 64 - (5 * (i + 1))
            } else {
                intCh &= 0x0f
            }
            result |= intCh
        }
        return result
    }
    
    public func code(from character: Character) -> UInt32 {
        character.unicodeScalars[character.unicodeScalars.startIndex].value
    }
    
    public func symbol(from character: Character) -> UInt32 {
        if character >= "a" && character <= "z" {
            return code(from: character) - code(from: Character("a")) + 6
        } else if character >= "1" && character <= "5" {
            return code(from: character) - code(from: Character("1")) + 1
        } else {
            return 0
        }
    }
}

extension EosSerialization {
    
    func write(authorizations: [EosAuthorization]) {
        write(uint: authorizations.count)
        for authorization in authorizations {
            write(int64: IntegerLiteralType(long(from: authorization.actor)))
            write(int64: IntegerLiteralType(long(from: authorization.permission)))
        }
    }
    
    func write(actions: [EosAct]) {
        write(uint: actions.count)
        for action in actions {
            write(int64: IntegerLiteralType(long(from: action.account)))
            write(int64: IntegerLiteralType(long(from: action.name)))
            write(authorizations: [action.authorization])
            write(data: Data(hex: action.data))
        }
    }
    
    func data(chain: String, packedTransaction: EosPackedTransaction) -> Data {
        if !chain.isEmpty {
            append(data: Data(hex: chain))
        }
        write(int32: IntegerLiteralType( UInt32(packedTransaction.transaction.expiration.timeIntervalSince1970) & 0xffffffff) )
        write(short: IntegerLiteralType( UInt32(packedTransaction.transaction.refBlockNum) & 0xffff))
        write(int32: IntegerLiteralType( UInt32(packedTransaction.transaction.refBlockPrefix) & 0xffffffff))
        write(uint: 0)
        write(uint: 0)
        write(uint: 0)
        write(uint: 0)
        write(actions: packedTransaction.transaction.acts)
        write(uint: 0)
        if !chain.isEmpty {
            append(data: Data(count: 32))
        }
        return Data(buffer)
    }
    
}
