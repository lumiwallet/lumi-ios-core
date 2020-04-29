//
//  BitcoinTransactionResultView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct BitcoinTransactionResultView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    let transactionType: TransactionType
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Image(ImageName.logo)
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text(BitcoinTransactionText.Result.hashTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(transactionResult?.hash ?? "")")
                        .lumiTextStyle(.infoBody)
                }
                
                VStack(alignment: .leading) {
                    Text(BitcoinTransactionText.Result.rawTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(transactionResult?.raw ?? "")")
                        .lumiTextStyle(.infoBody)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    Text(BitcoinTransactionText.Result.descriptionTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(transactionResult?.description ?? "")")
                        .lumiTextStyle(.infoBody)
                }
                .padding(.top, 20)
                 
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16))
        }
        .onDisappear {
            switch self.transactionType {
            case .bitcoin:
                self.store.state.btcTransactionState.transactionResultInfo = nil
            case .bitcoinCash:
                self.store.state.bchTransactionState.transactionResultInfo = nil
            default:
                ()
            }
        }
    }
    
    var transactionResult: BitcoinTransactionResult? {
        switch transactionType {
        case .bitcoin:
            return store.state.btcTransactionState.transactionResultInfo
        case .bitcoinCash:
            return store.state.bchTransactionState.transactionResultInfo
        default:
            return nil
        }
    }
}
