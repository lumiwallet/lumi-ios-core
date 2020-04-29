//
//  EosTransactionResultView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct EosTransactionResultView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Image(ImageName.logo)
            }.padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            ScrollView {
                VStack(alignment: .leading) {
                    Text(EosTransactionText.Result.transactionDataTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(store.state.eosTransactionState.transactionResultInfo?.packedTrx ?? "")")
                        .lumiTextStyle(.infoBody)
                }

                VStack(alignment: .leading) {
                    Text(EosTransactionText.Result.signaturesTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(store.state.eosTransactionState.transactionResultInfo?.signatures ?? "")")
                        .lumiTextStyle(.infoBody)
                }
                .padding(.top, 20)

            }.padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16))
        }
        .onDisappear {
            self.store.state.eosTransactionState.transactionResultInfo = nil
        }
    }
}
