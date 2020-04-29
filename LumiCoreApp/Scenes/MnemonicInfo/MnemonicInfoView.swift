//
//  MnemonicInfoView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI

struct MnemonicInfoView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var infoBlockHeight: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        MnemonicInfoGroupTextView(title: MnemonicInfoViewText.mnemonicPhraseTitle, text: store.state.mnemonic.phrase)
                        MnemonicInfoGroupTextView(title: MnemonicInfoViewText.seedRepresentationTitle, text: store.state.mnemonic.seed)
                    }
                    ZStack {
                       VStack {
                            MnemonicInputPathView(text: store.state.mnemonic.bip32path)
                            
                            MnemonicInfoGroupTextView(title: MnemonicInfoViewText.masterPrivateTitle, text: store.state.mnemonic.rootPrivateExtendedKey)
                                .padding(.bottom, 5)
                        
                            MnemonicInputRangeView(
                                lBoundsText: "\(store.state.mnemonic.derivedKeysRange.lowerBound)",
                                uBoundsText: "\(store.state.mnemonic.derivedKeysRange.upperBound)"
                            )
                        
                            ZStack {
                                List(store.state.mnemonic.derivedKeys, id: \.self.sequence) { element in
                                    MnemonicKeyView(key: element)
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.55)
                            Spacer()
                        }
                       .padding(.top, 20)
                       .background(Color.clear)

                    }
                    .background(Color.white)
                    .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
                    .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.1), radius: 1, x: 0, y: -2)
                    .onTapGesture(perform: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.store.send(action: .mnemonic(.clear))
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(ImageName.navigationBackButton)
                        .foregroundColor(Color.black)
                })
        )
        .navigationBarTitle("\(NavigationBarTitleText.mnemonicInfo)", displayMode: .automatic)
    }
}

struct MnemonicInfoGroupTextView: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                .lumiTextStyle(.title)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                Spacer()
            }
            .padding(.bottom, 4)
            
            HStack {
                LumiText(text)
                .lumiTextStyle(.listItem)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}
