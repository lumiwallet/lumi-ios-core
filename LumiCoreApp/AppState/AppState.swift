//
//  AppState.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore


public struct MnemonicStrenghtList {
    static var values: [Mnemonic.Length] = Mnemonic.Length.allCases
}


public final class AppState {

    var mnemonic = MnemonicState()
    
    var btcTransactionState = BitcoinTransactionState()
    var bchTransactionState = BitcoinCashTransactionState()
    var ethTransactionState = EthereumTransactionState()
    var eosTransactionState = EosTransactionState()
}
