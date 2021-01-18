//
//  MnemonicState.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore
 

public class MnemonicState: ObservableObject {
    
    public struct DerivedExtendedKey {
        let sequence: String
        let xpub: String
        let xprv: String
        let btcAddress: String
        let bchAddress: String
        let ethAddress: String
        let pubCompressed: String
        let prvWIF: String
    }
    
    public var bip32path = "m/44'/0'/0'/0" {
        didSet {
            generateInfo(range: derivedKeysRange)
        }
    }
    
    @Published var mnemonic: Mnemonic?
    @Published var errorMessage: String?
    
    var generator: KeyGenerator?
    var seed = ""
    var rootPrivateExtendedKey = ""
    var derivedKeys = [DerivedExtendedKey]()
    var derivedKeysRange = 0..<20
    
    var phrase: String {
        mnemonic?.words.joined(separator: " ") ?? ""
    }
    
    func create(length: Mnemonic.Length) {
        do {
            let _mnemonic = try Mnemonic(length: length)
            mnemonic = _mnemonic
            
            try createGenerator(mnemonic: _mnemonic)
    
        } catch let e as MnemonicError {
            self.errorMessage = description(from: e)
        } catch {
            self.errorMessage = description(from: nil)
        }
    }
    
    func create(phrase: String) {
        do {
            let _mnemonic = try Mnemonic(mnemonic: phrase.trimmingCharacters(in: .whitespaces).lowercased(), listType: .english)
            mnemonic = _mnemonic
            
            try createGenerator(mnemonic: _mnemonic)
            
        } catch let e as MnemonicError {
            self.errorMessage = description(from: e)
        } catch {
            self.errorMessage = description(from: nil)
        }
    }
    
    func createGenerator(mnemonic: Mnemonic) throws {
        let _generator = KeyGenerator(seed: mnemonic.seed)
        generator = _generator
        
        seed = mnemonic.seed.hex
        rootPrivateExtendedKey = _generator.extPrv
        
        try _generator.generate(for: bip32path)
        generateInfo(range: derivedKeysRange)
    }
    
    func generateInfo(range: Range<Int>) {
        var version: VersionSLIP0132 = .P2PKH_P2SH
        if bip32path.hasPrefix("m/84'/") { version = .P2WPKH }
        if bip32path.hasPrefix("m/49'/") { version = .P2WPKH_NESTED_P2SH}
        
        guard let _mnemonic = mnemonic else {
            return
        }
        
        let _generator = KeyGenerator(seed: _mnemonic.seed, version: version)
        generator = _generator
        
        rootPrivateExtendedKey = _generator.extPrv
        derivedKeysRange = range
        
        do {
            _generator.reset()
            try _generator.generate(for: bip32path)
            
            var keys: [ExtendedKey] = []
            for i in derivedKeysRange.map({ $0}) {
                keys.append(_generator.generateChild(for: UInt(i), hardened: false))
            }
            derivedKeys = try keys.map({
                
                DerivedExtendedKey(
                    sequence: "\($0.sequence)",
                    xpub: $0.serializedPub(),
                    xprv: $0.serializedPrv(),
                    btcAddress: try BitcoinPublicKeyAddress(key: $0.key).address,
                    bchAddress: try BitcoinCashAddress(data: $0.key.publicKeyCompressed(.CompressedConversion)).address,
                    ethAddress: try EthereumAddress(data: $0.key.publicKeyCompressed(.UncompressedConversion)).formattedAddress,
                    pubCompressed: $0.key.publicKeyCompressed(.CompressedConversion).hex,
                    prvWIF: try BitcoinPrivateKeyAddress(key: $0.key).wif)
            })
            
        } catch let e as KeyDerivationError {
            switch e {
            case .wrongPath:
                self.errorMessage = MnemonicErrorDescription.generateBIP32pathError
            }
        } catch {
            self.errorMessage = MnemonicErrorDescription.unknownError
        }
    }
    
    func description(from error: MnemonicError?) -> String {
        switch error {
        case .wordsError: return MnemonicErrorDescription.mnemonicPhraseError
        case .wordsCountError: return MnemonicErrorDescription.mnemonicWordsCountError
        case .generationError: return MnemonicErrorDescription.mnemonicCreateError
        case .bitsLengthError: return MnemonicErrorDescription.mnemonicEntropyError
        case .checksumError: return MnemonicErrorDescription.mnemonicChecksumError
        default:
            return MnemonicErrorDescription.unknownError
        }
    }
}

