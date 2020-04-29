//
//  EosTransactionTestData.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
@testable import LumiCore


struct EosTransactionTestData {
    let account: String
    let transactionAction: EosTransactionAction
    let authorization: EosAuthorization
    let refBlockNum: Int
    let refBlockPrefix: Int
    let expiration: TimeInterval
    let chainID: String
    let packedTransactionData: String
    let signature: String
    let bin: String
}

struct EosTestData {
    static let data: [EosTransactionTestData] = [
        EosTransactionTestData(account: "eosio.token",
                               transactionAction: .transfer(account: "eosio.token", from: "testaccount1", to: "testaccount2", quanity: "0.0001 EOS", memo: "Memo"),
                               authorization: EosAuthorization(actor: "testaccount1", permission: "active"),
                               refBlockNum: 103423741,
                               refBlockPrefix: 2142807285,
                               expiration: 1580811780.835552,
                               chainID: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906",
                               packedTransactionData: "0446395efd1ef5a4b87f000000000100a6823403ea3055000000572d3ccdcd0110f2d4142193b1ca00000000a8ed32322510f2d4142193b1ca20f2d4142193b1ca010000000000000004454f5300000000044d656d6f00",
                               signature: "SIG_K1_KahaM2yEwaSEPFtxuMozZXUKZwj7QUQjSgXbu9aSKd5Va72nez2eMkQprU494y9kXWApN6WjMLkmBcZufaW694mYkQ92dY",
                               bin: "10f2d4142193b1ca20f2d4142193b1ca010000000000000004454f5300000000044d656d6f"),
        
        EosTransactionTestData(account: "eosio.token",
                               transactionAction: .transfer(account: "eosio.token", from: "testaccount1", to: "testaccount2", quanity: "0.0234 EOS", memo: "Test memo"),
                               authorization: EosAuthorization(actor: "testaccount1", permission: "active"),
                               refBlockNum: 103424407, refBlockPrefix: 3099854041,
                               expiration: 1580812122.065275,
                               chainID: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906",
                               packedTransactionData: "5a47395e9721d904c4b8000000000100a6823403ea3055000000572d3ccdcd0110f2d4142193b1ca00000000a8ed32322a10f2d4142193b1ca20f2d4142193b1caea0000000000000004454f53000000000954657374206d656d6f00",
                               signature: "SIG_K1_Kjf8Zbq6xZ9bmcqpxdM3USvGGsbWF1WJ7s3969hfH4KAbQPe6GWDFNxt5vWFwzciqTytEK4HU4wNQffoiAmAMaS5eTQzdq",
                               bin: "10f2d4142193b1ca20f2d4142193b1caea0000000000000004454f53000000000954657374206d656d6f"),
        
        EosTransactionTestData(account: "eosio.token",
                               transactionAction: .transfer(account: "eosio.token", from: "testaccount1", to: "testaccount2", quanity: "0.2372 EOS", memo: "Text"),
                               authorization: EosAuthorization(actor: "testaccount1", permission: "active"),
                               refBlockNum: 103424534,
                               refBlockPrefix: 3686175321,
                               expiration: 1580812187.628165,
                               chainID: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906",
                               packedTransactionData: "9b47395e16225992b6db000000000100a6823403ea3055000000572d3ccdcd0110f2d4142193b1ca00000000a8ed32322510f2d4142193b1ca20f2d4142193b1ca440900000000000004454f5300000000045465787400",
                               signature: "SIG_K1_K1miZ1nhYsWg5ptLwa72LpQ3DHioqLe3bvPCZMvpt8kuhi2pKFtFUjJUzNz4cj4dMg7JVUEjXo4yXxqjNXeEcAZapnpKmF",
                               bin: "10f2d4142193b1ca20f2d4142193b1ca440900000000000004454f53000000000454657874"),
        
        EosTransactionTestData(account: "eosio.token",
                               transactionAction: .transfer(account: "eosio.token", from: "testaccount1", to: "testaccount2", quanity: "0.0009 EOS", memo: ""),
                               authorization: EosAuthorization(actor: "testaccount1", permission: "active"),
                               refBlockNum: 103424680,
                               refBlockPrefix: 978692224,
                               expiration: 1580812259.175832,
                               chainID: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906",
                               packedTransactionData: "e347395ea82280a8553a000000000100a6823403ea3055000000572d3ccdcd0110f2d4142193b1ca00000000a8ed32322110f2d4142193b1ca20f2d4142193b1ca090000000000000004454f53000000000000",
                               signature: "SIG_K1_KcbffKMTcAXyrJGpjBk3DYzsxfeV9Lm7DRaC9ZCUnk7T8XcMEqnv4wjVmGXFSQiwKmHbeXiFjSowB7sFdLXcuvJRafnWDo",
                               bin: "10f2d4142193b1ca20f2d4142193b1ca090000000000000004454f530000000000"),
        
        EosTransactionTestData(account: "eosdtsttoken",
                               transactionAction: .transfer(account: "eosdtsttoken", from: "testaccount1", to: "testaccount2", quanity: "1.000000000 EOSDT", memo: "Token transfer"),
                               authorization: EosAuthorization(actor: "testaccount1", permission: "active"),
                               refBlockNum: 103425537,
                               refBlockPrefix: 430708702,
                               expiration: 1580812700.1205812,
                               chainID: "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906",
                               packedTransactionData: "9c49395e0126de17ac1900000000013015a439e39c3055000000572d3ccdcd0110f2d4142193b1ca00000000a8ed32322f10f2d4142193b1ca20f2d4142193b1ca00ca9a3b0000000009454f53445400000e546f6b656e207472616e7366657200",
                               signature: "SIG_K1_KVpnAVDjDgbKYfTbttAVd1hvda769hynGrkWTtjDk3Ky5Zi3vWgakobGmGi8WsaV16PeSCR3eCsDNbwWMNN4ragsBPBTk5",
                               bin: "10f2d4142193b1ca20f2d4142193b1ca00ca9a3b0000000009454f53445400000e546f6b656e207472616e73666572")
    ]    
}
