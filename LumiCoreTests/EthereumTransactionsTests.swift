//
//  EthereumTransactionsTests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore


class EthereumTransactionsTests: XCTestCase {

    func testCreateEthereumTransaction() {

        for testItem in EthereumTransactionTestData.testData {
            let unspentTransaction = EthereumUnspentTransaction(chainId: UInt(testItem.chainId), nonce: testItem.nonce, amount: testItem.amount, address: testItem.address, gasPrice: testItem.gasPrice, gasLimit: testItem.gasLimit, data: testItem.data ?? "0x00")
            
            let transaction = EthereumTransaction(unspentTx: unspentTransaction)
            
            let phrase = "crowd spot cake box physical limit sniff equip bless return fly labor"
            let mnemonic = try! Mnemonic(mnemonic: phrase, pass: "", listType: .english)


            let generator = KeyGenerator(seed: mnemonic.seed)
            try! generator.generate(for: "m/44'/60'/0'/0/0")
            
            try? transaction.sign(key: generator.generated.key.data)
            generator.reset()
            
            XCTAssertFalse(testItem.resultRaw != transaction.raw, "Wrong raw transaction Expected: \(testItem.resultRaw) Result: \(transaction.raw)")
            
        }
    }
}
