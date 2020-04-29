//
//  MnemonicInputPathView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct MnemonicInputPathView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @State var text: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(MnemonicInfoViewText.bip32title)
                        .lumiTextStyle(.title)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                HStack(alignment: .center) {
                    TextField(text, text: $text)
                        .disableAutocorrection(true)
                        .underlined()
                        .frame(height: 30)
                    
                    Button(action: {
                        self.store.send(action: .mnemonic(.updateWithPath(path: self.text)))
                    }, label: {
                        Text(MnemonicInfoViewText.bip32button)
                            .lumiTextStyle(.title)
                    })
                    .padding(EdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16))
                    .lumiBorder()
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
        }
        .frame(height: 50)
    }
}
