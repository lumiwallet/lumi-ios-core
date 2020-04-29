//
//  EthereumAddress.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

public struct EthereumAddress {
    private let _address: String
    
    /// Init
    /// - Parameter data: Uncompressed public key data
    /// - Throws: EthereumCreateAddressError.invalidPublicKeyDataLength
    public init(data: Data) throws {
        guard data.count == EthereumAddressConstants.publicKeyDataLength else {
            throw EthereumCreateAddressError.invalidPublicKeyDataLength
        }
        
        let subdata = data.subdata(in: 1..<data.count)
        let hash = subdata.keccak()
        let subhash = hash.subdata(in: 12..<hash.count)
        _address = subhash.hex
    }
    
    /// Hexadecimal representation of the prepared public key hash
    public var address: String {
        _address
    }
    
    /// Hexadecimal representation of the prepared public key hash with '0x' prefix
    public var formattedAddress: String {
        "0x" + _address
    }
}
