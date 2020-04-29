//
//  RandomFunctions.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import CommonCrypto


public struct CommonRandom {
    
    /// Generates a specified number of bytes with a random content
    /// - Parameter length: Number of bytes
    public static func generate(length: Int) -> Data? {
        var bytes = Array(repeating: UInt8(0), count: length)
        let status = CCRandomGenerateBytes(&bytes, length)

        if status != CCRNGStatus(kCCSuccess) { return nil }

        return Data(bytes)
        
    }
}
