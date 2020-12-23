//
//  BitcoinPrivateKeyAddress.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// Bitcoin private key address
public class BitcoinPrivateKeyAddress {
    public let wif: String
    public let data: Data
    
    /// Initialize with a private key data
    /// - Parameter privateKeyData: Private key data (should be 32 bytes long)
    /// - Throws: BitcoinCreateAddressError.invalidDataLength
    public init(privateKeyData: Data, version: UInt8 = CoinVersionBytesConstant.bitcoin_prvkey_version) throws {
        guard privateKeyData.count == BitcoinAddressConstants.privateKeyDataLength else {
            throw BitcoinCreateAddressError.invalidDataLength
        }
        
        data = privateKeyData
        let s3 = Data([version] + [UInt8](privateKeyData) + [0x01])
        wif = s3.base58(usingChecksum: true)
    }
    
    /// Initialize with a Key object
    /// - Parameter key: Key of private type
    /// - Throws: BitcoinCreateAddressError.invalidKeyType
    public init(key: Key, version: UInt8 = CoinVersionBytesConstant.bitcoin_prvkey_version) throws {
        guard key.type == .Private else {
            throw BitcoinCreateAddressError.invalidKeyType
        }

        data = key.data
        let s3 = Data([version] + [UInt8](key.data) + [0x01])
        wif = s3.base58(usingChecksum: true)
    }
    
    /// Initialize with a WIF string
    /// - Parameter wif: WIF string
    /// - Throws: BitcoinCreateAddressError.invalidWIFAddressLength, BitcoinCreateAddressError.invalidDataLength, BitcoinCreateAddressError.invalidWIFAddressVersion
    public init(wif: String) throws {
        let wifDecoded = wif.base58decode(usingChecksum: true)
        
        guard wifDecoded.count > 3 else {
            throw BitcoinCreateAddressError.invalidWIFAddressLength
        }
        
        let privateKeyData = wifDecoded.subdata(in: 1..<(wifDecoded.count - 1))
        
        let privateKeyDataLength = privateKeyData.count
        guard privateKeyDataLength == BitcoinAddressConstants.privateKeyDataLength else {
            throw BitcoinCreateAddressError.invalidDataLength
        }
        
        let versionByte = wifDecoded[0]
        
        guard versionByte == CoinVersionBytesConstant.bitcoin_prvkey_version || versionByte == CoinVersionBytesConstant.doge_prvkey_version else {
            throw BitcoinCreateAddressError.invalidWIFAddressVersion
        }
        
        self.wif = wif
        data = privateKeyData
    }
    
}
