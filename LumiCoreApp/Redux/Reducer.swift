//
//  Reducer.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import Combine


public struct Reducer<State, Action> {
    public typealias Change = (inout State) -> Void
    
    let reduce: (State, Action) -> AnyPublisher<Change, Never>
    
    public static func sync(_ f: @escaping (inout State) -> Void ) -> AnyPublisher<Change, Never> {
        Just(f).eraseToAnyPublisher()
    }
}


extension Reducer where State == AppState, Action == AppAction {
    
    static func appReducer() -> Reducer {
        return Reducer(reduce: { (state, action) in
            switch action {
            case let .mnemonic(.createWithStrenght(value)):
                state.mnemonic.create(length: MnemonicStrenghtList.values[value])
            case let .mnemonic(.createWithPhrase(phrase)):
                state.mnemonic.create(phrase: phrase)
            case let .mnemonic(.updateWithPath(path: bip32path)):
                state.mnemonic.bip32path = bip32path
            case let .mnemonic(.updateWithRange(range: indexRange)):
                state.mnemonic.generateInfo(range: indexRange)
            case .mnemonic(.clear):
                state.mnemonic = MnemonicState()
                 
            case let .txBitcoin(.addInput(input)):
                state.btcTransactionState.addUnspentOutput(info: input)
            case let .txBitcoin(.addOutput(output)):
                state.btcTransactionState.addOutput(info: output)
            case .txBitcoin(.build):
                state.btcTransactionState.build()
            case let .txBitcoin(.deleteInput(index: index)):
                state.btcTransactionState._inputs.remove(at: index)
                state.btcTransactionState.privateKeys.remove(at: index)
            case let .txBitcoin(.deleteOutput(index: index)):
                state.btcTransactionState._outputs.remove(at: index)
            case .txBitcoin(.resetError):
                state.btcTransactionState.errorMessage = nil
            case .txBitcoin(.clear):
                state.btcTransactionState = BitcoinTransactionState()
                
            case let .txBitcoinCash(.addInput(input)):
                state.bchTransactionState.addUnspentOutput(info: input)
            case let .txBitcoinCash(.addOutput(output)):
                state.bchTransactionState.addOutput(info: output)
            case .txBitcoinCash(.build):
                state.bchTransactionState.build()
            case let .txBitcoinCash(.deleteInput(index: index)):
                state.bchTransactionState._inputs.remove(at: index)
                state.bchTransactionState.privateKeys.remove(at: index)
            case let .txBitcoinCash(.deleteOutput(index: index)):
                state.bchTransactionState._outputs.remove(at: index)
            case .txBitcoinCash(.resetError):
                state.bchTransactionState.errorMessage = nil
            case .txBitcoinCash(.clear):
                state.bchTransactionState = BitcoinCashTransactionState()
                
                
            case let .txEthereum(.build(info: info)):
                state.ethTransactionState.build(info: info)
            case .txEthereum(.resetError):
                state.ethTransactionState.errorMessage = nil
            case .txEthereum(.clear):
                state.ethTransactionState = EthereumTransactionState()
                
                
            case let .txEos(.build(info: info)):
                state.eosTransactionState.build(info: info)
            case .txEos(.resetError):
                state.eosTransactionState.errorMessage = nil
            case .txEos(.clear):
                state.eosTransactionState = EosTransactionState()

            }
            return Reducer.sync({ state in })
        })
    }
}
