//
//  AppActions.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public enum AppAction {
    case mnemonic(MnemonicAction)
    case txBitcoin(BitcoinTransactionAction)
    case txBitcoinCash(BitcoinTransactionAction)
    case txEthereum(EthereumTransactionAction)
    case txEos(EosTransactionAction)
}


public enum MnemonicAction {
    case createWithStrenght(Int)
    case createWithPhrase(String)
    case updateWithPath(path: String)
    case updateWithRange(range: Range<Int>)
    case clear
}


public enum BitcoinTransactionAction {
    case addInput(TransactionInputInfo)
    case addOutput(TransactionOutputInfo)
    case build
    case resetError
    case deleteInput(index: Int)
    case deleteOutput(index: Int)
    case clear
}


public enum EthereumTransactionAction {
    case build(info: EthereumTransactionInfo)
    case clear
    case resetError
}


public enum EosTransactionAction {
    case build(info: EosTransactionInfo)
    case clear
    case resetError
}
