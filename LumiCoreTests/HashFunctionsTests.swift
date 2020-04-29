//
//  HashFunctionsTests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore.HashFunctions


class HashFunctionsTests: XCTestCase {

    func testKeccak256() {
        for element in KeccakTestData.data {
            let input = element.input.data(using: .utf8)!
            let result = HashFunction.keccak256(from: input)
            XCTAssertFalse(result.hex != element.output, "Wrong hash expected: \(element.output) result: \(result.hex)")
            XCTAssertFalse(input.keccak().hex != element.output, "Wrong hash expected: \(element.output) result: \(result.hex)")
            XCTAssertFalse(element.input.keccak().hex != element.output, "Wrong hash expected: \(element.output) result: \(result.hex)")
        }
    }
}

struct KeccakTestData {
    static let data: [(input: String, output: String)] = [
        ("hello world", "47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"),
        ("DkmMuK1AeR2ZCwxLEy9KR5qCZJS75GdiHr8w5whzP1S1MsEgUXxhdqNtkADMDoqVhvbvtCZ8", "11141986ee9110ece06ed3ecb1f069c93ab231c379cd64dde387e35fad8f4687"),
        ("h1234567890.........,,,,,,,,,,00000000000000000", "9fe1ef02a44491aa3ef385df46a010eae00f112364e27b2682cda55f5a68c5cf"),
        ("", "c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470")
    ]    
}
