//
//  NumericTypesExtensions.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public protocol DataConvertibleProtocol {
    var data: Data { get }
}

extension Int: DataConvertibleProtocol {}
extension Int8: DataConvertibleProtocol {}
extension Int16: DataConvertibleProtocol {}
extension Int32: DataConvertibleProtocol {}
extension Int64: DataConvertibleProtocol {}
extension UInt8: DataConvertibleProtocol {}
extension UInt16: DataConvertibleProtocol {}
extension UInt32: DataConvertibleProtocol {}
extension UInt64: DataConvertibleProtocol {}

extension DataConvertibleProtocol {
    public var data: Data {
        var value = self

        let pointer = withUnsafePointer(to: &value) {
            UnsafeBufferPointer(start: $0, count: 1)
        }
        
        return Data(buffer: pointer)
    }
}
