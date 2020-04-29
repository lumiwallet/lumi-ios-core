//
//  EosKeyErrors.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public enum EosKeyError: Error {
    case decodeBase58
    case dataLength
}
