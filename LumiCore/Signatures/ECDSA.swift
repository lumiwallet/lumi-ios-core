//
//  ECDSA.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore.ECDSA

/// ECDSA methods:
/// - signing
/// - validate signature
/// - recovery public key
public struct ECDSAfunctions {
    
    /// Target coin, which signature algorithm will be used
    /// - bitcoin: Bitcoin/BitcionCash
    /// - bitcoin: Bitcoin/BitcionCash
    /// - eos: EOS
    public enum CoinSignTarget {
        case bitcoin
        case ethereum
        case eos
    }
    
    /// ECDSA signing
    /// - Parameter target: Target coin (determines what nonce function and signature serialize type will be used)
    /// - Parameter data: Input message (32 bytes long hash expected)
    /// - Parameter key: Private key data
    /// - Parameter recid: Inout variable for storing recovery identifier
    public static func sign(target: CoinSignTarget, data: Data, key: Data, recid: inout Int) -> Data {
        switch target {
        case .bitcoin:
            return ECDSA.sign(data, key: key, noncetype: .RFC6979, recid: &recid, outtype: .DER)
        case .ethereum:
            return ECDSA.sign(data, key: key, noncetype: .RFC6979, recid: &recid, outtype: .Compact)
        case .eos:
            return ECDSA.sign(data, key: key, noncetype: .EOS, recid: &recid, outtype: .Compact)
        }
    }
    
    /// Validate ECDSA signature
    /// - Parameter signature: Signature data
    /// - Parameter data: Message that was signed
    /// - Parameter key: Private key used for signing
    /// - Parameter type: Serialize signature type  (DER/Compact)
    public static func validate(signature: Data, data: Data, for key: Data, type: SignOutputType) -> Bool {
        switch type {
        case .Compact:
            return ECDSA.validateCompactSignature(signature, hash: data, forPublicKey: key)
        case .DER:
            return ECDSA.validateSignature(signature, hash: data, forKey: key)
        @unknown default:
            return false
        }
    }
    
    /// Recovery public key data from a signature
    /// - Parameter signature: Signature data
    /// - Parameter hash: Message that was signed
    /// - Parameter compression: Public key point conversion type Compressed/Uncompressed
    public static func recoveryPublicKey(from signature: Data, hash: Data, compression: PublickKeyCompressionType) -> Data? {
        return ECDSA.recoveryPublicKeySignature(signature, hash: hash, compression: compression)
    }
}

