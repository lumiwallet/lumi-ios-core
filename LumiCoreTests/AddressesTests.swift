//
//  AddressesTests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore


class AddressesTests: XCTestCase {
    
    func testBitcoinCashAddresses() {
        
        for element in BitcoinCashAddressesTestData.data {
            if let bchAddress = try? BitcoinCashAddress(cashaddress: element.cash) {
                XCTAssertFalse(bchAddress.legacyAddress != element.legacy, "Wrong address Expected: \(element.legacy) Result: \(String(describing: bchAddress.legacyAddress))")
            } else {
                XCTAssertFalse(false, "Can't create address from \(element.cash)")
            }
        }
    }
    
    func testWifBitcoinAddresses() {
        //Mnemonic phrase: sure daring couple leisure want swear fluid border quality dwarf lake cat
        let generator = KeyGenerator(seed: Data(hex: "70a4bc60133ccc0aacbd9f194d4e495a47dfd5233a2be737afc4040d8bd3167cd8297c61e99a36d1d5763e14802b6b9c27052dca4c23fff961afa4c05ee1dc4c"))
        
        try? generator.generate(for: "m/44'/0'/0'/0")
        
        for i in 0..<30 {
            autoreleasepool(invoking: {
                let extkey = generator.generateChild(for: UInt(i), hardened: false)
                
                let privateAddressFromKey = try! BitcoinPrivateKeyAddress(key: extkey.key)
                let privateAddressFromData = try! BitcoinPrivateKeyAddress(privateKeyData: extkey.key.data)
                let publicAddressFromKey = try! BitcoinPublicKeyAddress(key: extkey.key)
                let publicAddressFromData = try! BitcoinPublicKeyAddress(publicKey: extkey.key.publicKeyCompressed(.CompressedConversion))
                
                let privateKeyFromWif = try! BitcoinPrivateKeyAddress(wif: BitcoinDerivationKeyAddressesTestData.data[i].wif)

                XCTAssertFalse(privateAddressFromKey.wif != BitcoinDerivationKeyAddressesTestData.data[i].wif, "Wrong wif address Expected:  \(BitcoinDerivationKeyAddressesTestData.data[i].address) Result: \(privateAddressFromKey.wif )")
                XCTAssertFalse(privateAddressFromData.wif != BitcoinDerivationKeyAddressesTestData.data[i].wif, "Wrong wif address Expected:  \(BitcoinDerivationKeyAddressesTestData.data[i].address) Result: \(privateAddressFromKey.wif )")
                
                XCTAssertFalse(privateKeyFromWif.data.hex != extkey.key.data.hex, "Wrong private key data Expected:  \(extkey.key.data.hex) Result: \(privateKeyFromWif.data.hex )")
                
                XCTAssertFalse(publicAddressFromKey.legacyAddress != BitcoinDerivationKeyAddressesTestData.data[i].address, "Wrong leagacy public address Expected:  \(BitcoinDerivationKeyAddressesTestData.data[i].address) Result: \(publicAddressFromKey.legacyAddress )")
                XCTAssertFalse(publicAddressFromData.legacyAddress != BitcoinDerivationKeyAddressesTestData.data[i].address, "Wrong leagacy public address Expected:  \(BitcoinDerivationKeyAddressesTestData.data[i].address) Result: \(publicAddressFromData.legacyAddress)")
            })
        }
    }
    
    func testBitcoinAddresses() {
        for element in BitcoinAddressesTestData.data {
            do {
                let key = Data(hex:element.key)
                let btcAddress = try BitcoinPublicKeyAddress(publicKey: key, type: .P2PKH)
                
                XCTAssertFalse(btcAddress.legacyAddress != element.address, "Wrong address Expected: \(element.address) Result: \(btcAddress.legacyAddress)")
            } catch {
                XCTAssertFalse(false, "BitcoinPublicKeyAddress Error, Can't create from key: \(element.key)")
            }
        }
    }
    
    
    func testEthereumAddressses() {
        for element in EthereumAddressTestData.data {
            let ethereumAddress = try! EthereumAddress(data: Data(hex: element.key))
            XCTAssertFalse(ethereumAddress.address != element.address, "Wrong address Expected: \(element.address) Result: \( ethereumAddress.address)")
        }
    }
}

struct BitcoinAddressesTestData {
    
