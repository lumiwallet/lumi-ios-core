//
//  RbgNistSP800-22.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore


class RbgNistSP800_22: XCTestCase {
    
    func testRandomBitGeneration() {
        //For testing random generation algorithm install NIST SP 800-22 software using rbg_install.sh
        guard let bytes = CommonRandom.generate(length: 1500000) else {
            XCTAssert(false, "Can't generate bytes")
            return
        }
        
        //This function generates bytes for bit stream length = 12000000 and streams count = 10
        //Filename "testdata.pi"
        
        let currentPath = #file.replacingOccurrences(of: "RbgNistSP800-22.swift", with: "rbg/testdata.pi")
        FileManager.default.createFile(atPath: currentPath, contents: bytes, attributes: nil)
        
        //Run RbgNistSP800-22/rbg/assess
    }

}
