//
//  Mnemonic.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import CommonCrypto


public class Mnemonic {
    
    static public let mnemonicSalt = "mnemonic"
    
    /*
     https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki
     The following table describes the relation between the initial entropy length (ENT),
     the checksum length (CS) and the length of the generated mnemonic sentence (MS) in words.
     
     CS = ENT / 32
     MS = (ENT + CS) / 11

     |  ENT  | CS | ENT+CS |  MS  |
     +-------+----+--------+------+
     |  128  |  4 |   132  |  12  |
     |  160  |  5 |   165  |  15  |
     |  192  |  6 |   198  |  18  |
     |  224  |  7 |   231  |  21  |
     |  256  |  8 |   264  |  24  |
    */
    
    public enum Length: Int, CaseIterable {
        case ms12 = 12
        case ms15 = 15
        case ms18 = 18
        case ms21 = 21
        case ms24 = 24
        
        var wordsCount: Int {
            rawValue
        }
        
        var bytesLength: Int {
            switch self {
            case .ms12: return 16
            case .ms15: return 20
            case .ms18: return 24
            case .ms21: return 28
            case .ms24: return 32
            }
        }
        
        var bitsLength: Int {
            bytesLength * 8
        }
    }

    public enum WordListType: Int8 {
        case english = 0
        case unknown = -1
    }
    
    public var wordListType: Mnemonic.WordListType = .english
    public let entropy: Data
    public let passphrase: String
    
    /// Init
    /// - Parameter entropy: Bytes (16, 20, 24, 28 and 32 lengths available)
    public init(entropy: Data, pass: String = "") throws {
        _ = try Mnemonic.makeWords(from: entropy)
        self.entropy = entropy
        self.passphrase = pass
    }
    
    /// Init
    /// - Parameter words: Words array
    /// - Parameter pass: Password
    /// - Parameter listType: Words list language (English only)
    public init(words: [String], pass: String = "", listType: Mnemonic.WordListType) throws {
        guard Mnemonic.Length.allCases.contains(where: { $0.wordsCount == words.count }) else {
            throw MnemonicError.wordsCountError
        }
        
        wordListType = listType
        entropy = try Mnemonic.makeEntropy(from: words)
        passphrase = pass
    }
    
    /// Init
    /// - Parameter length: Mnemonic words count
    convenience public init(length: Mnemonic.Length = .ms12) throws {
        guard let random = CommonRandom.generate(length: length.bytesLength) else {
            throw MnemonicError.generationError
        }
        try self.init(entropy: random)
    }
    
    /// Init
    /// - Parameter phrase: Mnemonic phrase
    /// - Parameter pass: Password
    /// - Parameter listType: Words list language (English only)
    convenience public init(mnemonic phrase: String, pass: String = "", listType: Mnemonic.WordListType) throws {
        let words = phrase.components(separatedBy: " ")
        try self.init(words: words, pass: pass, listType: listType)
    }
    
    public var words: [String] {
        return (try? Mnemonic.makeWords(from: entropy)) ?? []
    }
    
    public var seed: Data  {
        guard let mnemonic = words.joined(separator: " ").decomposedStringWithCompatibilityMapping.data(using: .utf8),
            let salt = (Mnemonic.mnemonicSalt + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8)
        else {
            fatalError("Fatal error: Can't create seed")
        }
        
        let int8mnemonic = mnemonic.withUnsafeBytes({
            [Int8]($0.bindMemory(to: Int8.self))
        })
        
        let uint8salt = salt.withUnsafeBytes({
            [UInt8]($0)
        })

        let seedLength = 64
        var uint8seed = Array<UInt8>(repeating: 0, count: seedLength)
        
        CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), int8mnemonic, mnemonic.count, uint8salt, salt.count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA512), 2048, &uint8seed, seedLength)
        
        let seed = Data(uint8seed)
        return seed
    }
    
    private class func setBit(buffer: inout Data, bitIndex: Int) {
        let byteIndex = bitIndex / 8
        buffer[byteIndex] = buffer[byteIndex] | (1 << (7 - bitIndex % 8))
    }

    private class func isBitSet(buffer: inout Data, bitIndex: Int) -> Bool {
        let byteIndex = bitIndex / 8
        let n = bitIndex % 8
        
        let value = (buffer[byteIndex] << n) & 0x80
        return value == 0x80
    }

    private class func integerTo11Bits(buffer: inout Data, bitIndex: Int, integer: Int) {
        var value = integer
        
        for i in 0..<11 {
            if value & 0x400 == 0x400 {
                setBit(buffer: &buffer, bitIndex: bitIndex + i)
            }
            value = value << 1
        }
    }

    private class func integerFrom11Bits(buffer: inout Data, bitIndex: Int) -> Int {
        var value = 0
        
        for i in 0..<11 {
            value = value << 1
            
            if isBitSet(buffer: &buffer, bitIndex: bitIndex + i) {
                value |= 0x01
            }
        }
        
        return value
    }

    private class func makeWords(from entropy: Data) throws -> [String] {
        let bitsLength = entropy.count * 8
        
        if !Mnemonic.Length.allCases.contains(where: { $0.bitsLength == bitsLength }) {
            throw MnemonicError.bitsLengthError
        }
        
        let checksumLength = bitsLength / 32
        let hash = entropy.sha256()
        
        let checksum = (0xFF << (8 - UInt8(checksumLength))) & hash[0]
        
        var entropyWithChecksum = entropy + Data([checksum])
        let wordsCount = (bitsLength + checksumLength) / 11
        
        var words = [String]()
        
        for i in 0..<wordsCount {
            let wordIndex = integerFrom11Bits(buffer: &entropyWithChecksum, bitIndex: i * 11)
            words.append(englishWordList[wordIndex])
        }
        
        return words
    }

    private class func makeEntropy(from words: [String]) throws -> Data {
        let bitLength = words.count * 11
        var buffer = Data(repeating: 0, count: (bitLength / 8) + ((bitLength % 8 > 0) ? 1 : 0))
        
        for i in 0..<words.count {
            let word = words[i]
            
            guard let wordIndex = englishWordList.firstIndex(of: word) else {
                throw MnemonicError.wordsError
            }
            
            let bitIndex = i * 11
            integerTo11Bits(buffer: &buffer, bitIndex: bitIndex, integer: wordIndex)
        }
        
        let entropy = buffer.subdata(in: 0..<(buffer.count - 1))
        let checksumLength = UInt8(bitLength / 32)
        let hash = entropy.sha256()
        
        let checksum = (0xFF << (8 - UInt8(checksumLength))) & hash[0]
        
        if checksum != buffer.last {
            throw MnemonicError.checksumError
        }
        
        return entropy
    }
}
