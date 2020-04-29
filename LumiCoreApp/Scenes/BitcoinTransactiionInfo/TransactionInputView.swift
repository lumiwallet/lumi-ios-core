//
//  TransactionInputView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct TransactionInputView: View {
    
    let address: String
    let value: String
    let script: String
    let hash: String
    let wifPrivate: String
    
    let leftColumnWidth: CGFloat = 50
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(BitcoinTransactionText.InputInfo.valueTitle)
                    .lumiTextStyle(.infoPrefix)
                    .frame(minWidth: leftColumnWidth, alignment: .leading)
                LumiText(value)
                    .lumiTextStyle(.infoBody)
            }
            HStack(alignment: .top) {
                Text(BitcoinTransactionText.InputInfo.addressTitle)
                    .lumiTextStyle(.infoPrefix)
                    .frame(minWidth: leftColumnWidth, alignment: .leading)
                LumiText(address)
                    .lumiTextStyle(.infoBody)
            }
            HStack(alignment: .top) {
                Text(BitcoinTransactionText.InputInfo.hashTitle)
                    .lumiTextStyle(.infoPrefix)
                    .frame(minWidth: leftColumnWidth, alignment: .leading)
                LumiText(hash)
                    .lumiTextStyle(.infoBody)
            }
            HStack(alignment: .top) {
                Text(BitcoinTransactionText.InputInfo.scriptTitle)
                    .lumiTextStyle(.infoPrefix)
                    .frame(minWidth: leftColumnWidth, alignment: .leading)
                LumiText(script)
                    .lumiTextStyle(.infoBody)
            }
            HStack(alignment: .top) {
                Text(BitcoinTransactionText.InputInfo.wifTitle)
                    .lumiTextStyle(.infoPrefix)
                    .frame(minWidth: leftColumnWidth, alignment: .leading)
                LumiText(wifPrivate)
                    .lumiTextStyle(.infoBody)
            }
        }
        .padding(.bottom, 10)
        .underlined()
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
}
