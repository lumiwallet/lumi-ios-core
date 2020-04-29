//
//  EosPublicKey.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// EOS public key
public class EosPublicKey {
    let rawPrefix = "EOS"
    
    public let data: Data
    
    /// Init with a public key data
    /// - Parameter data: Public key data (should be 33 bytes long (compressed public key))
    public init(data: Data) throws {
        guard data.count == 33 else {
            throw EosKeyError.dataLength
        }
        
        self.data = data
    }
    
    /// Raw representation of EOS public key (with 'EOS' prefix )
    public var raw: String {
        let hash = data.ripemd160().subdata(in: 0..<4)
        let string = (data + hash).base58(usingChecksum: false)
        return rawPrefix + string
    }

}