    static let data: [(key: String, address: String)] =
    [
        (key: "028027c2fc9b25167cef3d0bc2b44fa5877f2623a4e7fc8171b7f083d64d70ca08", address: "19mZH5iaYYjknbnDpg4fqj2cwTsHnUZWKK"),
        (key: "0358e65308e42f898107d6c6945f5a5b3608136cac98959db721514576835e9831", address: "1Hbpc4aWA6LLHZPw2iwBJJKH67GWWaFJCu"),
        (key: "0284834b68ecfcb0e84b5b56b1428554ac41ce8b40c096a173a69e4678d6437441", address: "13tDmBEkhon4ZNk34uwFpZRYnHNRLuWSUj"),
        (key: "021b4e3919b525664b5072b7c3593329d5a5f4b75b7aefcd4c887636ea2c79801d", address: "1GcvuKWuHbQ1eHsyg5WhhbteGmN11vH35U"),
        (key: "03df56ad68ae2aa3837decef178668787dcb13f5574186dcbfe90ba6ae5aea0152", address: "1LtPLWAjr1X75GEJZKKHatG9nyYHCGqzvu"),
        (key: "038317ce15789b65ed0079b8811f39de16bf165a3b394f213b612e114c392055c8", address: "1Dzftsgte8yHqzkDir2WwTNBx6f4tQ4JYt"),
        (key: "02fbfb06d8b89908e352ec23b9b6107e7b8088d5fbfd94a2a13d2bf16e3716243c", address: "1CJRyJnh1iDA5anXNvWrM88HJ44BekYTVP"),
        (key: "0269ea1835148ad4db2593b584797faa67f665e87abf613459a8a84b087778ca99", address: "161JQm2RYWJPREWZRNoXFr7YNNP4WxhvyD"),
        (key: "02ba9396676abcda4b9e960cc2db5d7d83db63c7fd4717564992f0b444d60d1ad3", address: "1FabxavvXKkUJQvJTbTsEXYTgdS9DF48ZJ"),
        (key: "03c6af777120df6fedd5e003e84f90de4384416ff5681551000f4d9ff35a2d6058", address: "15RkENHxCmcHK4vmoCLzKnMPk9fheA4DCX"),
        (key: "0328980f9417413abf081ff9e22e73dd18ba5cfc6764f07102be4988b3b1311b08", address: "1MuQCuAuuv9aDWR7H2J8Xt9bLSL2PwMSxh"),
        (key: "025ad1f7b151e93164c92ab205bc47ef0463704da29cd4e1901fadbc01f9361486", address: "1AE7NqRfKHkBeEe28nq3M1jM2tA1BaaXKW"),
        (key: "032ca796667a974f061376b8c6f2649de51e0f3e0cf423c7d35907941548b77a68", address: "13QtFT3DL9yeHBz4k11CJ8KV586iKgmFye"),
        (key: "027c839ee8b10522cdc457ee04b8b05bbdb5341ced59fa2be8cc40ed1955dc866c", address: "1PuBstTy6cPJFva8LqAbFtBwvU8gYSJkQr"),
        (key: "020f0a870e62228232632c9c1e57e5a1c964324df7d5de66f340b03ecf289e54dd", address: "1GEVmo9NMh2Xgjf5m1yReYxesM2ZY6PzMS"),
        (key: "0206f7a44efc431818f0d602207fdb42b4039877b14dd49d521eb1d05f2f2d434f", address: "13GfF1AMB3FbULGbapfGhUiGi63B56xNeW"),
        (key: "02a1c4611daf8bbc43f8e0307616e7388470aa023c093b76aa540d5c8ca1221e13", address: "1Pt3hrktEMpovffxLv14yycWPPiSLcbZik"),
        (key: "03d49d8071d06360de12e6a164d1cbbe8f0c8f4422b0aaf9f21ac2b6024e4b4b62", address: "1Q9xgksBaBFDeV3Ti6heL5UbpbVMsDRmuo"),
        (key: "03935ce4f4e013c074e809a8f8b4042d3b6d7b557ac8247b081f1bcbcc845477c4", address: "1KX8DYf2sJm5ijjCgKv5r15NxgCtugtSsY"),
        (key: "03ed1b608b08ff8be443d70946d1bc1f825e2c34f70242b8f3b085830a75f3243b", address: "12hoATLc3Lr6vztfWFn176qdGuvJagxEEm"),
        (key: "03d61688e5acb6900cdbcda67c28c01f7a649c80f39930f7c0bab01813c4efd199", address: "1CSXw9zz5CRxHZziF76jTZip6UE85JMUus"),
        (key: "03dcc4a28d5879a3c52cdaf27d718ecc44511d723d4fa070870b9c7fe6fd3f1c9d", address: "17FdZNEU9J1MPH39gtZiC7kd1tTfJUyJqx"),
        (key: "03ee06766c45d7c49bf9061f36c5e266a1ee4b00a449dff8d71e5cd41b05aa57eb", address: "13WFQDauo2SBhDW1r6PCC5ztzktjffmQCv"),
        (key: "0200ba5aec0840f5d1310d9685bd04d0873e596fa58759cab6b9b0f0a3d9b805e5", address: "1D7bJigAXR3RXG277jYmWxHRe8aCoPY1Qb"),
        (key: "024572de6dc285df9b927706bf40ed46999e5a012f7cb8b0134320be64c5851572", address: "13gAFxzt444cPDtVxWndUEyucrYLrFSms5"),
        (key: "0281ef5b42277a61f5c40228a2426ccfba1c5b6475003358af51e2c172254b383f", address: "1HsNYe8Vd2noAV2VmZvttj4Zqg156UCTip"),
        (key: "02f7704b892c17e0c464aa2e733c46bf97e3acb9c7c2ea1fb3f3b1868c5856e854", address: "17ywehLCsaLAnVkcDHhApH9YjSPUezFPzQ"),
        (key: "03a7142f4f5503b1397e6ceaefe647179ee426456e7d6856937f09871056dcfcb4", address: "1GiFx1YybdjDajc4FRCPVDcqqMvqMcy9Eo"),
        (key: "0298f4dd5a36304f8d1292e193ed0b3eaced7033dc63c9a37a89d7531aaffa400b", address: "1J1K5PUM2SrrMM9EuHqCabZquobYGsLCSh"),
        (key: "03277b38ed47b1fa06fb4dad5edb9f3cae8c4470f2ce98cce84303ddf513589448", address: "13KBmgTYmK18xgpgzsNaUQ93EXfPnWCEDj")
    ]
    
}

