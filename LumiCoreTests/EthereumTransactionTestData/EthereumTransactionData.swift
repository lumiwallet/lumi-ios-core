//
//  EthereumTransactionData.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


struct EthereumCreateTransactionTestData {
    var amount: String
    var address: String
    var data: String? = nil
    var resultRaw: String
    var gasLimit: String
    var gasPrice: String
    var chainId: Int
    var nonce: Int
}

struct EthereumTransactionTestData {
    static let testData: [EthereumCreateTransactionTestData] = [
        EthereumCreateTransactionTestData(amount: "4000000000000000",
                                          address: "0x02dcc1a806685569e37cbc962510daea40a83618",
                                          resultRaw: "f86a58849502f9008252089402dcc1a806685569e37cbc962510daea40a83618870e35fa931a00008025a0efcbe662e385d76eea4af97862843f05dd6c234cccb9ad29825c8781e9f4ca41a00521884c6621a3d2dffbe87c5da958d436b139c996f679a9ef315fbd5acdb930",
                                          gasLimit: "21000",
                                          gasPrice: "2500000000",
                                          chainId: 1,
                                          nonce: 88),
        
        EthereumCreateTransactionTestData(amount: "4000000000000000",
                                          address: "0x8db1f5cce38a7dbf6e7e2e71e56dbba9574ab296",
                                          resultRaw: "f86a58849502f900825208948db1f5cce38a7dbf6e7e2e71e56dbba9574ab296870e35fa931a00008026a0f9f2873e50509a7b78701d9c2ce5e99b8319d3ed24f8ff9bfc06e4227813a4f6a07713a9c18b8a0444d3d4148b16b32334ed46da90191a3f3739087bbfae6983c8",
                                          gasLimit: "21000",
                                          gasPrice: "2500000000",
                                          chainId: 1,
                                          nonce: 88),
        
        EthereumCreateTransactionTestData(amount: "1700000000000000",
                                          address: "0xdbc208a1e505c40c340468e5ffac58b141ba1f1d",
                                          resultRaw: "f86a4784caa7e9d082520894dbc208a1e505c40c340468e5ffac58b141ba1f1d87060a24181e40008026a0d34a8315ffbbd9b20c504610d0d4101989f444b57ed75becef7b8065b5ea9d68a061aac06dcb689f88ae0dd46e37b9a37d05153768b45783cffe8885bdeb59171a",
                                          gasLimit: "21000",
                                          gasPrice: "3400002000",
                                          chainId: 1,
                                          nonce: 71),
        
        EthereumCreateTransactionTestData(amount: "1",
                                          address: "0x06c156b0aad5cdd0e62257a4992e5f32a04cdb1c",
                                          resultRaw: "f8633d84144404d08252089406c156b0aad5cdd0e62257a4992e5f32a04cdb1c018026a0f8973e4ff690bb98658062c02488d7a4ce886b4b5a76489ab48eddfc0aad0371a0355f3b62c323c041515b5c77ae002090ba10a4eb7c5adef755ea0e5fcf59ac95",
                                          gasLimit: "21000",
                                          gasPrice: "340002000",
                                          chainId: 1,
                                          nonce: 61),
        
        EthereumCreateTransactionTestData(amount: "10000",
                                          address: "0x9e95ff7bf7a19dd841418eaee4db9e0556db78d8",
                                          resultRaw: "f8655b8413442244825208949e95ff7bf7a19dd841418eaee4db9e0556db78d88227108025a07f8d3c7bbd401526bcaa32922afa762e96ba2b9d8fb0348f76dde2ae333d728da06cddf8022dc53ba3901f93d16926dc1ba85cb94644fd44ce4fa281d5c2d1fba6",
                                          gasLimit: "21000",
                                          gasPrice: "323232324",
                                          chainId: 1,
                                          nonce: 91),
        
        EthereumCreateTransactionTestData(amount: "937363636",
                                          address: "0x7c9e3715911954fe724a59072a93df81cdb897c5",
                                          resultRaw: "f866648396816d825208947c9e3715911954fe724a59072a93df81cdb897c58437df08b48026a04b7a051b54f410966d826ccd566816ea1f4a5efa0ce4530bed882262e14779eaa048c191056f9d5bcc3d4865d410ccd254108b6ad5b1291080b609c82af3cc64a5",
                                          gasLimit: "21000",
                                          gasPrice: "9863533",
                                          chainId: 1,
                                          nonce: 100),
        
        EthereumCreateTransactionTestData(amount: "1937363636",
                                          address: "0x3e541c569d3602e7aa7cd55a56770db34f7d52d6",
                                          resultRaw: "f8661e8309b38d825208943e541c569d3602e7aa7cd55a56770db34f7d52d6847379d2b48025a012b059b66a8cacecf91d73ddc29cced47ea6961d6e3c5c529abf95fb7ee9d919a06149b59ad1c7c69629e5892f81493efed983095aa04532356c98062b62a2e4ba",
                                          gasLimit: "21000",
                                          gasPrice: "635789",
                                          chainId: 1,
                                          nonce: 30)
    ]
}


