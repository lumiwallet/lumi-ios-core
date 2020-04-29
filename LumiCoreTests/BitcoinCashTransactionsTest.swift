//
//  BitcoinCashTransactionsTest.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore


class BitcoinCashTransactionTests: XCTestCase {
    
    struct BitcoinCashTransactionTestData: Codable {
        var amount: Int64
        var fee: Int64
        var address: String
        var changeAddress: String
        var unspent: [BitcoinCashTransactionTestUsnpent]
        var sendAll: Bool
        var resultHash: String?

        struct BitcoinCashTransactionTestUsnpent: Codable {
            var address: String
            var txOutputN: UInt32
            var script: String
            var value: UInt64
            var transactionHash: Data
        }
    }
    
    func testCreateSignBitcoinCashTransaction() {
        
        let testData = BitcoinCashTransactionTest().getTestData()
        
        for testItem in testData {
            let unspentOutputs = testItem.unspent.compactMap({
                try? BitcoinUnspentOutput(address: $0.address, value: $0.value, outputN: $0.txOutputN, scriptData: Data(hex: $0.script), hashData: Data(Data(hex: $0.transactionHash).reversed()))
            })
            
            let unspentTransaction = BitcoinTemplateUnspentTransaction<BitcoinCashTransaction>(amount: UInt64(testItem.amount), addresss: testItem.address, changeAddress: testItem.changeAddress, utxo: unspentOutputs, isSendAll: false)
            
            guard let tx = try? unspentTransaction.buildTransaction(feeAmount: UInt64(testItem.fee)) else {
                XCTAssert(false, "Can't build transaction")
                return
            }
            
            let phrase = "crowd spot cake box physical limit sniff equip bless return fly labor"
            let mnemonic = try! Mnemonic(mnemonic: phrase, pass: "", listType: .english)


            let generator = KeyGenerator(seed: mnemonic.seed)
            try! generator.generate(for: "m/44'/145'/0'/0")
            var keys: [Key] = []
            for i in 0..<30 {
                let k = generator.generateChild(for: UInt(i), hardened: false)
                keys.append(k.key)
            }
            generator.reset()
            
            try! generator.generate(for: "m/44'/145'/0'/1")
            for i in 0..<30 {
                let k = generator.generateChild(for: UInt(i), hardened: false)
                keys.append(k.key)
            }
            generator.reset()
            
            guard let signedtx = try? tx.sign(keys: keys) else {
                XCTAssert(false, "Can't sign transaction")
                return
            }
            
            XCTAssertTrue(signedtx.id == testItem.resultHash, "Transaction id invalid. Expected: \(testItem.resultHash) Result \(signedtx.id)")
        }
    }
    
    func getOutputs(from testOutputs: [BitcoinCashTransactionTestData.BitcoinCashTransactionTestUsnpent]) -> [BitcoinUnspentOutput] {
        var unspentOutputs: [BitcoinUnspentOutput] = []
        for testOutput in testOutputs {
            let output = try! BitcoinUnspentOutput(address: testOutput.address, value: testOutput.value, outputN: testOutput.txOutputN, scriptData: Data(hex: testOutput.script), hashData: testOutput.transactionHash)
            unspentOutputs.append(output)
        }
        return unspentOutputs
    }

}
