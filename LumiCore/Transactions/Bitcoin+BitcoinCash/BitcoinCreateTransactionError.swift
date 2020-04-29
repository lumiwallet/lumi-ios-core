//
//  BitcoinCreateTransactionError.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public enum BitcoinCreateTransactionError: Error {
    case wrongSignature
    case privateKeyNotFound
}
