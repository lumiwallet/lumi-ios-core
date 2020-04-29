//
//  BitcoinCashTransactionData.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


struct BitcoinCashUnspentOutputTestData {
    var script: String
    var value: UInt64
    var transactionHash: String
    var txOutputN: UInt32
    var address: String
}

struct BitcoinCashTransactionTestData {
    var amount: Int64
    var address: String
    var fee: Int64
    var changeAddress: String
    var sendAll: Bool
    var unspent: [BitcoinCashUnspentOutputTestData]
    var resultHash: String
}

class BitcoinCashTransactionTest {

    func getTestData() -> [BitcoinCashTransactionTestData] {
        let unspents: [BitcoinCashUnspentOutputTestData] =
        [
            BitcoinCashUnspentOutputTestData(script: "76a914cf95c4bc40fdc8bb14434615916839b2015a79f288ac",
                                             value: 1000,
                                             transactionHash: "0ffe161640e43077e6f7bf875c00be69c2cba344ba923bbf039cd5ca6fec041a",
                                             txOutputN: 0,
                                             address: "1KvcHonBsr8xthqm1wWvLTz5TReFneHmyT"),
            
            BitcoinCashUnspentOutputTestData(script: "76a91481a1c53efdfbf5f69b407738f3d2735d66dab94f88ac",
                                             value: 1000,
                                             transactionHash: "1ccc25d418db6f8607260cbb6d69620cf3c0bd6e50035b950419f86076e1b27f",
                                             txOutputN: 0,
                                             address: "1CpRxkuWeVJKKBBVYxNRhjnS4xAXnyUpZ4"),
            
            BitcoinCashUnspentOutputTestData(script: "76a914b8c9ce55b788268de6d9c189c22f24ce80f8abba88ac",
                                             value: 10000,
                                             transactionHash: "b2449abf8985b5909932636843ab0217a3985a302261c745a8c4c4ed7ca7682a",
                                             txOutputN: 0,
                                             address: "1Hr562LyDDUXZHA6W2DXk81fwwgSU7X1dm"),
            
            BitcoinCashUnspentOutputTestData(script: "76a91415eb5511e6de9d10a3b1a322487d2753f074ced288ac",
                                             value: 100000,
                                             transactionHash: "96d717f69b944dc99fb4593a81d595a0e009be24589cdab895d88232c7bd5005",
                                             txOutputN: 0,
                                             address: "12zu7CovhcTdzhXqKPYyW4PMEPSqUZwR1P"),
            
            BitcoinCashUnspentOutputTestData(script: "76a914a619e9ced4b2638614b635be97bdbc389fe648f988ac",
                                             value: 10000,
                                             transactionHash: "2c58298387dfe8d6bce74cfbd572099758ab65b0ff415a13c58061f674e6f9fb",
                                             txOutputN: 0,
                                             address: "1G9GDLH2DFz86KCi5okgT3JBaiKyyaTn4W"),
            
            BitcoinCashUnspentOutputTestData(script: "76a914f2eb70aa74e064b8a22ac9e396fd295cb4f2c69388ac",
                                             value: 10000,
                                             transactionHash: "fc4f1448114141b8070f29eebaddfb2e56a36efd60eb436ea7b60d21c62bdf9d",
                                             txOutputN: 0,
                                             address: "1P9Sa66udPLALu7k5waJNDz2pxpxcNuxuJ")
        ]
        let testData: [BitcoinCashTransactionTestData] = [
            BitcoinCashTransactionTestData(amount: 10000,
                                           address: "1P9Sa66udPLALu7k5waJNDz2pxpxcNuxuJ",
                                           fee: 678,
                                           changeAddress: "1Hr562LyDDUXZHA6W2DXk81fwwgSU7X1dm",
                                           sendAll: false,
                                           unspent: unspents,
                                           resultHash: "f35b2562ef0fe8097b93925fd5cc6eb1597599c046f6225ffcd69a5e5f97e77f"),
            
            BitcoinCashTransactionTestData(amount: 120000,
                                           address: "1CpRxkuWeVJKKBBVYxNRhjnS4xAXnyUpZ4",
                                           fee: 2010,
                                           changeAddress: "12zu7CovhcTdzhXqKPYyW4PMEPSqUZwR1P",
                                           sendAll: false,
                                           unspent: unspents,
                                           resultHash: "5c1cd9923b459888bbc6f415a77d8d99f40094226ec217cbc84576fb9a7974db"),
            
            BitcoinCashTransactionTestData(amount: 30000,
                                           address: "1CpRxkuWeVJKKBBVYxNRhjnS4xAXnyUpZ4",
                                           fee: 678,
                                           changeAddress: "1P9Sa66udPLALu7k5waJNDz2pxpxcNuxuJ",
                                           sendAll: false,
                                           unspent: unspents,
                                           resultHash: "23b1c72ce7dea36b3ffc7a534cf6ebf1248bdaceca16fd68cbea742fc44603db"),
            
            BitcoinCashTransactionTestData(amount: 1000,
                                           address: "12zu7CovhcTdzhXqKPYyW4PMEPSqUZwR1P",
                                           fee: 678,
                                           changeAddress: "1P9Sa66udPLALu7k5waJNDz2pxpxcNuxuJ",
                                           sendAll: false,
                                           unspent: unspents,
                                           resultHash: "150c12d09a9529699276cdb88d8a0ec01e145954400b4d8666f4f3cfe2bf83a3"),
            
            BitcoinCashTransactionTestData(amount: 50000,
                                           address: "1CpRxkuWeVJKKBBVYxNRhjnS4xAXnyUpZ4",
                                           fee: 678,
                                           changeAddress: "1KvcHonBsr8xthqm1wWvLTz5TReFneHmyT",
                                           sendAll: false,
                                           unspent: unspents,
                                           resultHash: "6417914442c8678d3bdffa1979d68b149ea2be0994649c846f5a41376ba6c609"),
            
            BitcoinCashTransactionTestData(amount: 110000,
                                           address: "1Hr562LyDDUXZHA6W2DXk81fwwgSU7X1dm",
                                           fee: 1566,
                                           changeAddress: "1P9Sa66udPLALu7k5waJNDz2pxpxcNuxuJ",
                                           sendAll: false,
                                           unspent: unspents,
                                           resultHash: "9c618b6f5243936401cd0b3f0760574fbdc917495c159e58df458faec9a8e913")
            
        ]
        return testData
    }
}
