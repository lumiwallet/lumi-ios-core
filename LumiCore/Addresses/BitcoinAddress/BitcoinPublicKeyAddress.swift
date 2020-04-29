//
//  BitcoinPublicKeyAddress.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore.Bech32

/// Bitcoin public key address
public class BitcoinPublicKeyAddress {
    /// Public key hash or script hash data
    let _data: Data
    
    public let hashType: BitcoinAddressHashType
    public let address: String
    
    /// Initialize with a public key data
    /// - Parameter publicKey: Public key data (should  be 33 bytes long (compressed public key))
    /// - Parameter type: Hash type of a public key address P2PKH, P2SH
    /// - Throws: BitcoinCreateAddressError.invalidDataLength
    public init(publicKey: Data, type: BitcoinAddressHashType = .P2PKH) throws {
        guard publicKey.count == BitcoinAddressConstants.publicKeyDataLength else {
            throw BitcoinCreateAddressError.invalidDataLength
        }
        
        let s1 = publicKey.sha256().ripemd160()
        var s2: Data
        switch type {
        case .P2PKH:
            s2 = s1
        case .P2SH:
            s2 = Data(hex: "0x0014") + s1
            s2 = s2.sha256().ripemd160()
        }
        
        let s3 = type.versionByte.data + s2
        
        _data = s3
        
        hashType = type
        address = s3.base58(usingChecksum: true)
    }
    
    /// Initialize with a Key object
    /// - Parameter key: Key of public or private type
    /// - Throws: BitcoinCreateAddressError.invalidKeyType, BitcoinCreateAddressError.invalidDataLength,
    public init(key: Key, type: BitcoinAddressHashType = .P2PKH) throws {
        var publicKey: Data?
        
        switch key.type {
        case .Private:
            publicKey = key.publicKeyCompressed(.CompressedConversion)
            
        case .Public:
            publicKey = key.data
            
        @unknown default:
            publicKey = nil
        }
        
        guard let data = publicKey else {
            throw BitcoinCreateAddressError.invalidKeyType
        }
        
        guard data.count == BitcoinAddressConstants.publicKeyDataLength else {
            throw BitcoinCreateAddressError.invalidDataLength
        }
        
        let s1 = data.sha256().ripemd160()
        var s2: Data
        switch type {
        case .P2PKH:
            s2 = s1
        case .P2SH:
            s2 = Data([0x00, 0x14]) + s1
            s2 = s2.sha256().ripemd160()
        }
        
        let s3 = type.versionByte.data + s2
        
        _data = s3
        
        hashType = type
        address = s3.base58(usingChecksum: true)
    }
    
    /// Initialize with a public key hash or a script hash data (with version byte in prefix)
    /// - Parameter data: Public key hash or script hash data (with version byte in prefix)
    /// - Throws: BitcoinCreateAddressError.invalidDataLength, BitcoinCreateAddressError.invalidAddressVersion
    public init(data: Data) throws {
        guard data.count == BitcoinAddressConstants.publicKeyHashDataLength else {
            throw BitcoinCreateAddressError.invalidDataLength
        }
        
        guard let type = BitcoinAddressHashType(versionByte: data[0]) else {
            throw BitcoinCreateAddressError.invalidAddressVersion
        }
        
        let versionByte = data[0]
        guard BitcoinAddressHashType.allCases.contains(where: { $0.versionByte == versionByte }) else {
            throw BitcoinCreateAddressError.invalidAddressVersion
        }
        
        _data = data
        
        hashType = type
        address = _data.base58(usingChecksum: true)
    }
    
    /// Initialize with a base58 representation of legacy or script hash bitcoin address
    /// - Parameter base58: Legacy or script hash bitcoin address string
    /// - Throws: BitcoinCreateAddressError.invalidDataLength, BitcoinCreateAddressError.invalidDataLength
    public init(base58: String) throws {
        _data = base58.base58decode(usingChecksum: true)
        
        let dataLength = _data.count
        guard dataLength == BitcoinAddressConstants.publicKeyHashDataLength || dataLength == BitcoinAddressConstants.publicKeyScriptHashLength else {
            throw BitcoinCreateAddressError.invalidDataLength
        }
        
        let versionByte = _data[0]
        
        guard let type = BitcoinAddressHashType(versionByte: versionByte) else {
            throw BitcoinCreateAddressError.invalidAddressVersion
        }

        hashType = type
        address = base58
    }
    
    public var legacyAddress: String {
        return address
    }
    
    public var publicKeyHash: Data {
        _data
    }
}