struct BitcoinCashAddressesTestData {
    
    static let data: [(cash: String, legacy: String)] = [
        (cash: "bitcoincash:qzsepqzhqnt3k9pn8c0w2hv4rnzm3l6x7540gsuafn", legacy: "1FjGu1kdL53inhGVGQpBcmyqzAeft2Pcrn"),
        (cash: "bitcoincash:qpqglpqwgzy8xf7gds87n9s8fcqeqc2jug8wmffxe6", legacy: "16tNAw6bHFRDzZEjZvwxXH2ark57DiSByY"),
        (cash: "bitcoincash:qzswdjj5gnjd3d7gpaczxlenyvsrslcccu0clvlkf5", legacy: "1FfmbHfnpaZjKFvyi1okTjJJusN455paPH"),
        (cash: "bitcoincash:qr4dpremz2ztxxn5jd95s45sn606x50xgsazhav6v0", legacy: "1NQaxres58ARXiL8FUJcyZqfZBNnSYxq1Q"),
        (cash: "bitcoincash:qzsmd7uapmmsgldvz9f6vnhnf2yw384kwqggqxku24", legacy: "1Fk4zkumdA4cHdaedHBQr4mNBaU64NPEpn"),
        (cash: "bitcoincash:qryuulucxhretm78qq6pvxy4u53w77psf5azq7rryg", legacy: "1KQ4CKXW1CU1ngGZQoSGeQisP7hgx682wU"),
        (cash: "bitcoincash:qp6f6y2n40utr4crcl2st9thrt8x2c08uvv5hq8hzv", legacy: "1BdbYWN5F1EZfKbPkQ3wJ2M7za9VCNMQ4F"),
        (cash: "bitcoincash:qpfsyf7glrpj44hqqwezr7c9uhds9zj48c2t0kgj8x", legacy: "18ZufgaoDNNXzenD58vondBqhJkMHSsUND"),
        (cash: "bitcoincash:qrpag9n4azhjf333zr4ffe6v9226zvt6dyhks96qkj", legacy: "1JrSqXENQQzto8KHcBGvNX68CxvN9r29QV"),
        (cash: "bitcoincash:qrgn6zm85qrg5t0xqduvzm080sl7ywa7syyr9xzgzw", legacy: "1L5MMYT7amurmfBR4PTU89oE1exWE9ZhXa"),
        (cash: "bitcoincash:qqgs874xlefe9mvxejjta8puf2cmz65s953v9zqde5", legacy: "12YyFjc6NyArQaqjyqEkzE4wY594P9abUi"),
        (cash: "bitcoincash:qpgn4uvuxl4wphukxxlpkh4w2hss424s2slre05z2d", legacy: "18QWM2RiYsWCEn38k5nMYzNPGunozhSwsp"),
        (cash: "bitcoincash:qrmp0mq95aawxv26je0ywnamjzk2fzsmfc9lf8zpd2", legacy: "1PSDtKQNS2Bn9RQGvhVvw2zdSJPTNC3hoQ"),
        (cash: "bitcoincash:qqsfxfmyufthzyuqmudxf29mqa5xndzudvwu4jd8ne", legacy: "13yEua3CVCK2QSioA5xyPWz8V9H7rL3jvP"),
        (cash: "bitcoincash:qze28v5dpknjpvqnqgzdvqsu0w60z6w4m5k099exkg", legacy: "1HHZP3cc8BVdgP9SugDJNXTR8GMxmcbxeH"),
        (cash: "bitcoincash:qpt40vd8gtkdxsa2d7rwpfpj63pt8fmc6g0pzqnd92", legacy: "18xpqmo1oepVYMT236iDw1QCYQruVqF5sZ"),
        (cash: "bitcoincash:qpa4dqdwa42t6hlq9ku7fggrhvcycq6j2vcl68hjxm", legacy: "1CF9kBHgwfoyyAwRaQNKdzZYNk25x1t8YV"),
        (cash: "bitcoincash:qpedg0e8yepncr3a67m492pj4yyy0kjw7vzfavsrzj", legacy: "1BUAJ2aqyg6fpuddMGcvynAGD899wqBhVd"),
        (cash: "bitcoincash:qp3ah60n77yzp5ckd7easetfk7h7jn7yrs36pgn7mc", legacy: "1A71LsmpKg4DZAjJDXqJnixuJ9jJK8pchF"),
        (cash: "bitcoincash:qz0qzv262ut39y37g6d4wcry48wk899jug647sf88s", legacy: "1FQTCBkVXVzVJsmX9bJgU3PdywxABxDudj"),
        (cash: "bitcoincash:qqfajn43yycp85ahaxqz2d7l5flxjjmr75ahywf8rc", legacy: "12oxARmGuuesfxJji1HMLLakfLYyrDqvpa"),
        (cash: "bitcoincash:qqvmr2ad0p748w5h4thsgr8ctmk7wlfvpsfl4t3840", legacy: "13LrjZruEg2kGDcKuijVRdv1Ej4G3wZPJF"),
        (cash: "bitcoincash:qpt40vd8gtkdxsa2d7rwpfpj63pt8fmc6g0pzqnd92", legacy: "18xpqmo1oepVYMT236iDw1QCYQruVqF5sZ"),
        (cash: "bitcoincash:qzy24wnn2uuvhw0f7vqj4wzd2h0z77vtlgkyhgenuv", legacy: "1DTdRW3W64SCUYaf2Hng3rDiZJemuaa5RW"),
        (cash: "bitcoincash:qz4yafr89e3tdpeey24z5k632sj9lz662cmu05rglq", legacy: "1GXW5mV82ahaNypwg2scKCD4RHWfTzMEPn"),
        (cash: "bitcoincash:qqnvvzdcrhu0qknz89tuv2szfexuts2dhyn006kmpg", legacy: "14Y1vD6rcUGoh84igJogSn2FMd5UG1n5Ui"),
        (cash: "bitcoincash:qz0qzv262ut39y37g6d4wcry48wk899jug647sf88s", legacy: "1FQTCBkVXVzVJsmX9bJgU3PdywxABxDudj"),
        (cash: "bitcoincash:qrxrw9zjuyfa93wwdt85km7jc8xlmu09vgvsveygcg", legacy: "1Kcnq7ksQzFHzWMHeUXhQaxtFWvKdPY6dU"),
        (cash: "bitcoincash:qqfajn43yycp85ahaxqz2d7l5flxjjmr75ahywf8rc", legacy: "12oxARmGuuesfxJji1HMLLakfLYyrDqvpa"),
        (cash: "bitcoincash:qr0app0zllu70qh0fvjtkrn5y8azfprxryw3lu27ss", legacy: "1MQRVDB28icYP3X9GEnqJb16nwyEWyXfBm")
    ]
    
}

