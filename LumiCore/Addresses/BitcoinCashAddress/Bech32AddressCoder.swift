//
//  Bech32AddressCoder.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

public struct Bech32AddressCoder {
    
    static public func data(from prefix: String) -> Data {
        let bytes = prefix.utf8.map({
            $0 & 0x1f
        })
        return Data(bytes)
    }
    
    static func polymod(for data: Data) -> Data {
        let generator: [UInt64] = [0x98f2bc8e61, 0x79b76d99e2, 0xf33e5fb3c4, 0xae2eabe2a8, 0x1e4f43e470]
        var checksum: UInt64 = 1

        for i in 0..<data.count {
            let value = UInt64(data[i])
            let topBits = checksum >> 35
            checksum = ((checksum & 0x07ffffffff) << 5) ^ value

            for j in 0..<generator.count {
                if (topBits >> j) & 1 == 1 {
                    checksum = checksum ^ generator[j]
                }
            }
        }

        let result = checksum ^ 1

        var bytesArray = Array(repeating: UInt8(0), count: 8)
        for i in 0..<bytesArray.count {
            bytesArray[7 - i] = UInt8( (result >> (5*i)) & UInt64(0x1f) )
        }

        return Data(bytesArray)
    }
    
    func convertBits(checksum: Data) -> Data {
        return Bech32.convertBits(checksum, from: 8, to: 5, strict: false)
    }
    
    static func encode(prefix: String, data: Data, hashType: BitcoinAddressHashType) -> String {
        let prefix = Bech32AddressCoder.data(from: prefix) + Data(count: 1)
        
        let v1 = hashType.typeBits
        let v2 = BitcoinAddressHashType.sizeBits(from: data)
        let version =  v1 + v2
        let payload = Bech32.convertBits(Data([version]) + data, from: 8, to: 5, strict: false)
        let checksum = prefix + payload + Data(count: 8)
        
        let result = payload + polymod(for: checksum)
        
        return Bech32.encode(result, converted: true)
    }
    
    static func decode(bech32: String) -> Data {
        let payloadData = Bech32.decode(bech32)
        let data = payloadData.dropFirst().dropLast(5)
    
        return data
    }
}
