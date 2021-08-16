//
//  StringHashExtensions.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore.HashFunctions


public extension String {
    
    func keccak() -> Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return HashFunction.keccak256(from: data)
    }
    
    func sha256() -> Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return HashFunction.sha256(from: data)
    }
    
    func sha256sha256() -> Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return HashFunction.sha256Double(from: data)
    }
    
    func blake2b256() -> Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return HashFunction.blake2b256(from: data)
    }
    
    func blake2b224() -> Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return HashFunction.blake2b224(from: data)
    }
    
    func ripemd160() -> Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return HashFunction.ripemd160(from: data)
    }
    
    func ripemd160sha256() -> Data {
        guard let data = self.data(using: .utf8) else { return Data() }
        return HashFunction.ripemd160Sha256(from: data)
    }
}
