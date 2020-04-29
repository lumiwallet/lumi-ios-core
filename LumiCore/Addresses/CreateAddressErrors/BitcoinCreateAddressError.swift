//
//  BitcoinCreateAddressError.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// Bitcoin public/private address creation errors
public enum BitcoinCreateAddressError: Error {
    case invalidDataLength
    case invalidHashDataLength
    case invalidKeyType
    case invalidAddressVersion
    case invalidWIFAddressVersion
    case invalidWIFAddressLength
}
