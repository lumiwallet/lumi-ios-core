//
//  EthereumTransactionResultInfo.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct EthereumTransactionResultView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Image(ImageName.logo)
            }.padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            ScrollView {
                VStack(alignment: .leading) {
                    Text(EthereumTransactionText.Result.rawTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(store.state.ethTransactionState.transactionResultInfo?.raw ?? "")")
                        .lumiTextStyle(.infoBody)
                }
                
                VStack(alignment: .leading) {
                    Text(EthereumTransactionText.Result.descriptionTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(store.state.ethTransactionState.transactionResultInfo?.description ?? "")")
                        .lumiTextStyle(.infoBody)
                }
                .padding(.top, 20)
                
            }.padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16))
        }
        .onDisappear {
            self.store.state.ethTransactionState.transactionResultInfo = nil
        }
    }
}
