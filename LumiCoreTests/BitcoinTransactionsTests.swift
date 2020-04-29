//
//  BitcoinTransactionsTests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore


class BitcoinTransactionsTests: XCTestCase {

    struct BitcoinTransactionTestData: Codable {
        var amount: UInt64
        var fee: Int64
        var address: String
        var changeAddress: String
        var unspent: [BitcoinTransactionTestUsnpent]
        var sendAll: Bool
        var resultHash: String?

        struct BitcoinTransactionTestUsnpent: Codable {
            var address: String
            var txOutputN: UInt32
            var script: String
            var value: UInt64
            var transactionHash: Data
        }
    }
    
    func testCalculateTransactionFee() {
        let testData = BitcoinTransactionTest().getTestData()
        
        for testItem in testData {
            let utxo = testItem.unspent.compactMap({
                try? BitcoinUnspentOutput(address: $0.address, value: $0.value, outputN: $0.txOutputN, scriptData: Data(hex: $0.script), hashData: Data(Data(hex: $0.transactionHash).reversed()))
            })
            
            let _ = utxo.map({ $0.value }).reduce(0, +)
            let calculator = BtcBchFeeCalculator(amount: UInt64(testItem.amount), utxo: utxo, isSendAll: false)
            let sendAllCaluculator = BtcBchFeeCalculator(amount: 0, utxo: utxo, isSendAll: true)
            let sendAllInputsCount = utxo.count
            let sendAllTransactionSize = (148 * sendAllInputsCount) + (34 * 1) + 10
      
            do {
                let fee = try calculator.calculate(with: 20)
                let calcFee = (148 * calculator.usedInputsCount) + (34 * 2) + 10
                
                XCTAssertTrue((UInt64(calcFee * 20)) == fee, "Wrong fee value Expected: \(calcFee * 20)  Result: \(fee)")
                
                let expectedSendAllFeeValue = try sendAllCaluculator.calculate(with: 20)
                
                XCTAssertTrue((sendAllTransactionSize * 20) == expectedSendAllFeeValue, "Wrong fee value Expected: \(sendAllTransactionSize * 20)  Result: \(expectedSendAllFeeValue)")
            
            } catch let e {
                XCTAssert(false, "\(e)")
            }
        }
        
    }

    func testCreateSignBitcoinTransaction() {
        
        let testData = BitcoinTransactionTest().getTestData()
        
        for testItem in testData {
            let unspentOutputs = testItem.unspent.compactMap({
                try? BitcoinUnspentOutput(address: $0.address, value: $0.value, outputN: $0.txOutputN, scriptData: Data(hex: $0.script), hashData: Data(Data(hex: $0.transactionHash).reversed()))
            })
            
            let unspentTransaction = BitcoinTemplateUnspentTransaction<BitcoinTransaction>(amount: UInt64(testItem.amount), addresss: testItem.address, changeAddress: testItem.changeAddress, utxo: unspentOutputs, isSendAll: false)
            
            guard let tx = try? unspentTransaction.buildTransaction(feeAmount: UInt64(testItem.fee)) else {
                XCTAssert(false, "Can't build transaction")
                return
            }
            
            let phrase = "crowd spot cake box physical limit sniff equip bless return fly labor" 
            let mnemonic = try! Mnemonic(mnemonic: phrase, pass: "", listType: .english)

            let generator = KeyGenerator(seed: mnemonic.seed)
            try! generator.generate(for: "m/44'/0'/0'/0")
            var keys: [Key] = []
            for i in 0..<50 {
                let k = generator.generateChild(for: UInt(i), hardened: false)
                keys.append(k.key)
            }
            generator.reset()
            
            try! generator.generate(for: "m/44'/0'/0'/1")
            for i in 0..<50 {
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
    
    func getOutputs(from testOutputs: [BitcoinTransactionTestData.BitcoinTransactionTestUsnpent]) -> [BitcoinUnspentOutput] {
        var unspentOutputs: [BitcoinUnspentOutput] = []
        for testOutput in testOutputs {
            let output = try! BitcoinUnspentOutput(address: testOutput.address, value: testOutput.value, outputN: testOutput.txOutputN, scriptData: Data(hex: testOutput.script), hashData: testOutput.transactionHash)
            unspentOutputs.append(output)
        }
        return unspentOutputs
    }

}
