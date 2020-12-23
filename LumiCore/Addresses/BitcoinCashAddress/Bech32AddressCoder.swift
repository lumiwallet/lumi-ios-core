//
//  Bech32AddressCoder.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

public struct Bech32AddressCoder {
    
    enum Generator {
        case bc1
        case bch
        
        var value: [UInt64] {
            switch self {
            case .bc1: return [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
            case .bch: return [0x98f2bc8e61, 0x79b76d99e2, 0xf33e5fb3c4, 0xae2eabe2a8, 0x1e4f43e470]
            }
        }
        
        var shift: UInt64 {
            switch self {
            case .bc1: return 25
            case .bch: return 35
            }
        }
        
        var mask: UInt64 {
            switch self {
            case .bc1: return 0x1ffffff
            case .bch: return 0x07ffffffff
            }
        }
    }
    
    static public func data(from prefix: String) -> Data {
        let bytes = prefix.utf8.map({
            $0 & 0x1f
        })
        return Data(bytes)
    }
    
    static public func hrpExpand(prefix: String) -> Data {
        let bytes = prefix.utf8.map({
            $0 & 0x1f
        })
        
        let expand = prefix.map({ ($0.asciiValue ?? 0) >> 5 }) + [0x00] + bytes.map({ $0 & 31 })
        return Data(expand)
    }
    
    static func polymod(data: Data, output: Data, gen: Generator) -> Data {
        let input = data + output
        let generator = gen.value
        
        var checksum: UInt64 = 1

        for i in 0..<input.count {
            let value = UInt64(input[i])
            let topBits = checksum >> gen.shift
            checksum = ((checksum & gen.mask) << 5) ^ value

            for j in 0..<generator.count {
                if (topBits >> j) & 1 == 1 {
                    checksum = checksum ^ generator[j]
                }
            }
        }

        let result = checksum ^ 1

        var bytes = output
        let index = bytes.count - 1
        for i in 0..<bytes.count {
            bytes[index - i] = UInt8( (result >> (5*i)) & UInt64(0x1f) )
        }

        return bytes
    }
    
    /// Using for encode Bech32 BitcoinCash addresses
    /// - Parameters:
    ///   - hrp: Human readable prefix
    ///   - data: Input data
    ///   - type: Address hash type
    /// - Returns: Bech32 encoded BitcoinCash address
    static func encode(hrp: String, data: Data, type: PublicKeyAddressHashType) -> String {
        let prefix = Bech32AddressCoder.data(from: hrp) + Data(count: 1)
        let version = type.typeBits + PublicKeyAddressHashType.sizeBits(from: data)
        
        let payload = Bech32.convertBits(version.data + data, from: 8, to: 5, strict: false)
        let checksum = polymod(data: prefix + payload, output: Data(count: 8), gen: .bch)
        
        return Bech32.encode(payload + checksum, converted: true)
    }
    
    /// Using for encode Bech32 BitcoinSegwit address aka BC1
    /// - Parameters:
    ///   - hrp: Human readable prefix
    ///   - witnessVersion: Version
    ///   - witnessProgram: Witness program data
    /// - Returns: Bech32 encoded BitcoinSegwit address
    static func encode(hrp: String, witnessVersion: UInt8, witnessProgram: Data) -> String {
        let convert = Bech32.convertBits(witnessProgram, from: 8, to: 5, strict: false)
        let payload = witnessVersion.data + convert
        
        let prefix = Bech32AddressCoder.hrpExpand(prefix: hrp)
        let checksum = Bech32AddressCoder.polymod(data: prefix + payload, output: Data(count: 6), gen: .bc1)
        
        return Bech32.encode(payload + checksum, converted: true)
    }
    
    static func decode(bch: String) -> Data {
        let payload = bch.dropPrefix(prefix: BitcoinCashAddressConstants.prefix + BitcoinCashAddressConstants.separator )
        let decoded = Bech32.decode(payload, convert: false).dropLast(8)
        let converted = Bech32.convertBits(decoded, from: 5, to: 8, strict: true)
        let result = converted.dropFirst()
        return result
    }
    
    static func decode(bc1: String) -> Data {
        let payload = bc1.dropPrefix(prefix: BitcoinAddressConstants.bc1prefix + BitcoinAddressConstants.bc1separator)
        let decoded = Bech32.decode(payload, convert: false).dropLast(6)
        let converted = Bech32.convertBits(decoded.dropFirst(), from: 5, to: 8, strict: true)
        let result = converted
        return result
    }
}
