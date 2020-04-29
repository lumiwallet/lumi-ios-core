//
//  MnemonicInputRangeView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct MnemonicInputRangeView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @State var lBoundsText: String
    @State var uBoundsText: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(MnemonicInfoViewText.rangeTitle)
                        .lumiTextStyle(.title)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                HStack(alignment: .center) {
                    TextField(lBoundsText, text: $lBoundsText)
                        .underlined()
                        .frame(height: 30)
                        .keyboardType(.numberPad)
                    
                    Text("<")
                    
                    TextField(uBoundsText, text: $uBoundsText)
                        .underlined()
                        .frame(height: 30)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        let lbound = Int(self.lBoundsText, radix: 10) ?? 0
                        let rbound = Int(self.uBoundsText, radix: 10) ?? 0
                        if lbound > rbound {
                            return
                        }
                        self.store.send(action: .mnemonic(.updateWithRange(range: Range(uncheckedBounds: (lbound, rbound)))))
                    }, label: {
                        Text(MnemonicInfoViewText.rangeButton)
                            .lumiTextStyle(.title)
                    })
                    .padding(EdgeInsets(top: 9, leading: 38, bottom: 9, trailing: 38))
                    .lumiBorder()
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
        }
    }
}
