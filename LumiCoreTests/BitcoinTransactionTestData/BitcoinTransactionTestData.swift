//
//  BitcoinTransactionTestData.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


struct BitcoinUnspentOutputTestData {
    var script: String
    var value: UInt64
    var transactionHash: String
    var txOutputN: UInt32
    var address: String
}


struct BitcoinTransactionTestData {
    var amount: Int64
    var address: String
    var fee: Int64
    var changeAddress: String
    var sendAll: Bool
    var unspent: [BitcoinUnspentOutputTestData]
    var resultHash: String
}


class BitcoinTransactionTest {
    func getTestData() -> [BitcoinTransactionTestData] {
        let unspents: [BitcoinUnspentOutputTestData] =
        [
            BitcoinUnspentOutputTestData(script: "76a9141adcb8050ca62a6132d4aface1fa86c56a36ed9f88ac",
                                         value: 16442,
                                         transactionHash: "e50dc7fa5cc1886be9e7121260fa2d859c31ae77391cc94db1a3e18bc746126a",
                                         txOutputN: 0,
                                         address: "13T2yoS3jE2nd27cYA4EXcUhoTRMfxMHao"),
            
            BitcoinUnspentOutputTestData(script: "76a914cf16facdc4581b0e07aa9030fdc582e88cc5d91088ac",
                                         value: 11069,
                                         transactionHash: "a179f6f4cf2b6be50ec5a5fc7cc2c9c29e8b033cda5e213687feb9ef289daa84",
                                         txOutputN: 0,
                                         address: "1KszQNGFDgBJ6b8cU6N1Nt3X2YwfRbx24D"),
            
            BitcoinUnspentOutputTestData(script: "76a914bf787036c4e4b0948a75aa8a73847d750b88715888ac",
                                         value: 40327,
                                         transactionHash: "97541ac9dbe6734998b33fadd3ff5c360a024d8f50d59d3b6a12459ce1ba7a5e",
                                         txOutputN: 1,
                                         address: "1JTQLqq5qnsBkYf42yHTcP25VXQV21Euzb"),
            
            BitcoinUnspentOutputTestData(script: "76a914263ac66077d2c8a27bf30054d02ead7821d918f188ac",
                                         value: 6389,
                                         transactionHash: "eeef451481f94190a3eb99d05b64667ed117e403ee7cd910a1e1e01f9252304f",
                                         txOutputN: 0,
                                         address: "14V963RpPaib7WGa3zhadqzBYbz9fx1s4Q"),
            
            BitcoinUnspentOutputTestData(script: "76a914da6a5ca95d0c03d5b5f9fc36fb4057fec369866c88ac",
                                         value: 1109,
                                         transactionHash: "74e9ad4f743ec9de79f77b3aa52886fcde91fed0716d6d49f19a6e549d7bfdac",
                                         txOutputN: 1,
                                         address: "1LusiyhNzC9hkrpu22QoNW3eBxeDbfjuuU"),
            
            BitcoinUnspentOutputTestData(script: "76a91432bf891752bfd6a0ef2393758c2792d8fe3d667e88ac",
                                         value: 14600,
                                         transactionHash: "5a4711fac7bb141f7154a35e3e779b5b677322376d86bf2b6e1d692efe301641",
                                         txOutputN: 0,
                                         address: "15dLEiJsw9afSLTM1nxP8AbnFNx5Ehj1We"),
            
            BitcoinUnspentOutputTestData(script: "76a914c67dae8243379af91884e1b64292eb28b647dead88ac",
                                         value: 1000,
                                         transactionHash: "bfbd334516ad1867d185aa719e08ef2c621c97f3bedbbf6c181c999e492687a5",
                                         txOutputN: 0,
                                         address: "1K6XMVuJ3AiF9yatTxzC3XdWKgoLDuS2wx"),
            
            BitcoinUnspentOutputTestData(script: "76a91499afc0b4e27fde66f3c27e22c6a4f41f0fa4f35288ac",
                                         value: 1000,
                                         transactionHash: "7617f948fb459265580196fc9aee97745e19d0131c4e6e129c0fa32f65e635f0",
                                         txOutputN: 0,
                                         address: "1F1cvsDuqxBiXZ19ia7PgPryDwdaq6otwZ"),
            
            BitcoinUnspentOutputTestData(script: "76a91451875294bbc1292d7c8700dfb8c684c7e44de00e88ac",
                                         value: 8282,
                                         transactionHash: "9aa0249eca01f256c0176f4441748ba8b830a467f8110cc3fcbacb7cb9bfe717",
                                         txOutputN: 1,
                                         address: "18S5qv8kEVk3xqq2erLPSHpf2TL8PHbLLi"),
            
            BitcoinUnspentOutputTestData(script: "76a9144cc2a8189319e20dce079f1c7a870fd26ef3403f88ac",
                                         value: 2857,
                                         transactionHash: "cb5a4e47f03f6578f3ef010c55e82dbb1cb04da4a2a0b86c3cacba49c0770f86",
                                         txOutputN: 1,
                                         address: "17zsYZPsnKV4Gi88sdVCc7rLN9BMnhPWUS"),
            
            BitcoinUnspentOutputTestData(script: "76a914047ae5c632492c324427176c0e097355d5c74e0488ac",
                                         value: 1000,
                                         transactionHash: "cd488a2aeb9666d548123b40a7d516128c4b12f22f670190815559938e0e7e26",
                                         txOutputN: 0,
                                         address: "1QgvqfzVSP5i5cTiBQkAUMmg44v2DqZzL"),
            
            BitcoinUnspentOutputTestData(script: "76a914da438d816f184805491cdc8d223c1431888fcd8488ac",
                                         value: 1000,
                                         transactionHash: "06cce6e467e309fc689df723cee3b86ee0f05f304ce3e4152fd25e9519122c19",
                                         txOutputN: 0,
                                         address: "1Lu5EU5PSG6Hc6SspGqRDtHvHqsBe9wpfJ"),
            
            BitcoinUnspentOutputTestData(script: "76a914ae75b072d1bf569411f96875ade0c63b6a92676688ac",
                                         value: 6130,
                                         transactionHash: "2ecc93cd40f45901141e6535a7f069529fd22a7721aa19d0dd22bdb092517b97",
                                         txOutputN: 1,
                                         address: "1GuTZa87BbjAwT7Q268nak9BaBNcKmRrfk"),
            
            BitcoinUnspentOutputTestData(script: "76a914700e5f87f4f9fd7d4aa80ff3b051d79b3915649888ac",
                                         value: 10000,
                                         transactionHash: "0bb146d61d016cffc46299245a0376fc0ad020e6ca3c6dc3807a252344373c38",
                                         txOutputN: 0,
                                         address: "1BDVu9iS5cequN6e1bSnFvtaqdq7qxXLoa"),
            
            BitcoinUnspentOutputTestData(script: "76a914afd0f56801a022fae815cbe338a82526574a3b1488ac",
                                         value: 5720,
                                         transactionHash: "3eea0b34e82e85e0a6e908fa73a7ac82a26af65eb7c7329a6a23b41dfaeb5688",
                                         txOutputN: 1,
                                         address: "1H2daGe6yKqmcgb7v5W54amYghY6oE7kWd"),
            
            BitcoinUnspentOutputTestData(script: "76a914e22113c86a4feab17f8f0e51ad73468b8473dfa888ac",
                                         value: 1000,
                                         transactionHash: "46de1d9cf9bcc6cf023044a1f2723b048b5711541901a7d9882ba320cef695f0",
                                         txOutputN: 0,
                                         address: "1McfLbz2xCy4UY7idxZrXeQuXWPthcm4BF"),
            
            BitcoinUnspentOutputTestData(script: "76a9146cb7d2f7b901daaf9ab2c1123d335f92a4f4c06a88ac",
                                         value: 8002,
                                         transactionHash: "1a5f4523aa9bfc30943a3830cacb1b5dd284c38495f69c4d33b2e7d26ca1a6ed",
                                         txOutputN: 1,
                                         address: "1AurC3J2D8yvbxQzSrqM74rFQtTVcDjK8t"),
            
            BitcoinUnspentOutputTestData(script: "76a914b27ce95f699fd1a34a4e5760318ca276f3b3804a88ac",
                                         value: 10000,
                                         transactionHash: "5ce36567cf628928e06699e0e587e4463b163aa4b47d42fa64971158ac1d262a",
                                         txOutputN: 0,
                                         address: "1HGkvA6QRr9uHWsFW6B85BXhyuJPY6oy9E"),
            
            BitcoinUnspentOutputTestData(script: "76a9144220cf1392a9d9db846435d6f61de3593fb25e5a88ac",
                                         value: 10000,
                                         transactionHash: "5a8989306d9b358a7f52d47ab59e70c86409c69f3e881d24c6766bf8377a09b8",
                                         txOutputN: 0,
                                         address: "172euGESc3RcHLMTyAvBLsaqyn4xYj8aiS"),
            
            BitcoinUnspentOutputTestData(script: "76a9140c35a5c72ad937fec4b0ea52f9899bf2230204d288ac",
                                         value: 1000,
                                         transactionHash: "107eeafdd5ce2557a6268c687a293103dc6f6e2568486419ec9d55e9ac839cde",
                                         txOutputN: 0,
                                         address: "127ZNoRsbXmVMFtH2f8YTwdBHbtHHw5BB8"),
            
            BitcoinUnspentOutputTestData(script: "76a9147baa2d1aa465b528db43d3f3b652e49246fe958e88ac",
                                         value: 1000,
                                         transactionHash: "e5cb7ecc8b6a69e14e484c32551006a5ec0d6cf85e1ef923705fd32bf6920f74",
                                         txOutputN: 0,
                                         address: "1CGsyeMGuqvU3iogopFwjw4rWyHooGGGAc"),
            
            BitcoinUnspentOutputTestData(script: "76a91429f1e7a3f02750c87809d7ed431ead279a5690b488ac",
                                         value: 1000,
                                         transactionHash: "28cb46538441501a02dcf8d8e58240c73f03ae1b6263b1745d6d858207861eb2",
                                         txOutputN: 0,
                                         address: "14pnVi5uocqsGaFP83S7FpAAQkXWfmUoeH"),
            
            BitcoinUnspentOutputTestData(script: "76a914b2ce78350885262da02f1c441e2346a76da2184e88ac",
                                         value: 1000,
                                         transactionHash: "9375335d00754a5ecbae9176d673bd48ef94fcb36fed9f4fb832eda14b24ff42",
                                         txOutputN: 0,
                                         address: "1HJScuLJ8ZhgLo44AQ2sRrksEwSHKj7gqg"),
            
            BitcoinUnspentOutputTestData(script: "76a914796c7d43559b79d85fb423c6f7d7a859fd59656788ac",
                                         value: 2000,
                                         transactionHash: "482583232735a3875dd2b0b6df0c10aba08737997d2f039e45c278a7af9b0f15",
                                         txOutputN: 0,
                                         address: "1C52jBVCtQPBq8Fx2hCgi4Hq4UkBRX1uwq"),
            
            BitcoinUnspentOutputTestData(script: "76a91461ec0c63a6e6c032a3a95deb21d27fba7125cb6c88ac",
                                         value: 2170,
                                         transactionHash: "cd5d957349532de45ab66bb5749da8b82480bdf59720cd7b650568d678a147de",
                                         txOutputN: 0,
                                         address: "19vmKYBVgSFrqt1s9TxWU1ExkwF9bkxdZS"),
            
            BitcoinUnspentOutputTestData(script: "76a91478fb077ab7bea1c7782d0fb5381bbdcc5a6a256a88ac",
                                         value: 3080,
                                         transactionHash: "ac28a977e4cc9c32c4dc03e11d7fe710a3d582b340b86c3007de77399dcf01e8",
                                         txOutputN: 1,
                                         address: "1C2goqTCER6c31Re9FRxDTAcGugqzBn5Lo"),
            
            BitcoinUnspentOutputTestData(script: "76a91456c12e7e6d4fa1b84b4c0a4e3a095918ce54971888ac",
                                         value: 2180,
                                         transactionHash: "69c4005ae39041946d30af0e1a0728aa7d4b5e94e21e38e2fd9b7e722b2e3676",
                                         txOutputN: 0,
                                         address: "18uiXzWF2ESqaUg5m4tHMnbSW1CNz1NDHQ"),
            
            BitcoinUnspentOutputTestData(script: "76a91401dc803bb34b86daabeda71404a0cc01d318c47088ac",
                                         value: 1212,
                                         transactionHash: "1d1e1c54a7acb5f65661a8baa32888d05b0e66fdecb1000e31d5519810db8fd3",
                                         txOutputN: 1,
                                         address: "1Aqps6XmvhToWBqfgMfU2ab4S15YVVh8B"),
            
            BitcoinUnspentOutputTestData(script: "76a914b3e5e4afcb1bd839e429ff753e51dbf38612bd8b88ac",
                                         value: 670,
                                         transactionHash: "ec4ea6d8ac590322f4fa590c17e22a8a293698d60b30d5346c4e3309697fbcf0",
                                         txOutputN: 0,
                                         address: "1HQDMc57yBxKR6EwUcEgraBzdrGFBVTZ67"),
            
            BitcoinUnspentOutputTestData(script: "76a914dc1a607e3f20c73a1797d737dd7218ae0e41e59288ac",
                                         value: 1000,
                                         transactionHash: "7c6cf30a7398e9b37cb929d9d8522e8d801909741cdb71794c8432861e0c60c6",
                                         txOutputN: 0,
                                         address: "1M4oFuQw4pC8jmLiy9i9wN2hHWMLGGedG8"),
            
            BitcoinUnspentOutputTestData(script: "76a9146c2ea5231f7def2319d81f246723d19c0446e09a88ac",
                                         value: 307355,
                                         transactionHash: "2d3874502b8f3b30e2446b63a7cd970180b38d382c5b13fe17071ba79604456d",
                                         txOutputN: 1,
                                         address: "1As1rg5ZpqWhDQivUNkyVyaAhk1fFFuxjC"),
            
            BitcoinUnspentOutputTestData(script: "76a914942d39af50f841a307ffdf91d97d6bbed61e52a588ac",
                                         value: 11032,
                                         transactionHash: "e7dcb8cfe9628aba9dc05050c2d7b088348ecf069ee3238b0b3cc134eeb02e87",
                                         txOutputN: 1,
                                         address: "1EWVBhiaJLCYw2LFcstFwpXkN2r7usRM4d")
        ]
        let testData: [BitcoinTransactionTestData] = [
            BitcoinTransactionTestData(amount: 330000,
                                       address: "18uiXzWF2ESqaUg5m4tHMnbSW1CNz1NDHQ",
                                       fee: 1870,
                                       changeAddress: "1JTQLqq5qnsBkYf42yHTcP25VXQV21Euzb",
                                       sendAll: false,
                                       unspent: unspents,
                                       resultHash: "0ba3e80c72df11ca464c9af3132154b8ae003278cc445d4497b87b25436bac70"),
            
            BitcoinTransactionTestData(amount: 10000,
                                       address: "18uiXzWF2ESqaUg5m4tHMnbSW1CNz1NDHQ",
                                       fee: 904,
                                       changeAddress: "1JTQLqq5qnsBkYf42yHTcP25VXQV21Euzb",
                                       sendAll: false,
                                       unspent: unspents,
                                       resultHash: "ec4b16aa1b44442fa9f9f6a424aff7016b311836d86846becbc6addd49c373cc"),
            
            BitcoinTransactionTestData(amount: 30000,
                                       address: "1EWVBhiaJLCYw2LFcstFwpXkN2r7usRM4d",
                                       fee: 1130,
                                       changeAddress: "1JTQLqq5qnsBkYf42yHTcP25VXQV21Euzb",
                                       sendAll: false,
                                       unspent: unspents,
                                       resultHash: "08e4ced7377c3a5327575167fbaa9719c5ba8be696592ac5f59a3b835fcac475"),
            
            BitcoinTransactionTestData(amount: 360000,
                                       address: "1EWVBhiaJLCYw2LFcstFwpXkN2r7usRM4d",
                                       fee: 2610,
                                       changeAddress: "13UVUWmw2nrnmuQ1yPbJChkb7dMDRUpcvH",
                                       sendAll: false,
                                       unspent: unspents,
                                       resultHash: "0722c3e43d8d3e379a1466b3db37152e382545096b824c5883820e00d0d8c39a"),
            
            BitcoinTransactionTestData(amount: 40000,
                                       address: "1C52jBVCtQPBq8Fx2hCgi4Hq4UkBRX1uwq",
                                       fee: 1130,
                                       changeAddress: "1EWVBhiaJLCYw2LFcstFwpXkN2r7usRM4d",
                                       sendAll: false,
                                       unspent: unspents,
                                       resultHash: "6b2f43593cc0f5bbb72093f4098593bc7fff5d33a033bcff192d434bb13f82af"),
            
            BitcoinTransactionTestData(amount: 220000,
                                       address: "1EWVBhiaJLCYw2LFcstFwpXkN2r7usRM4d",
                                       fee: 452,
                                       changeAddress: "1AurC3J2D8yvbxQzSrqM74rFQtTVcDjK8t",
                                       sendAll: false,
                                       unspent: unspents,
                                       resultHash: "fae67d6b9053cd41671d645c3f45d2c7e7e0da9191ebf2719a5e983934775ab3"),
            
            BitcoinTransactionTestData(amount: 223000, address: "1AurC3J2D8yvbxQzSrqM74rFQtTVcDjK8t",
                                       fee: 1130,
                                       changeAddress: "1EWVBhiaJLCYw2LFcstFwpXkN2r7usRM4d",
                                       sendAll: false,
                                       unspent: unspents,
                                       resultHash: "92cf9b8bb7bee0285223ac21505a74f5766f673923532e66c900f197f35505dc")
        ]
        return testData
    }
}
