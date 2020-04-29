//
//  BitcoinTransactionInfoView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct BitcoinTransactionInfoView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var type: TransactionType = .bitcoin
    
    @State var address: String = ""
    @State var feePerByte: String = "0"
    
    @State var addInputViewShow = false
    @State var addOutputViewShow = false
    
    @State var alertShow = false
    @State var transactionResultShow = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header:
                    HStack {
                        Text(BitcoinTransactionText.inputsTitle)
                            .lumiTextStyle(.title)
                        Spacer()
                        Button(action: {
                            self.actionAddInputButton()
                        }, label: {
                            Text(BitcoinTransactionText.addInputButton)
                        })
                        .font(.custom(LumiFonts.popinsLight, size: 12))
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    ) {
                        
                    ForEach(inputsInfo, id: \.self) {
                        TransactionInputView(address: $0.address, value: $0.value, script: $0.script, hash: $0.hash, wifPrivate: $0.wifPrivateKey)
                    }
                    .onDelete(perform: actionDeleteInput(indexes:))
                }
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                
                Section(header:
                    HStack {
                        Text(BitcoinTransactionText.ouputsTitle)
                            .lumiTextStyle(.title)
                        Spacer()
                        Button(action: {
                            self.actionAddOutputButton()
                        }, label: {
                            Text(BitcoinTransactionText.addOutputButton)
                        })
                        .font(.custom(LumiFonts.popinsLight, size: 12))
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    ) {
                        
                    ForEach(outputsInfo, id: \.self) {
                        TransactionOutputView(address: $0.address, value: $0.value)
                    }
                    .onDelete(perform: actionDeleteOutput(indexes:))
                }
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                
            }
            .listStyle(GroupedListStyle())
            
            Spacer()
            
            Button(action: {
                self.actionBuildButton()
            }, label: {
                HStack {
                    Spacer()
                    Text(BitcoinTransactionText.buttonBuild)
                        .font(.custom(LumiFonts.popinsSemibold, size: 22))
                    .padding([.top, .bottom], 20)
                    Spacer()
                }
                .frame(height: 57)
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(8)
            })
            .padding(EdgeInsets(top: 0,
                                leading: 20,
                                bottom: 10 + (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0),
                                trailing: 20))
            
            NavigationLink(destination: BitcoinAddInputView(type: type, presentAddInput: $addInputViewShow), isActive: $addInputViewShow) {
                Text("")
            }.hidden()
            NavigationLink(destination: BitcoinAddOutputView(type: type, presentAddInput: $addOutputViewShow), isActive: $addOutputViewShow) {
                Text("")
            }.hidden()
        }
            
        .alert(isPresented: $alertShow, content: { () -> Alert in
            Alert(title: Text(ErrorText.title), message: Text(errorText), dismissButton: .cancel({
                self.actionResetError()
            }))
        })
        .sheet(isPresented: $transactionResultShow) {
            BitcoinTransactionResultView(transactionType: self.type).environmentObject(self.store)
        }
        .onReceive(errorState, perform: { error in
            guard let _ = error else {
                return
            }
            self.alertShow = true
        })
        .onReceive(transactionResultState, perform: { tx in
            guard let _ = tx else {
                return
            }
            self.transactionResultShow = true
        })
            
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.actionCleanTransaction()
                }, label: {
                    Image(ImageName.navigationBackButton)
                        .foregroundColor(Color.black)
                })
        )
        .navigationBarTitle("\(navigationBarTitle)", displayMode: .automatic)
    }
    
    func actionResetError() {
        switch type {
        case .bitcoin:
            self.store.send(action: .txBitcoin(.resetError))
        case .bitcoinCash:
            self.store.send(action: .txBitcoinCash(.resetError))
        default:
            ()
        }
    }
    
    func actionCleanTransaction() {
        switch type {
        case .bitcoin:
            self.store.send(action: .txBitcoin(.clear))
        case .bitcoinCash:
            self.store.send(action: .txBitcoinCash(.clear))
        default:
            ()
        }
    }
    
    func actionBuildButton() {
        switch type {
        case .bitcoin:
            self.store.send(action: .txBitcoin(.build))
        case .bitcoinCash:
            self.store.send(action: .txBitcoinCash(.build))
        default:
            ()
        }
    }
    
    func actionAddInputButton() {
        switch type {
        case .bitcoin:
            self.store.send(action: .txBitcoin(.resetError))
            self.addInputViewShow = true
        case .bitcoinCash:
            self.store.send(action: .txBitcoinCash(.resetError))
            self.addInputViewShow = true
        default:
            ()
        }
    }
    
    func actionDeleteInput(indexes: IndexSet) {
        switch type {
        case .bitcoin:
            indexes.forEach({
                self.store.send(action: .txBitcoin(.deleteInput(index: $0)))
            })
        case .bitcoinCash:
            indexes.forEach({
                self.store.send(action: .txBitcoinCash(.deleteInput(index: $0)))
            })
        default:
            ()
        }
    }
    
    func actionDeleteOutput(indexes: IndexSet) {
        switch type {
        case .bitcoin:
            indexes.forEach({
                self.store.send(action: .txBitcoin(.deleteOutput(index: $0)))
            })
        case .bitcoinCash:
            indexes.forEach({
                self.store.send(action: .txBitcoinCash(.deleteOutput(index: $0)))
            })
        default:
            ()
        }
    }
    
    func actionAddOutputButton() {
        switch type {
        case .bitcoin:
            self.store.send(action: .txBitcoin(.resetError))
            self.addOutputViewShow = true
        case .bitcoinCash:
            self.store.send(action: .txBitcoinCash(.resetError))
            self.addOutputViewShow = true
        default:
            ()
        }
    }
    
    var inputsInfo: [BitcoinTransactionState.InputInfo] {
        switch type {
        case .bitcoin:
            return store.state.btcTransactionState.inputs
        case .bitcoinCash:
            return store.state.bchTransactionState.inputs
        default:
            return []
        }
    }
    
    var outputsInfo: [BitcoinTransactionState.OutputInfo] {
        switch type {
        case .bitcoin:
            return store.state.btcTransactionState.outputs
        case .bitcoinCash:
            return store.state.bchTransactionState.outputs
        default:
            return []
        }
    }
    
    var transactionResultState: Published<BitcoinTransactionResult?>.Publisher {
        if type == .bitcoin {
            return self.store.state.btcTransactionState.$transactionResultInfo
        } else {
            return self.store.state.bchTransactionState.$transactionResultInfo
        }
    }
    
    var errorState: Published<String?>.Publisher {
        if type == .bitcoin {
            return self.store.state.btcTransactionState.$errorMessage
        } else {
            return self.store.state.bchTransactionState.$errorMessage
        }
    }
    
    var errorText: String {
        if type == .bitcoin {
            return self.store.state.btcTransactionState.errorMessage ?? ""
        } else {
            return self.store.state.bchTransactionState.errorMessage ?? ""
        }
    }
    
    var navigationBarTitle: String {
        switch type {
        case .bitcoin:
            return NavigationBarTitleText.bitcoinTransactionInfo
        case .bitcoinCash:
            return NavigationBarTitleText.bitcoinCashTransactionInfo
        default:
            return ""
        }
    }
}
