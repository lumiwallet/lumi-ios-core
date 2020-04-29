//
//  BitcoinTests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore


class BitcoinTests: XCTestCase {
   
    func testBitcoinScriptSerialization() {
        let inputData = Data(hex: "52210391e4786b4c7637c160247ad6d5702d9bb2860cbb8130d59b0fd9808a0220d50f2102e191fcff2849099988fbe1592b6788707a61401058c09ef97363c9d96c43a0cf21027f10a51295e8e96d5957f3665168426249a006e548e48cbfa5882d2bf89ab67e2103d39801bafef0cc3c211101a54a47874c0a835efa2c17c47ebbe380c803345a2354ae")
        let script = try? BitcoinScript(data: inputData)
        XCTAssertNotNil(script, "Can't init script")
    }
    
    func testBitcoinScriptStandart() {
        guard let script = try? BitcoinScript(data: Data(hex: "76a9147ab89f9fae3f8043dcee5f7b5467a0f0a6e2f7e188ac")) else {
            XCTAssertFalse(false, "Can't init script")
            return
        }
        
        XCTAssertTrue(script.isPayToPublicKeyHashScript(), "Should be hash160 script")
        
        let address = try! BitcoinPublicKeyAddress(base58: "1CBtcGivXmHQ8ZqdPgeMfcpQNJrqTrSAcG")
        let scriptAddress = BitcoinScript(address: address)
        XCTAssertFalse(script.data != scriptAddress.data, "result \(script.data.hex) expected: \(scriptAddress.data.hex ) Should be equal")
        
    }
    
    func testBitcoinSerialization() {
        for element in BitcoinSerializationTestData.data {
            let data = VarInt(integerLiteral: element.variable).data
            XCTAssertFalse(data.hex != element.expectedHex, "Wrong data Expexted: \(element.expectedHex) Result: \(data.hex)")
            
            let bytes = Data(hex: element.expectedHex)
            let varInt = VarInt(data: bytes)
            XCTAssertFalse(varInt.integerValue != element.variable, "Wrong data Expexted: \(varInt.integerValue) Result: \(element.variable)")
        }
    }
}

struct BitcoinSerializationTestData {
    static var data: [(variable: UInt64, expectedHex: String)] = [
    (0, "00"),
    (252, "fc"),
    (255, "fdff00"),
    (12345, "fd3930"),
    (65535, "fdffff"),
    (1234567890, "fed2029649"),
    (1234567890123, "ffcb04fb711f010000")
    ]
}
