//
//  RLPHelpers.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


extension RLP {
    
    public typealias LengthDecodingInfo = (length: Int, offset: Int, type: RLPTypes)

    public enum RLPErrors: Error {
        case wrongEncodeInputType
        case encodeInputIsTooLong
        case emptyDecodeInput
        case wrongDecodingType
        case singleByteDecoding
        case leadindZeroInDecoding
        case longLengthDecoding
        case mustBeEncodedAsOneByte
        case decodingUndefined
    }

    public enum RLPTypes {
        case element
        case list
    }
    
    public static var emptyByte: Data {
        return Data(repeating: 0x80, count: 1)
    }
}
