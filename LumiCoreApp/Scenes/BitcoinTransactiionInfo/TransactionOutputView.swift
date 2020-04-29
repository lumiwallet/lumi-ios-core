//
//  TransactionOutputView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct TransactionOutputView: View {
    
    let address: String
    let value: String
    
    let leftColumnWidth: CGFloat = 50
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(BitcoinTransactionText.OutputInfo.valueTitle)
                    .lumiTextStyle(.infoPrefix)
                    .frame(minWidth: leftColumnWidth, alignment: .leading)
                LumiText(value)
                    .lumiTextStyle(.infoBody)
            }
            HStack(alignment: .top) {
                Text(BitcoinTransactionText.OutputInfo.addressTitle)
                    .lumiTextStyle(.infoPrefix)
                    .frame(minWidth: leftColumnWidth, alignment: .leading)
                LumiText(address)
                    .lumiTextStyle(.infoBody)
                Spacer()
            }
        }
        .padding(.bottom, 10)
        .underlined()
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
