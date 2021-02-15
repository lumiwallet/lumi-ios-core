//
//  RLP.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


struct RLP {

    public static func encode<T>(_ input: T) throws -> Data {
        switch input {
        case is [Any]:
            return try encode(input as! [Any])
        case is Data:
            return try encode(input as! Data)
        default:
            throw RLPErrors.wrongEncodeInputType
        }
    }

    public static func decode<T>(_ input: Data) throws -> T {
        guard !input.isEmpty else { throw RLPErrors.emptyDecodeInput }
        let decodedData = try decode(input)
        if decodedData[0] is T {
            return decodedData[0] as! T
        } else {
            throw RLPErrors.wrongDecodingType
        }
    }

    private static func encode(_ input: Data) throws -> Data {
        guard !input.isEmpty else { return emptyByte }
        if input.count == 1 && input.first! < 0x80 { return input }
        return try length(input.count, from: 0x80) + input
    }

    private static func encode(_ inputs: [Any]) throws -> Data {
        var output: Data = Data()
        for input in inputs {
            output += (try? encode(input)) ?? emptyByte
        }
        return try length(output.count, from: 0xc0) + output
    }

    private static func length(_ len: Int, from offset: Int) throws -> Data {
        switch Double(len) {
        case 0..<56:
            let value = UInt8(offset + len)
            return Data(repeating: value, count: 1)
        case 56..<pow(256.0, 8.0):
            var binary = bytesArray(from: len)
            filterZeros(in: &binary)
            let binaryLength = binary.count
            let byte = UInt8(offset + 55 + binaryLength)
            var bytes = [byte]
            bytes += binary
            return Data(bytes)
        default:
            throw RLPErrors.encodeInputIsTooLong
        }
    }

    private static func decode(_ input: Data) throws -> [Any] {
        guard input.count > 0 else { return [] }
        let decodeInfo = try length(input)
        let inputCopy = input.dropFirst(decodeInfo.offset)
        let dataList = inputCopy.prefix(decodeInfo.length)
        if decodeInfo.type == .element {
            let currentData = dataList
            let nextData = try decode(inputCopy.dropFirst(decodeInfo.length))
            return [currentData] + nextData
        } else {
            let currentData = try decode(dataList)
            let nextData = try decode(input.dropFirst(decodeInfo.offset + decodeInfo.length))
            return [currentData] + nextData
        }
    }

    private static func length(_ decodeInput: Data) throws -> LengthDecodingInfo {
        let length = decodeInput.count
        guard length > 0 else { throw RLPErrors.emptyDecodeInput }
        let firstByte = decodeInput.first!
        switch firstByte {
        case _ where firstByte < 0x80:
            //The data is a simple element if the range of the first byte(i.e. prefix) is [0x00, 0x7f], and the element is the first byte itself exactly
            return (1, 0, .element)
        case _ where firstByte < 0xb8 && length > firstByte - 0x80:
            //The data is a simple element if the range of the first byte is [0x80, 0xb7], and the element whose length is equal to the first byte minus 0x80 follows the first byte
            return try short(.element, from: decodeInput)
        case _ where firstByte < 0xc0 && length > firstByte - 0xb7:
            //The data is a simple element if the range of the first byte is [0xb8, 0xbf], and the length of the element whose length in bytes is equal to the first byte minus 0xb7 follows the first byte, and the element follows the length of the element
            return try long(.element, from: decodeInput)
        case _ where firstByte > 0xbf && firstByte < 0xf8:
            //The data is a list if the range of the first byte is [0xc0, 0xf7], and the concatenation of the RLP encodings of all items of the list which the total payload is equal to the first byte minus 0xc0 follows the first byte
            return try short(.list, from: decodeInput)
        case _ where firstByte > 0xf7 && firstByte <= 0xff:
            //The data is a list if the range of the first byte is [0xf8, 0xff], and the total payload of the list whose length is equal to the first byte minus 0xf7 follows the first byte, and the concatenation of the RLP encodings of all items of the list follows the total payload of the list
            return try long(.list, from: decodeInput)
        default:
            throw RLPErrors.decodingUndefined
        }
    }

    private static func short(_ type: RLPTypes, from input: Data) throws -> LengthDecodingInfo {
        let firstByte = input.first!
        let step: UInt8 = type == .element ? 0x80 : 0xc0
        let len = firstByte - step
        if type == .element && len == 1 && input.count > 1 {
            if [UInt8](input)[1] < 0x80 {
                throw RLPErrors.singleByteDecoding
            }
        }
        return (Int(len), 1, type)
    }

    private static func long(_ type: RLPTypes, from input: Data) throws -> LengthDecodingInfo {
        let firstByte = input.first!
        let length = input.count
        let step: UInt8 = type == .element ? 0xb7 : 0xf7
        let payload = Int(firstByte - step)
        let list = input.dropFirst().prefix(payload)
        let bytesList = [UInt8](list)
        let lenValue: Int = convertToInt(bytesList, count: payload)

        if length > payload + lenValue {
            if [UInt8](input)[1] == 0 { throw RLPErrors.leadindZeroInDecoding }
            if lenValue < 56 { throw RLPErrors.mustBeEncodedAsOneByte }
            return (lenValue, 1 + payload, type)
        }
        throw RLPErrors.longLengthDecoding
    }

    private static func bytesArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
        return withUnsafeBytes(of: value.bigEndian) { Array($0) }
    }

    private static func filterZeros(in bytes: inout [UInt8]) {
        for byte in bytes {
            if byte == 0 {
                bytes = bytes.suffix(bytes.count - 1)
            } else { break }
        }
    }

    private static func convertToInt(_ bytes: [UInt8], count: Int) -> Int {
        var intValue: Int = 0
        for i in 0..<count {
            let value = Int(bytes[i] & 0xff)
            let valueShift = value << (((count - 1) - i) * 8)
            intValue |= valueShift
        }
        return intValue
    }
}
