//
//  MnemonicKeyView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct MnemonicKeyView: View {
    
    let key: MnemonicState.DerivedExtendedKey
    
    let infoPrefixColumnWidth: CGFloat = 40
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.sequnceTitle)
                        .lumiTextStyle(.infoPrefix)
                    LumiText("\(key.sequence)")
                        .lumiTextStyle(.infoBody)
                }
                Text(MnemonicInfoViewText.KeyInfo.addressesTitle)
                    .lumiTextStyle(.infoBody)
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.btcAddress)
                        .lumiTextStyle(.infoPrefix)
                        .frame(width: infoPrefixColumnWidth, alignment: .leading)
                    LumiText("\(key.btcAddress)")
                        .lumiTextStyle(.infoBody)
                    Spacer()
                }
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.bchAddress)
                        .lumiTextStyle(.infoPrefix)
                        .frame(width: infoPrefixColumnWidth, alignment: .leading)
                    LumiText("\(key.bchAddress)")
                        .lumiTextStyle(.infoBody)
                    Spacer()
                }
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.ethAddress)
                        .lumiTextStyle(.infoPrefix)
                        .frame(width: infoPrefixColumnWidth, alignment: .leading)
                    LumiText("\(key.ethAddress)")
                        .lumiTextStyle(.infoBody)
                    Spacer()
                }
                
                Text(MnemonicInfoViewText.KeyInfo.keysTitle)
                .lumiTextStyle(.infoBody)
                
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.pubData)
                        .lumiTextStyle(.infoPrefix)
                        .frame(width: infoPrefixColumnWidth, alignment: .leading)
                    LumiText("\(key.pubCompressed)")
                        .lumiTextStyle(.infoBody)
                    Spacer()
                }
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.prvData)
                        .lumiTextStyle(.infoPrefix)
                        .frame(width: infoPrefixColumnWidth, alignment: .leading)
                    LumiText("\(key.prvWIF)")
                        .lumiTextStyle(.infoBody)
                    Spacer()
                }
                
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.xpub)
                        .lumiTextStyle(.infoPrefix)
                        .frame(width: infoPrefixColumnWidth, alignment: .leading)
                    LumiText("\(key.xpub)")
                        .lumiTextStyle(.infoBody)
                    Spacer()
                }
                HStack {
                    Text(MnemonicInfoViewText.KeyInfo.xprv)
                        .lumiTextStyle(.infoPrefix)
                        .frame(width: infoPrefixColumnWidth, alignment: .leading)
                    LumiText("\(key.xprv)")
                        .lumiTextStyle(.infoBody)
                    Spacer()
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .underlined()
        }
    }
}
