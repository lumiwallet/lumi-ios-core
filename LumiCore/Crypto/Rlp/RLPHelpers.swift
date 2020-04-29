//
//  RLPHelpers.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


extension RLP {
    
    typealias LengthDecodingInfo = (length: Int, offset: Int, type: RLPTypes)

    enum RLPErrors: Error {
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

    enum RLPTypes {
        case element
        case list
    }
    
    static var emptyByte: Data {
        return Data(repeating: 0x80, count: 1)
    }
}
