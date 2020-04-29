//
//  DataHashExtensions.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore.HashFunctions


public extension Data {
    
    func keccak() -> Data {
        return HashFunction.keccak256(from: self)
    }
    
    func sha256() -> Data {
        return HashFunction.sha256(from: self)
    }
    
    func sha256sha256() -> Data {
        return HashFunction.sha256Double(from: self)
    }
    
    func ripemd160() -> Data {
        return HashFunction.ripemd160(from: self)
    }
    
    func ripemd160sha256() -> Data {
        return HashFunction.ripemd160Sha256(from: self)
    }
}
