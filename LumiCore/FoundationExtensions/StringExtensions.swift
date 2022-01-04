//
//  StringExtension.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


extension String {
    public typealias DecimalString = String
    public typealias HexString = String
}


public extension String {
    
    func dropPrefix(prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func dropSuffix(suffix: String) -> String {
        guard self.hasPrefix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    func components(maxLength: Int, backwards: Bool = false) -> [String] {
        var result: [String] = []
        for i in stride(from: 0, to: self.count, by: maxLength) {
            let str: String = backwards ? String(self.dropLast(i).suffix(maxLength)) : String(self.dropFirst(i).prefix(maxLength))
            result.append(str)
        }
        return  backwards ? result.reversed() : result
    }
}


extension String: DataConvertibleProtocol {
    public var data: Data {
        guard let result = data(using: .ascii) else { return Data() }
        return result
    }
}
