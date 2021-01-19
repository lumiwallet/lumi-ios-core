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
            
            let unspentTransaction = BitcoinTemplateUnspentTransaction<BitcoinTransaction>(amount: UInt64(testItem.amount), addresss: testItem.address, changeAddress: testItem.changeAddress, utxo: unspentOutputs, isSendAll: false, settings: .bitcoinDefaults)
            
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
    
    func testBitcoinTransactionWitnessSerialization() {
        
        let serialized = [
            "010000000001015647aa5d84752e62b644302bac936fa313dea433b385aee07e818a80eed65b3a0000000000ffffffff02409c000000000000160014765e64d138231827beeb1b65df1ed9640b9bc87688230000000000001600141edb476b9ad99824fec775e067c0f81441a0737802483045022100ad92a230d602fd392ee218e2c4c97708d20bac327994579eb8e8b7d609ef036e02202f5488c9755d5c1b3dc697a755d058447e6503c6fbcab230379be0fabd738ceb0121038714a4ce39ca2a9d417d00ea040079441e3078cf3d9e440dd3b34e2a88753fd900000000",
            
            "0100000002fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f0000000000eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac11000000",
            "01000000000102fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f00000000494830450221008b9d1dc26ba6a9cb62127b02742fa9d754cd3bebf337f7a55d114c8e5cdd30be022040529b194ba3f9281a99f2b1c0a19c0489bc22ede944ccf4ecbab4cc618ef3ed01eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac000247304402203609e17b84f6a7d30c80bfa610b5b4542f32a8a0d5447a12fb1366d7f01cc44a0220573a954c4518331561406f90300e8f3358f51928d43c212a8caed02de67eebee0121025476c2e83188368da1ff3e292e7acafcdb3566bb0ad253f62fc70f07aeee635711000000",
                          
            "0100000001db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a54770100000000feffffff02b8b4eb0b000000001976a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac0008af2f000000001976a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac92040000",
            "01000000000101db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a5477010000001716001479091972186c449eb1ded22b78e40d009bdf0089feffffff02b8b4eb0b000000001976a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac0008af2f000000001976a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac02473044022047ac8e878352d3ebbde1c94ce3a10d057c24175747116f8288e5d794d12d482f0220217f36a485cae903c713331d877c1f64677e3622ad4010726870540656fe9dcb012103ad1d8e89212f0b92c74d23bb710c00662ad1470198ac48c43f7d6f93a2a2687392040000",
            
            "0100000002fe3dc9208094f3ffd12645477b3dc56f60ec4fa8e6f5d67c565d1c6b9216b36e0000000000ffffffff0815cf020f013ed6cf91d29f4202e8a58726b1ac6c79da47c23d1bee0a6925f80000000000ffffffff0100f2052a010000001976a914a30741f8145e5acadf23f751864167f32e0963f788ac00000000",
            "01000000000102fe3dc9208094f3ffd12645477b3dc56f60ec4fa8e6f5d67c565d1c6b9216b36e000000004847304402200af4e47c9b9629dbecc21f73af989bdaa911f7e6f6c2e9394588a3aa68f81e9902204f3fcf6ade7e5abb1295b6774c8e0abd94ae62217367096bc02ee5e435b67da201ffffffff0815cf020f013ed6cf91d29f4202e8a58726b1ac6c79da47c23d1bee0a6925f80000000000ffffffff0100f2052a010000001976a914a30741f8145e5acadf23f751864167f32e0963f788ac000347304402200de66acf4527789bfda55fc5459e214fa6083f936b430a762c629656216805ac0220396f550692cd347171cbc1ef1f51e15282e837bb2b30860dc77c8f78bc8501e503473044022027dc95ad6b740fe5129e7e62a75dd00f291a2aeb1200b84b09d9e3789406b6c002201a9ecd315dd6a0e632ab20bbb98948bc0c6fb204f2c286963bb48517a7058e27034721026dccc749adc2a9d0d89497ac511f760f45c47dc5ed9cf352a58ac706453880aeadab210255a9626aebf5e29c0e6538428ba0d1dcf6ca98ffdf086aa8ced5e0d0215ea465ac00000000",
            
            "0100000002e9b542c5176808107ff1df906f46bb1f2583b16112b95ee5380665ba7fcfc0010000000000ffffffff80e68831516392fcd100d186b3c2c7b95c80b53c77e77c35ba03a66b429a2a1b0000000000ffffffff0280969800000000001976a914de4b231626ef508c9a74a8517e6783c0546d6b2888ac80969800000000001976a9146648a8cd4531e1ec47f35916de8e259237294d1e88ac00000000",
            "0100000000010280e68831516392fcd100d186b3c2c7b95c80b53c77e77c35ba03a66b429a2a1b0000000000ffffffffe9b542c5176808107ff1df906f46bb1f2583b16112b95ee5380665ba7fcfc0010000000000ffffffff0280969800000000001976a9146648a8cd4531e1ec47f35916de8e259237294d1e88ac80969800000000001976a914de4b231626ef508c9a74a8517e6783c0546d6b2888ac024730440220032521802a76ad7bf74d0e2c218b72cf0cbc867066e2e53db905ba37f130397e02207709e2188ed7f08f4c952d9d13986da504502b8c3be59617e043552f506c46ff83275163ab68210392972e2eb617b2388771abe27235fd5ac44af8e61693261550447a4c3e39da98ac02483045022100f6a10b8604e6dc910194b79ccfc93e1bc0ec7c03453caaa8987f7d6c3413566002206216229ede9b4d6ec2d325be245c5b508ff0339bf1794078e20bfe0babc7ffe683270063ab68210392972e2eb617b2388771abe27235fd5ac44af8e61693261550447a4c3e39da98ac00000000"]
        
        
        for input in serialized {
            guard let transaction: BitcoinTransaction = try? BitcoinTransactionSerializer().transaction(from: Data(hex: input)) else {
                XCTAssertNotNil(nil, "Can't parse payload")
                return
            }
            
            XCTAssertTrue(transaction.payload.hex == input, "Parse failed")
        }
    }
    
    func testCreateWitnessBitcoinTransactionP2WPKH() {
        let key1 = Key(privateKey: Data(hex: "bbc27228ddcb9209d7fd6f36b02f7dfa6252af40bb2f1cbc7a557da8027ff866"))
        let key2 = Key(privateKey: Data(hex: "619c335025c7f4012e556c2a58b2506e30b8511b53ade95ea316fd8c3286feb9"))
        
        let input1 = BitcoinTransactionInput(hash: Data(hex: "fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f"), id: Data(hex: "fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f").hex, index: 0, value: 625000000, script: try! BitcoinScript(data: Data(hex: "2103c9f4836b9a4f77fc0d81f7bcb01b7f1b35916864b9476c241ce9fc198bd25432ac")), sequence: 4294967278)
        
        let input2 = BitcoinTransactionInput(hash: Data(hex: "ef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a"), id: Data(hex: "ef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a").hex, index: 1, value: 600000000, script: try! BitcoinScript(data: Data(hex: "00141d0f172a0ecb48aee1be1f2687d2963ae33f71a1")), sequence: 4294967295)
        
        let output1 = BitcoinTransactionOutput(amount: 112340000, script: try! BitcoinScript(data: Data(hex: "76a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac")))
        let output2 = BitcoinTransactionOutput(amount: 223450000, script: try! BitcoinScript(data: Data(hex: "76a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac")))
        
        let settings = BitcoinTransactionSettings.new
            .version(1)
            .witness(marker: 0, flag: 1)
            .allowed(scriptTypes: [.P2PK, .P2PKH, .P2WPKH, .P2WSH])
            .lockTime(17)
        
        let tx = BitcoinTransaction(inputs: [input1, input2], outputs: [output1, output2], settings: settings)
        
        do {
            let signed = try tx.sign(keys: [key1, key2])
            
            let _: BitcoinTransaction = try BitcoinTransactionSerializer().transaction(from: Data(hex: "01000000000102fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f00000000494830450221008b9d1dc26ba6a9cb62127b02742fa9d754cd3bebf337f7a55d114c8e5cdd30be022040529b194ba3f9281a99f2b1c0a19c0489bc22ede944ccf4ecbab4cc618ef3ed01eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac000247304402203609e17b84f6a7d30c80bfa610b5b4542f32a8a0d5447a12fb1366d7f01cc44a0220573a954c4518331561406f90300e8f3358f51928d43c212a8caed02de67eebee0121025476c2e83188368da1ff3e292e7acafcdb3566bb0ad253f62fc70f07aeee635711000000"))
            
            XCTAssertTrue(signed.payload.hex == "01000000000102fff7f7881a8099afa6940d42d1e7f6362bec38171ea3edf433541db4e4ad969f00000000494830450221008b9d1dc26ba6a9cb62127b02742fa9d754cd3bebf337f7a55d114c8e5cdd30be022040529b194ba3f9281a99f2b1c0a19c0489bc22ede944ccf4ecbab4cc618ef3ed01eeffffffef51e1b804cc89d182d279655c3aa89e815b1b309fe287d9b2b55d57b90ec68a0100000000ffffffff02202cb206000000001976a9148280b37df378db99f66f85c95a783a76ac7a6d5988ac9093510d000000001976a9143bde42dbee7e4dbe6a21b2d50ce2f0167faa815988ac000247304402203609e17b84f6a7d30c80bfa610b5b4542f32a8a0d5447a12fb1366d7f01cc44a0220573a954c4518331561406f90300e8f3358f51928d43c212a8caed02de67eebee0121025476c2e83188368da1ff3e292e7acafcdb3566bb0ad253f62fc70f07aeee635711000000", "TransactionFailed")
        } catch {
            XCTAssertNotNil(nil, "Can't sign transaction \(error)")
        }
    }
    
    func testCreateWitnessBitcoinTransactionP2SH_P2WPKH() {
        let key = Key(privateKey: Data(hex: "eb696a065ef48a2192da5b28b694f87544b30fae8327c4510137a922f32c6dcf"))
        
        let input1 = BitcoinTransactionInput(hash: Data(hex: "db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a5477"), id: Data(hex: "db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a5477").hex, index: 1, value: 1000000000, script: try! BitcoinScript(data: Data(hex: "a9144733f37cf4db86fbc2efed2500b4f4e49f31202387")), sequence: 4294967294)

        
        let output1 = BitcoinTransactionOutput(amount: 199996600, script: try! BitcoinScript(data: Data(hex: "76a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac")))
        let output2 = BitcoinTransactionOutput(amount: 800000000, script: try! BitcoinScript(data: Data(hex: "76a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac")))
        
        let settings = BitcoinTransactionSettings.new
            .version(1)
            .witness(marker: 0, flag: 1)
            .allowed(scriptTypes: [.P2PK, .P2PKH, .P2WPKH, .P2WSH, .P2SH])
            .lockTime(1170)
        
        let tx = BitcoinTransaction(inputs: [input1], outputs: [output1, output2], settings: settings)
        
        do {
            let signed = try tx.sign(keys: [key])
            
            let _: BitcoinTransaction = try BitcoinTransactionSerializer().transaction(from: Data(hex: "01000000000101db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a5477010000001716001479091972186c449eb1ded22b78e40d009bdf0089feffffff02b8b4eb0b000000001976a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac0008af2f000000001976a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac02473044022047ac8e878352d3ebbde1c94ce3a10d057c24175747116f8288e5d794d12d482f0220217f36a485cae903c713331d877c1f64677e3622ad4010726870540656fe9dcb012103ad1d8e89212f0b92c74d23bb710c00662ad1470198ac48c43f7d6f93a2a2687392040000"))
            
            XCTAssertTrue(signed.payload.hex == "01000000000101db6b1b20aa0fd7b23880be2ecbd4a98130974cf4748fb66092ac4d3ceb1a5477010000001716001479091972186c449eb1ded22b78e40d009bdf0089feffffff02b8b4eb0b000000001976a914a457b684d7f0d539a46a45bbc043f35b59d0d96388ac0008af2f000000001976a914fd270b1ee6abcaea97fea7ad0402e8bd8ad6d77c88ac02473044022047ac8e878352d3ebbde1c94ce3a10d057c24175747116f8288e5d794d12d482f0220217f36a485cae903c713331d877c1f64677e3622ad4010726870540656fe9dcb012103ad1d8e89212f0b92c74d23bb710c00662ad1470198ac48c43f7d6f93a2a2687392040000", "TransactionFailed")
        } catch {
            XCTAssertNotNil(nil, "Can't sign transaction \(error)")
        }
    }

}
