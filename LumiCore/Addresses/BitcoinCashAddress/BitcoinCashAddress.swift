//
//  BitcoinCashAddress.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore.Bech32

/// BitcoinCash address
/// - legacyAddress: Base58 string representation of the public key data for Legacy format
/// - cashAddress: Bech32 string representation if the public key data for CashAddr format
public struct BitcoinCashAddress {
    let _publicKeyHash: Data
    public let legacyAddress: String
    public let cashAddress: String
    
    /// Initialize with a public key data
    /// - Parameter data: Public key data (should  be 33 bytes long (compressed public key))
    /// - Throws: BitcoinCreateAddressError.invalidDataLength
    public init(data: Data) throws {
        guard data.count == BitcoinAddressConstants.publicKeyDataLength else {
            throw BitcoinCreateAddressError.invalidDataLength
        }
        
        let s1 = data.sha256().ripemd160()
        let s2 = PublicKeyAddressHashType.bitcoincash(.P2PKH).version.data + s1
        
        _publicKeyHash = s2
        
        legacyAddress = s2.base58(usingChecksum: true)
        cashAddress = Bech32AddressCoder.encode(hrp: PublicKeyAddressHashType.bitcoincash(.P2PKH).hrp.prefix, data: s2.dropFirst(), type: .bitcoincash(.P2PKH))
    }
    
    /// Initialize with a bitcoin legacy address string
    /// - Parameter legacy: Legacy bitcoin address string
    /// - Throws: BitcoinCreateAddressError.invalidHashDataLength
    public init(legacy: String) throws {
        _publicKeyHash = legacy.base58decode(usingChecksum: true)
        
        guard _publicKeyHash.count == BitcoinAddressConstants.publicKeyHashDataLength else {
            throw BitcoinCreateAddressError.invalidHashDataLength
        }
        
        legacyAddress = _publicKeyHash.base58(usingChecksum: true)
        cashAddress = Bech32AddressCoder.encode(hrp: PublicKeyAddressHashType.bitcoincash(.P2PKH).hrp.prefix, data: _publicKeyHash.dropFirst(), type: .bitcoincash(.P2PKH))
    }
    
    /// Initialize with a CashAddr string
    /// - Parameter cashaddress: BitcoinCash address string in CashAddr format
    /// - Throws: BitcoinCreateAddressError.invalidHashDataLength
    public init(cashaddress: String) throws {
        let chunks = cashaddress.components(separatedBy: ":")
        let payload = chunks.count == 2 ? chunks[1] : cashaddress
        
        let data = Bech32AddressCoder.decode(bch: payload)
        
        _publicKeyHash = PublicKeyAddressHashType.bitcoincash(.P2PKH).version.data + data
        
        guard _publicKeyHash.count == BitcoinAddressConstants.publicKeyHashDataLength else {
            throw BitcoinCreateAddressError.invalidHashDataLength
        }
        
        legacyAddress = _publicKeyHash.base58(usingChecksum: true)
        
        cashAddress = cashaddress.dropPrefix(prefix: PublicKeyAddressHashType.bitcoincash(.P2PKH).hrp.prefix)
    }
    
    /// CashAddr formatted string without 'bitcoincash' prefix
    public var address: String {
        cashAddress
    }
    
    /// CashAddr formatted string with 'bitcoincash' prefix
    public var formattedAddress: String {
        PublicKeyAddressHashType.bitcoincash(.P2PKH).hrp.description + cashAddress
    }
}
