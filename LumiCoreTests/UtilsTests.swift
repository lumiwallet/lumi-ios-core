//
//  UtilsTests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore
@testable import LumiCore.Bignum


class UtilsTests: XCTestCase {

    func testHex2DecimalConverter() {
        let hex = Hex2DecimalConverter.convertToHexString(fromDecimalString: "12345678987654356789089786574653423567865432325678")
        let decimal = Hex2DecimalConverter.convertToDecimalString(fromHexString: hex)
        
        XCTAssertTrue(decimal == "12345678987654356789089786574653423567865432325678", "Wrong value Expected: 12345678987654356789089786574653423567865432325678 Result: \(decimal)")
    }
    
}
