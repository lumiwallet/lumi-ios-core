//
//  BitcoinAddOutputView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct BitcoinAddOutputView: View {
    
    @EnvironmentObject private var store: Store<AppState, AppAction>
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var type: TransactionType
    
    @Binding var presentAddInput: Bool
    
    @State private var address: String = ""
    @State private var value: String = ""
    
    @State var alertShow = false
    
    var outputState: Published<Bool?>.Publisher {
        if type == .bitcoin {
            return self.store.state.btcTransactionState.$outputCreated
        } else {
            return self.store.state.bchTransactionState.$outputCreated
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
    
    var transactionOutputInfo: TransactionOutputInfo {
        TransactionOutputInfo(address: address, value: value)
    }
    
    var bottomButtonPadding: CGFloat {
        if keyboard.height > 0 {
            return (10 - (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0)) + keyboard.height
        } else {
            return 10 + (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0) + keyboard.height
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10, content: {
                VStack(alignment: .leading) {
                    Text(BitcoinTransactionText.Input.bitcoinAddressTitle)
                        .lumiTextStyle(.title)
                    
                    HStack {
                        TextField(BitcoinTransactionText.Input.bitcoinAddressPlaceholder, text: $address)
                            .disableAutocorrection(true)
                            .lumiTextStyle(.title)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                HStack {
                    Text(BitcoinTransactionText.Input.amountTitle)
                       .lumiTextStyle(.title)
                               
                   Spacer()
                   TextField("0", text: $value)
                        .keyboardType(.numberPad)
                        .disableAutocorrection(true)
                   Text("SAT")
                       .lumiTextStyle(.listItem)
                }
                .underlined()
                .frame(height: 30)
               .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            })

            Spacer()
            
            Button(action: {
                self.actionAddOutputButton()
            }, label: {
                HStack {
                    Spacer()
                    Text(BitcoinTransactionText.addOutputButton)
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
                                bottom: bottomButtonPadding,
                                trailing: 20))
        }
        .padding(.top, 20)
        .navigationBarTitle("\(NavigationBarTitleText.bitcoinAddOutput)", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(ImageName.navigationBackButton)
                        .foregroundColor(Color.black)
                })
        )
        .onTapGesture(perform: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
        .alert(isPresented: $alertShow, content: { () -> Alert in
            Alert(title: Text(ErrorText.title), message: Text("\(errorText)"), dismissButton: .cancel({
                self.actionResetError()
            }))
        })
        .onReceive(errorState, perform: { output in
            guard let _ = output else {
                return
            }
            guard self.alertShow == false else {
                return
            }
            self.alertShow = true
        })
        .onReceive(outputState) { output in
            guard let success = output else {
                return
            }
            if success {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
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
    
    func actionAddOutputButton() {
        switch type {
        case .bitcoin:
            self.store.send(action: .txBitcoin(.addOutput(transactionOutputInfo)))
        case .bitcoinCash:
            self.store.send(action: .txBitcoinCash(.addOutput(transactionOutputInfo)))
        default:
            ()
        }
    }
}