struct EthereumAddressTestData {
    
    //sure daring couple leisure want swear fluid border quality dwarf lake cat
    static let data: [(key: String, address: String)] =
    [
        (key: "04e10667e02525d16bdad8a62ad6c3adbb5a5c8f2c6a18d6e5bd6d7a7ffd85641ac7c1baf36ee9c11a730c90a18626d451ff64171ec270afa6ae4ceb075cee4eaa", address: "a4bee163f4c732ef5acb2007074a0f8581f7a571"),
        (key: "04ac058aafd7dd5a8f48e46202d31f8fcbd4608502e3185f79a369f1a5e91c4fb0603af36f026b782d09f7a85a3b534f02eaf726235fe45ab24235bd2ce1d676f5", address: "9556dca788c6d9c0fb077f93dac2ca0c82a74caa"),
        (key: "041d06d6c78c1699793a9767d2dc04af129aeebfc52d0672412c41393a1bc60590c5fbc1f9ccc9acc44723da174c24dc028eabd08aa77d1dfd2f32d24a7b6c13db", address: "8db54b767155d75d5aa9f0acdac974ba31b90ddf"),
        (key: "04bc0c5e404fafe5028ace2f5067e62e0d97fd3d62079043ff10a1dd9b1a5f4fbeed9af7c7e7c30aef4bc634264b7067ac41fd3b69755749cade88de29fc911e32", address: "f941e141d94e44e34154a214a49fdf855597524f"),
        (key: "047cbe52d2db0d79b17d2c94eae691a8d9dcb0e54654ef78267a9614f70eb7f98ddb9dd9f4f4faaa17f8bef0fabe2f731cb90cb1bca92000196a65cbc6b551a9bf", address: "b240ac4269b444f3e37c2df927833e3afd3b84f9"),
        (key: "047804909418e702a0c45163f339d68ff4e29e79fff1c003253e00a9704d968de28dc7e3d42d8b9b2f4b0efc232084b23b95b39f65680329165647a074d9000311", address: "0cdcfd4dcc6baedfe5876cec4e8e99280324bfdb"),
        (key: "04f40465fee5c6c41bbc81afca74592268977478c7f9cafab801be6ebffaf5d9fd1e461b774ea8b724c7eb19445211e704ae0a1bd2ee434e5de2c8c23bf51e2375", address: "6509b03604cb05a02418a78cabef747516077691"),
        (key: "04a5a4b219ef163ca566e6d0d71e7cb78cc5106e1616831cd24d5ec861bd39e90ebb05a545e5a765c9f7ce900b97dd24f9e67fd1f5a9ba5cfed54a21a2f50a5322", address: "3f6bfc938ac71d333ccd8241e3a5b7cbf91d9a4b"),
        (key: "0432c779e839f9cd59fe4afe2e5f40f1424d5c689d7c2ba2b1cf076c6b0739e4f66d6de665e4c4b93cebe6d3c323de1a8370b2e15e5a5bd88cecb372e51e9d01f8", address: "968af26f9830752142f7a277ef0b4ba48c165d48"),
        (key: "0483fe509268c2f20291123eefa85b4dba04c730978f337036e35b10ff00327e5ffd74d1fc28ff8d730bc3418f9ed2a134787f8f767a210f66ae86eb8d1c195a20", address: "6ffc276f1b09b16e889f49dcab5b8a572cf0ada7"),
        (key: "04739fb4c657dbdd11e32296b5e7808c893f39b7c4310ab1cfab96bde01c7f72e9ff206d829b667fb70be46e01868603a5a90d31938f867356fa84b083c115bf70", address: "a046f630286f3b0d8d6a4b1b180ef6d6ad679d58"),
        (key: "040e783f205a2ddd0ca1f7966f007f9c284a83ab748aecab2fe7950a545513bdc6dd52c1e1b45f2481d45e146635dc233b674cd6563affd35f34d00f4473ac1914", address: "5969ba8c72df5cb6c99b0ea06eb131d489656e64"),
        (key: "047c593b592c151a8929912e4afe1ae81252681074d3f7abd120fe4b168bd4ed8d915da1f461797bf7e4d252781f5e73203f5f8ecae247ac44a8fbf2b370989b07", address: "3c0eabd4a21e4dd18247c1334fc4846536d07263"),
        (key: "04fa9fe7dcb0d4252c4354c4666655f100274ab1e7262fb6b8af46c470f933cc25e20b2731e142a13834c62f4a88edb8b2d01dee7bd834ccaa2f54001793c8b40e", address: "4a5d16d57d1963593396bef77a769e9e74359b9c"),
        (key: "04e8eb518a64edcc6c76b50f461781b49fd6b55c1a81775bd57de12aeb94cebb6255d46cb2f06234305bdc1de2adcc21288a8215c3290f2eae6f3c8b1fc17da927", address: "bd87c740e33c8758128a96dd23407a859ec3f0e2"),
        (key: "044babe23c1c725f76a119d5f4b01d723b1b52eff21bee131442ce6ab57c872bd769ce8373a3ddf2eeee557b5c76f047c15f93597f6139112c8ea68ec29579b817", address: "d97fc3eb348b9e8e0f26fd5cbeddcb3a3ef0c454"),
        (key: "0421dfc5b9d5d823b6a8c63e346bd71e40b21eb8c27f7dce07d4dbba68f4cc55fa7b9d4fa28d3d9bfafe9df6374ef919f095a16ea40e95a3f4fc5c9dc71ccefb8f", address: "8f3984f1dcc04297b84d168284f9895ce518d55c"),
        (key: "0421266b7a2dbed9638b2feacc82af4f224aa44bfd5f1ef0a87debd141979055a3eea44a06c140615918de1f7cc8d31ab2ae1da3aa1ebd8bc955160203accf94c1", address: "e315a416eff393c229054bdd272fc309dab398c0"),
        (key: "043ab78a74f0c7a3915e47cb867e71c44f8bd076f8e461f512560a64b48732a37bb67fb25a9095f5abbdc77a5ec30f481c437cc88d1273e7eed1971a400c0bf277", address: "b450b71941310c492e70daa0b0e5c93fc60bb779"),
        (key: "04170af5e7167032f1232d835544580f0ff891e24616616ec4ab03eb57288480466f0467dccfdd452e3237f56c4974f1ad940a586b42b486cd88e66af5b8714685", address: "b082b6ff2793da06c47aa6c55136d340fb01ca08"),
        (key: "0453182eb57fcf9c7083effebbbf5306cbd7dbc9e5ab7ea24c29b55ab599e564ca988e3148b4d983046ee32f27ddd3232351f1a13a74c9b5e8bbe9be3f0545f756", address: "69ac7db1847e8b389acc1c73364b18e1c8fab7ea"),
        (key: "04501e6ff8ad7fb4e744479cc9e9c3a67141abd1e6425646d959775d4588093bdbf55a400f2cafa3fc723d760cd59265b33c1ef1ac04e40e5d16f9ff35915ece4e", address: "1e3a8166520af75784bba6e23dea36ee43f26971"),
        (key: "04b030b31b0ed0ad97c767f560977f44a8f8eba0fbd1092bd6b2d53fa7bd581366d01c0454e028322e86d923dd9424a196ade528a63a859fac1a5925862aec8585", address: "a8287f8644442ae957cc1fb8d0d80b41ca1fd8a5"),
        (key: "04dff98676ffee5c71a1275740378dd3023e8da4f6e093c5703229b6583d94b1bc6a6db8d3c4aff007a7002ae7194399a9bfe171226259b2650e622f776b1201a1", address: "9c7679cc583ecdf3ce027d0b9cc2d5b46ab93d2f"),
        (key: "04f10eb041ca059d35f49f4d26fea04342381d3d95f5bdadfa0ce81b20d239a62de6ba0e652a59c3fee19236a1b5e9c98eaf49c8de09b34aace5bc12bfaeba8e49", address: "dbe142bae430c37fa3c9306ec394ed2fd4fd430f"),
        (key: "04d648ce68da573220609c818e0eb9e04da4f062a99d25ef5d6e73aba4af1814a081d21ae6ab666197541af412fd580612b13c9bb19b12b4ae3343812f49498908", address: "132eb2f481d29b2ae1b1b9dfcfc774961b205478"),
        (key: "040d11a55f088a97987518f99cfee03d5739d9c30c9738e3ced4714be54b4f5a3a66832f7eb004fa58627b09bfd02ce5b39a01f728c47d965e1eb63945538c3831", address: "f3a66cbfb47e1bb6cdf993550710c812f965c112"),
        (key: "0406a9b17eaec466cbf1320109c1dfd91a0c7d327d281c4d3de4bbddc0e48a8266390fc65fb6402b9027c3eddafee24797a28bd3f724f6d6dd916a87df0fcd03e6", address: "c1737ab5ff6c58c83f474a54a4e1ff1a8efdfbc4"),
        (key: "0419c8c8ae0106aeb6d49c88a79246c286b8439eb450a1ae8f4fdff3b09583a67d0b64ac8c90f046cc5a5f58ea549420a81fa5019cc559bdc75e9b3170315847c1", address: "d539a56a99f779be79611fc19e7a2be2863e19a0"),
        (key: "04da0d9c379aa459219166340e8142279190e97c5a8c7d7b1cc4aa0131593e4c41fc78feded0e8ae245a151f636c6a3f6c805f12ef6ae56a7906747e94de42538d", address: "4367ce45459eb59ff7c669b2649396e102233347")
    ]
    
}

