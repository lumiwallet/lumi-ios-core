//
//  EdDSATests.swift
//  LumiCoreTests
//
//  Copyright © 2021 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore

class EdDSATests: XCTestCase {

    func testDonnaSignature() {
        let pkey = "30594d16f49fa5b407a8153c2adf3ab64a555bb83442b4aa7822402fbb90894fc1639c799f50b60876f7477da63b8b7ca76038de4979352dc0827cc5145db65e";
        let txHash = "2243261be2737a5ee34df4a3489a37f7c5356a6586d6e4154fc02fbe1c5baa01";
        let sig = "5d306acb9a41cff13a2d197dafd5de457c4ffcdfb35eb7ec63dcf15d35ed57f9ecfe424e7c805e6e60aab7bbdc9d4caa4cc1e35aded03c8e58c7176e6e91d901";

        let pkeyData = Data(hex: pkey)
        let txHashData   = Data(hex: txHash)
        
        let signature = EdDSAfunctions.signDonna(data: txHashData, key: pkeyData);
        
        XCTAssertTrue(signature.hex == sig, "Wrong signature. Expected: \(sig) Result: \(signature.hex)")
        let publicKey = CardanoKey(privateKey: pkeyData).publicKey()

        let isValid = EdDSA.validateDonnaSignature(signature, message: txHashData, forPublicKey: publicKey)
        XCTAssertTrue(isValid, "Wrong signature, validation failed")
    }
    
    
}
