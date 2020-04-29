//
//  MnemonicErrors.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public enum MnemonicError: Error {
    case wordsCountError
    case wordsError
    case checksumError
    case generationError
    case bitsLengthError
}