struct BitcoinDerivationKeyAddressesTestData {
    
    static let data: [(address: String, pubdata: String, wif: String)] =
    [
    (address: "1MdGMxicf2rSRL8e9y7gcjissvSbRtNN34", pubdata: "02a8ec177c7ebaaa6ef569c17068db1f7d2f90d4b95ec98b41db7135ed3f7d32f5", wif: "L1zb2an64Supr3FeBg53LEPg2Z7LBRop7jeDDiBquqWVvbTyhYme"),
    (address: "1JftzvuMQLSWkRbh3heMrYkfS63e5nCGs1", pubdata: "0292eb75add748706a4abf56b66b7a69beb5dbe5686f50ef96c22ed2a29b8bb7da", wif: "KxTnrbo7n2pgPL7jEfRMDiot8v5zdmkEdfn42uaUepvJVnQsbzat"),
    (address: "12uoA4vncvMKQZmHZTAouob667bgzySxvb", pubdata: "0385d9474a30c999ea69d8c8b23a65bbc4e1385b1d120b89505d2c6663c0e4cf17", wif: "L33JhaAvGcBDiZ8H5zh1HZDbmRGEWLuxHFhpaxHrTVSjJimGKzjT"),
    (address: "19B5JwXmHtCNxii4KTVzp7QDUpAAGAFEs6", pubdata:  "0207676761e337c0994947705b81d91446d5b76854ebc3ae123a14ec1bad9b1f2b", wif: "L2HhaC6CiisobU4dicMJP8dNaKVKUqxZCiWgeDiKL3k7kDroDy8L"),
    (address: "16hNoFw5cF5Xc1XPsmWYf1n13V4QdQPdMJ", pubdata:  "02ccaabb27eeab90de478e4530e202ea3a477244dbe82e1ff02c21382e13e3ba78", wif: "L1w9xBeSwr6vhqJ85xdb4ubvkP183UHKcgAzX5RkZNZdsV6VPWBP"),
    (address: "1CQmbsirVZ5CBKdzPQUm4BdCbRHLPkJwF6", pubdata: "022a921e07468a8c0743ebc0ae8b6000bd03e25a63fd92d41d170dee00d12d2b29", wif: "L3qi7tYq6rz78rqNb8DdPac8PZffwLVgV2LqMUUMfsoVjDJ68B9p"),
    (address: "15mJ12eqXkBnq7C3CXES5sVUsKfwoPEmRb", pubdata: "0305c5a4f879a3b21b598b517a3ce96786845139a70c2727f3d21cb2b386dbe712", wif: "Kzt9PdyfRs9S2sVi3b7X1jXU9n8Ymm416UFtVPZh7muvY3AvswT9"),
    (address: "148ZP6eRefxwhxZJ39p3iwwy2veJrA9DDt", pubdata: "03fc17d2c4a13d0a5718581ebd52dcd57cd500e2e9caee6bb4ed8195de8ac4b3d6", wif: "KxPXnppiqhN63mPi8vzYRcYE6RLsiBBGT4EPA4jo5HuFQ2z7THMT"),
    (address: "1DpEHZs5Zz2kyYWKdYe5WH6Wve13AJp7Cs", pubdata: "02f7a6f226130fdf5c498162e8cc28bc5323b13043ce2ebc62419eb6d7c313c142", wif: "KyrD9wDNHDYXtmdRfvWVZ9r9ZG2jUJSuNJWm8dT2EZD4DLZsoYGU"),
    (address: "19Tj4LuRE9ZKLfU8BV8ReT3BF9WuX92GDf", pubdata: "02a207ca5b5e7bbf7c433130c041111906dd10afd90832f4a47121dccb40d4e8ec", wif: "L4xnQfM5YkPVNV8rniZ2MJ8aysYxgNcCGm4J2KSKttY6gMFMnhsr"),
    (address: "1F8NaxRTcyvRBCSzX5CUvQLMTVc2VFQ9ys", pubdata: "02b438e75a5aab974a18528460d201fb4d4cb0849dea37747ba7023e8074aebef7", wif: "L3gQW5d2dV1duJ2tU33amobuQzKE5uFibR4pnQFJdRppjxpeVjEg"),
    (address: "1KZHYBswdSQhgxZmjnLQ6Rtz8bQQ5VaSvj", pubdata: "022e9fef9017c1496c8b39b2f1dd4826386326e0e39554f62a0c0f997675a5f273", wif: "L12FB3a4HAxR964Gua5h7Axz7Pnp2egothMpfsfKLCzvsgyszdzu"),
    (address: "14iAW6fibQxJhpdREPLw7fQ6zseZZU1u34", pubdata: "020ef8327a00f8f47953e9cccda5072520515cd21c0ae730c2840de5b29c5157d1", wif: "L2yyEE8nQywPRq7FH3f8yYd1KLqpFAPRfjkAJ8QNAMMuU93dBTkZ"),
    (address: "19jx3zZFDdSPzAnxP36GSDete2kot7U3Kw", pubdata: "02fec359afa1594455f92f286acc8a357f4d1ab13a9a4a45431665f31041f30b7e", wif: "L1Z2ExwyLxG1gq5bgWHMZUMV8TFeLLGX9bUGSvY6ckDiwmc3XpNF"),
    (address: "1JNfo3kxU17BPASpz1oQSVCugoR5Yky3qK", pubdata: "02da43277df1cc89f99db867bbbb69d9c2a968615876c68ca417f38d1a0ddfa47f", wif: "L46ALJNA2a8W44snc6saTeQyRWBEWejG4tgRTFNscwLdbxtjKaiQ"),
    (address: "17kWPbN4WS23dNDbqop5jhUKgPLANyAibd", pubdata: "02001d32fbad2928981a7a10a341dcfadebcf785da631e47e27beca312756aa11c", wif: "L41dPtLJYXojMtgegGodMTLuviMxmyvUnz7gQoEWw9RhSx9RFGVp"),
    (address: "1HxdQA8NK9ZU6CQM2UhtuRRukFLQLUzJAv", pubdata: "023ddd9dd7d708aa64173bd74fe457fd87a30557e37c775c14ab8306d04f60a3e7", wif: "KyRCUPxQ3ucsGzCsEYx3qhRo9PCK81VkgbefUBQypHLj1Vonp5rs"),
    (address: "1ETLoTQUTFEBr1n9kioL9zDGsoSehwXGhX", pubdata: "02eb389371d75833ff0efd9866f5ec558c1d9049256547b50dda706471af5cf857", wif: "Kwzge1aKdz26xW14LFvHRviZJNqRKgF3m9faXoJBhRBonPnSm3eb"),
    (address: "1Kxe6HeQjLZahCrPGwcNGH4qi3hzNh9wEY", pubdata: "0290eae1f7eb79b6b54b1549007ba316b6ac8251788625d4f1eaa941fd7e983dcf", wif: "Kwzri4hTUMguuNFW7RwXo5Tt89GtPbYzt1MmmQMHrMVZvqaAjVVm"),
    (address: "1cw7sq5fdpNuyCvbJR7obh5rjhEZRUh25", pubdata: "03ef0a0a03292cd58be253ad747fa6b9f3bfe0011c51f0782760743657ce55db62", wif: "L2nLvQpz9qeMkqS9MoLCiTyJR872yaYfmncYn49ofqc22Pp5MKE4"),
    (address: "1CPNcJdrVcKE9L8R3u5EbRTtqDJjoRSeT1", pubdata: "03ba3ca38fb50126bdd55336927d144b850c9eaf11e220153b87a7c289c3ed3b35", wif: "KxF756snnmKHpjX7Tz4ewWX4X5uWx7GPeLGFFUHwpYSEqJFX5hLt"),
    (address: "1GNGP7pLsocdnNnsfSFg7mnwhBkcxEvd4X", pubdata: "035ffca59e3c73face723fb40b0f78a2b7ececc430954a2bf2ebefd03a66115fdf", wif: "KyPdqVx3Y2qnK5ZndEModMHy4rKtPQ7zZP3HxVvfYSymWvjVQFgQ"),
    (address: "1PD4rHzAHpCytE7J7DTL6AV7KNSBmbjxNu", pubdata: "02b9e1c0845dc523c7f27b878c21dc9c707c94c1f5d8b48d347d00a50017daadb5", wif: "L1jatzirgRS9KkXMhMTDTBeyjiJKwryaVVYj5akumQKxiLNvWoNK"),
    (address: "13tmCVxn1fjeWkPC2zgt3HLWLpMLkifBpa", pubdata: "029b26044fa749c1c4e58df89f24d61536e96654e6bd240987b3e59a995f6abd13", wif: "Kz8qsLrZp9qTT2C6PFMUaqYprY3UTwyaAkqdL9r1JjSuSiF2SZac"),
    (address: "19YUv8JAhCCvtQpv749zwTGr9PJmjF9iRn", pubdata: "031375ae68837a49c768b7724d7541c5c68cc9d642a110704a5b016de3a188c3f8", wif: "KzvCL2Ns64SJWtTbecSdDXgTFu4yvC9ebaho49mM5cX1TigpayeU"),
    (address: "19UzEL21XJT3Ju4aUUR4Hq98gNg7cJ2ZRt", pubdata: "03d8b085b64c7ad23609f705ec60600a3503305c6b33195bb1ccd74d06dc49bf05", wif: "L44zdXDapVodXST4BHjntDGNrYzUKbHfLa47yAMTPuh7oK18ipH7"),
    (address: "1KWUtrriZ5Cn3ej8tnaUd2oyQezfSFv4xn", pubdata: "025ce0e9d9adc09716a8e62b73893bc4e235a331b2fe5d18634548d29381299172", wif: "L31UDqJTBRW1SVud8HWf7doQy5bV5P5WD39qNcCmWrSKUpro26DH"),
    (address: "1LW8fLebok71MPeQBzCNt64TSreMPEXxrm", pubdata: "02347754f2cb7aa3c6b98ea783e7ee4387ffe0b891d564add0b0e9165355c102ea", wif: "L3wcmQ9sXBaULMCCKX4eH2uMhZ1StUD9BSCWV2NdbjMfZezWWeRG"),
    (address: "1AUA42TtSeUkWBJDiXdaWgrTDbiLMSK2oS", pubdata: "035509f383a39192294dc65f99eeb849c236fc19c9850900ea03298e53ba56ad1d", wif: "L3NW7Jcf9JJwwj8C1zCaiBytQ1ZAj9awFFQd2qiAz9zPTqHW7S5p"),
    (address: "1JAXFqeZMwpg5NiUuLvwc6zfzJJEkRXGs8", pubdata: "030b22da2978fc82eb1bdd1ce90215e8c52bbc09716c3f5fa45f9fa8d236149381", wif: "Ky6Fw4gDzCmDVsutqu6vLT4neebKGsDfzLJZumeM7RV4E4pbUXzB")
    ]
    
}
