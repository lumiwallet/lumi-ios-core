//
//  MainView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    static let mainMenuRowHeight: CGFloat = 48
    static let mainMenuListRowInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    @State var mnemonicWordsPickerShow = false
    @State var mnemonicInputPhraseShow = false
    @State var mnemonicDetailViewShow = false
    @State var bitcionTransactionInfoViewShow = false
    @State var bitcionCashTransactionInfoViewShow = false
    @State var ethereumTransactionInfoViewShow = false
    @State var eosTransactionInfoViewShow = false
    @State var aboutViewShow = false
    
    @State var alertShow: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(header:
                        MainViewTitleLabel(title: MainViewText.Titles.mnemonicPhrase))
                    {
                        Button<MainViewItemLabel>.lumiMainMenuButton(title: MainViewText.MenuItems.createMnemonic) {
                            withAnimation {
                               self.mnemonicWordsPickerShow = true
                            }
                        }
                        .separated()
                        
                        Button<MainViewItemLabel>.lumiMainMenuButton(title: MainViewText.MenuItems.importMnemonic) {
                            self.mnemonicInputPhraseShow = true
                        }
                    }
                    
                    Section(header:
                        MainViewTitleLabel(title: MainViewText.Titles.createTransaction))
                    {
                        Button<MainViewItemLabel>.lumiMainMenuButton(title: MainViewText.MenuItems.bitcoinTransaction) {
                            self.bitcionTransactionInfoViewShow = true
                        }
                        .separated()
                        
                        Button<MainViewItemLabel>.lumiMainMenuButton(title: MainViewText.MenuItems.bitcoinCashTransaction) {
                            self.bitcionCashTransactionInfoViewShow = true
                        }
                        .separated()
                        
                        Button<MainViewItemLabel>.lumiMainMenuButton(title: MainViewText.MenuItems.ethereumTransaction) {
                            self.ethereumTransactionInfoViewShow = true
                        }
                        .separated()
                        
                        Button<MainViewItemLabel>.lumiMainMenuButton(title: MainViewText.MenuItems.eosTransaction) {
                            self.eosTransactionInfoViewShow = true
                        }
                        
                        Spacer(minLength: 50)
                        
                        Button<MainViewItemLabel>.lumiMainMenuButton(title: MainViewText.MenuItems.aboutLumi) {
                            self.aboutViewShow = true
                        }
                    }
                }
                .onReceive(store.state.mnemonic.$mnemonic, perform: { output in
                    guard let _ = output else {
                        return
                    }
                    self.mnemonicDetailViewShow = true
                })
                .alert(isPresented: $alertShow, content: { () -> Alert in
                    Alert(title: Text(ErrorText.title), message: Text("\(self.store.state.mnemonic.errorMessage ?? "")"), dismissButton: .cancel())
                })
                .onReceive(store.state.mnemonic.$errorMessage, perform: { output in
                    guard let _ = output else {
                        return
                    }
                    guard self.mnemonicInputPhraseShow == false else {
                        return
                    }
                    self.alertShow = true
                })
                .environment(\.defaultMinListRowHeight, MainView.mainMenuRowHeight)
                    .navigationBarTitle("", displayMode: .automatic)
                    .navigationBarItems(leading: HStack { Image(ImageName.logo) } )
                .listStyle(GroupedListStyle())
                .sheet(isPresented: $mnemonicInputPhraseShow, content: {
                    MnemonicImportView(show: self.$mnemonicInputPhraseShow).environmentObject(self.store)
                })
                .pickerBottomSheet(isPresented: $mnemonicWordsPickerShow, sheetContent: {
                    MnemonicStrenghtPickerView(isPresent: self.$mnemonicWordsPickerShow).environmentObject(self.store)
                })
                
                NavigationLink(destination: MnemonicInfoView(), isActive: $mnemonicDetailViewShow) {
                    Text("")
                }.hidden()
                NavigationLink(destination: BitcoinTransactionInfoView(type: .bitcoin), isActive: $bitcionTransactionInfoViewShow) {
                    Text("")
                }.hidden()
                NavigationLink(destination: BitcoinTransactionInfoView(type: .bitcoinCash), isActive: $bitcionCashTransactionInfoViewShow) {
                    Text("")
                }.hidden()
                NavigationLink(destination: EthereumTransactionInfoView(), isActive: $ethereumTransactionInfoViewShow) {
                    Text("")
                }.hidden()
                NavigationLink(destination: EosTransactionInfoView(), isActive: $eosTransactionInfoViewShow) {
                    Text("")
                }.hidden()
                NavigationLink(destination: AboutView(), isActive: $aboutViewShow) {
                    Text("")
                }.hidden()
            }
        }
    }
}

struct MainViewTitleLabel: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .lumiTextStyle(.title)
                .padding()
            Spacer()
        }
        .padding(0)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct MainViewItemLabel: View {
    let title: String

    init(title: String) {
        self.title = title
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .white
    }
    
    var body: some View {
        HStack {
            Text(title)
                .lumiTextStyle(.listItem)
            Spacer()
            Image("MainMenuItemArrowRight")
                .foregroundColor(Color.black)
        }
        .frame(height: 48)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}




// MARK: - Extensions

extension View {
    
    func separated() -> some View {
        self.modifier(SeparationLineModificator())
    }
}

extension Button {
    func lumiMainMenuInsets() -> some View {
        self.modifier(ButtonInsetsModifier())
    }
    
    func lumiTextStyle(_ style: TextModifier.TextStyle) -> some View {
        self.modifier(TextModifier(style))
    }
    
    static func lumiMainMenuButton(title: String, _ action: @escaping () -> Void) -> some View {
        Button<MainViewItemLabel>(action: action) {
            MainViewItemLabel(title: title)
        }.lumiMainMenuInsets()
    }
}

extension View {
    
    func lumiTextStyle(_ style: TextModifier.TextStyle) -> some View {
        self.modifier(TextModifier(style))
    }
}
