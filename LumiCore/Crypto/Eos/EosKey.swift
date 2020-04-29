//
//  EosKey.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public enum EosSecureEnclave: String {
    case secp256k1 = "K1"
    case secp256r1 = "R1"
    
    public var name: String {
        self.rawValue
    }
    
    public var data: Data {
        self.rawValue.data(using: .utf8) ?? Data()
    }
}

/// EOS key
public class EosKey {
    public var enclave: EosSecureEnclave
    public let data: Data
    
    /// Init
    /// - Parameter data: Private key data (should be 32 bytes long)
    public init(data: Data) throws {
        guard data.count == 32 else {
            throw EosKeyError.dataLength
        }
        
        self.enclave = .secp256k1
        self.data = data
    }
    
    /// Init with WIF (Base58 encoded string)
    /// - Parameter wif: WIF representation of a private key (e.g '5HpHagT65TZzG1PH3CSu63k8DbpvD8s5ip4nEB3kEsreAbuatmU')
    public init(wif: String) throws {
        let parts = wif.components(separatedBy: "_")
        
        if parts.count > 2 {
            guard let _enclave = EosSecureEnclave(rawValue: parts[1]) else {
                throw EosKeyError.decodeBase58
            }
            enclave = _enclave
        } else {
            enclave = .secp256k1
        }
        
        let decoded = Base58.decode(wif)
        
        guard decoded.count > 5 else {
            throw EosKeyError.decodeBase58
        }
        
        data = decoded.subdata(in: 1..<decoded.count - 4)
    }
    
    /// WIF representation of a private key (e.g '5HpHagT65TZzG1PH3CSu63k8DbpvD8s5ip4nEB3kEsreAbuatmU')
    public var wif: String {
        let version = UInt8(0x80)
        let wifData = version.data + data
        return Base58.encodeUsedChecksum(wifData)
    }
    
    public func getPublicKey() throws -> EosPublicKey {
        try EosPublicKey(data: Key(privateKey: data).publicKeyCompressed(.CompressedConversion))
    }
}
