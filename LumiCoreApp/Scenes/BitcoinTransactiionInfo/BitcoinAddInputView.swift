//
//  BitcoinAddInputView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import SwiftUI


struct BitcoinAddInputView: View {
    
    @EnvironmentObject private var store: Store<AppState, AppAction>
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var type: TransactionType
    
    @Binding var presentAddInput: Bool
    
    @State private var address: String = ""
    @State private var value: String = ""
    @State private var outputN: String = ""
    @State private var script: String = ""
    @State private var hash: String = ""
    @State private var wifPrivateKey: String = ""
    
    @State var alertShow = false
    
    @State var addInputCompletion: (() -> Void)?
    
    var input: TransactionInputInfo {
        TransactionInputInfo(address: address, value: value, n: outputN, script: script, hash: hash, wifPrivateKey: wifPrivateKey)
    }
    
    var inputState: Published<Bool?>.Publisher {
        if type == .bitcoin {
            return self.store.state.btcTransactionState.$inputCreated
        } else {
            return self.store.state.bchTransactionState.$inputCreated
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
    
    var bottomButtonPadding: CGFloat {
        if keyboard.height > 0 {
            return (10 - (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0)) + keyboard.height
        } else {
            return 10 + (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0) + keyboard.height
        }
    }
    
    var transactionInputInfo: TransactionInputInfo {
        TransactionInputInfo(address: address, value: value, n: outputN, script: script, hash: hash, wifPrivateKey: wifPrivateKey)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22, content: {
                    
                    LumiHeaderTexField(header: BitcoinTransactionText.Input.bitcoinAddressTitle, input: $address, placeholder: BitcoinTransactionText.Input.bitcoinAddressPlaceholder)
                    
                    LumiTextField(title: BitcoinTransactionText.Input.amountTitle, endTitle: "SAT", placeholder: "0", input: $value)
                    
                    LumiTextField(title: BitcoinTransactionText.Input.outputTitle, endTitle: "", placeholder: "0", input: $outputN)
                                 
                    LumiHeaderTexField(header: BitcoinTransactionText.Input.scriptTitle, input: $script, placeholder: BitcoinTransactionText.Input.scriptPlaceholder)
                                  
                    LumiHeaderTexField(header: BitcoinTransactionText.Input.transactionHashTitle, input: $hash, placeholder: BitcoinTransactionText.Input.transactionHashPlaceholder)
                       
                    LumiHeaderTexField(header: BitcoinTransactionText.Input.privateKeyTitle, input: $wifPrivateKey, placeholder: BitcoinTransactionText.Input.privateKeyPlaceholder)
                })

            }.padding(.top, 20)

            Spacer()
            
            Button(action: {
                self.actionAddInputButton()
            }, label: {
                HStack {
                    Spacer()
                    Text(BitcoinTransactionText.addInputButton)
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
        .navigationBarTitle("\(NavigationBarTitleText.bitcoinAddInput)", displayMode: .inline)
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
        .onReceive(inputState) { output in
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
    
    func actionAddInputButton() {
        switch type {
        case .bitcoin:
            self.store.send(action: .txBitcoin(.addInput(transactionInputInfo)))
        case .bitcoinCash:
            self.store.send(action: .txBitcoinCash(.addInput(transactionInputInfo)))
        default:
            ()
        }
    }
}

