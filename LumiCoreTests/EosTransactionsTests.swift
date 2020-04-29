//
//  EosTransactionsTests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore


class EosTransactionsTests: XCTestCase {

    func testCreateEosTransactions() {
        for testItem in EosTestData.data {
            let unspentTransaction = EosUnspentTransaction(account: testItem.account, action: testItem.transactionAction)
            unspentTransaction.expiration = Date(timeIntervalSince1970: testItem.expiration)
            
            let packedTransaction = unspentTransaction.buildPackedTransaction(bin: testItem.bin, chain: testItem.chainID, blockNum: testItem.refBlockNum, blockPrefix: testItem.refBlockPrefix, authorization: EosAuthorization(actor: testItem.authorization.actor, permission: testItem.authorization.permission))
            
            let phrase = "crowd spot cake box physical limit sniff equip bless return fly labor"
            let mnemonic = try! Mnemonic(mnemonic: phrase, pass: "", listType: .english)
            
            let generator = KeyGenerator(seed: mnemonic.seed)
            
            do {
                try generator.generate(for: "m/44'/194'/0'/0/0")
                let key = try! EosKey(data: generator.generated.key.data)
                
                try packedTransaction.sign(key: key)

                XCTAssertTrue(testItem.packedTransactionData == packedTransaction.packedTrx, "Wrong packed Expected: \(testItem.packedTransactionData) Result: \(packedTransaction.packedTrx)")
                XCTAssertTrue(testItem.signature == packedTransaction.signatures.first, "Expected \(testItem.signature) Result: \(packedTransaction.signatures.first ?? "")" )
            } catch {
                XCTAssertNil(nil, "")
            }
        }
    }

}
