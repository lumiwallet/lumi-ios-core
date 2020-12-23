//
//  KeyGenerator.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore.Key
import CommonCrypto


public enum KeyDerivationError: Error {
    case wrongPath
}


///Key generator, allows you to generate keys in accordance with the standard described in https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki
public final class KeyGenerator {
    
    /// BIP32  hmac key
    static public let HMACKey = "Bitcoin seed"
    
    private let master: ExtendedKey
    public var generated: ExtendedKey
    
    /// Extended public key for last generated key
    public var extPub: String {
        return generated.serializedPub()
    }
    
    /// Extended private key for last generated key
    public var extPrv: String {
        return generated.serializedPrv()
    }
    
    /// Initialize with seed
    /// - Parameter seed: Seed data
    public init(seed: Data, version: VersionSLIP0132 = .P2PKH_P2SH) {
        let pass = KeyGenerator.HMACKey.data(using: .ascii)!
        let uint8seed = [UInt8](seed)
        let uint8pass = [UInt8](pass)

        let unsafeSeedPointer = uint8seed.withUnsafeBytes({ $0.baseAddress })
        let unsafePassPointer = uint8pass.withUnsafeBytes({ $0.baseAddress })
        
        let ccSha512Length = Int(CC_SHA512_DIGEST_LENGTH)
        var output = Array(repeating: UInt8(0), count: ccSha512Length)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), unsafePassPointer, pass.count, unsafeSeedPointer, seed.count, &output)
        let outputData = Data(output)
        
        let key = Key(privateKey: outputData.subdata(in: 0..<32))
        let extendedKey = ExtendedKey(key: key, chaincode: outputData.subdata(in: 32..<outputData.count), version: version)
        master = extendedKey
        generated = ExtendedKey(key: key, chaincode: outputData.subdata(in: 32..<outputData.count), version: version)
    }
    
    /// Initialize with serialized extended key string
    /// - Parameter xpubORxprv: Serialized extended public or private key
    public init(xpubORxprv: String) {
        master = ExtendedKey(serializedString: xpubORxprv)
        generated = ExtendedKey(serializedString: xpubORxprv)
    }
    
    /// Initialize with extended key
    /// - Parameter extendedKey: Extended key
    public init(extendedKey: ExtendedKey) {
        master = extendedKey
        generated = ExtendedKey(extendedKey: extendedKey)
    }
    
    /// Derive key for BIP32 deivation path
    /// - Parameter path: Derivation path string (e.g. 'm/44'/60'/0'/0')
    /// - Throws: KeyDerivationError.wrongPath
    public func generate(for path: String) throws {
        let chunks = path.replacingOccurrences(of: "m/", with: "").components(separatedBy: CharacterSet.init(charactersIn: "/"))
        if chunks.count < 1 {
            throw KeyDerivationError.wrongPath
        }
        
        for chunk in chunks {
            let isHardened = chunk.hasSuffix("'")
            
            guard let sequence: UInt32 = isHardened ? UInt32(chunk.replacingOccurrences(of: "'", with: "")) : UInt32(chunk) else {
                throw KeyDerivationError.wrongPath
            }
            
            generate(sequence: sequence, hardened: isHardened)
        }
    }
    
    /// Generates a key at the specified sequence and 'hardened' flag
    /// - Parameter sequence: Sequence value
    /// - Parameter hardened: Flag indicates whether the child key is a strong key
    public func generate(sequence: UInt32, hardened: Bool) {
        generated.derived(sequence, hardened: hardened)
    }
    
    /// Resets the generator to its initial state. Used if need to change the BIP32 path.
    public func reset() {
        generated = ExtendedKey(extendedKey: master);
    }
    
    /// Generates a child key using the last generated key
    /// - Parameter sequence: Sequence value
    /// - Parameter hardened: Flag that indicates whether the child key is a strong key
    public func generateChild(for sequence: UInt, hardened: Bool) -> ExtendedKey {
        let key = ExtendedKey(extendedKey: generated)
        key.derived(UInt32(sequence), hardened: hardened)
        return key
    }
    
}
