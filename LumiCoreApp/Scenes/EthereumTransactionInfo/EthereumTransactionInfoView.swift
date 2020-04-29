//
//  EthereumTransactionInfoView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct EthereumTransactionInfoView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var address: String = ""
    
    @State private var amount: String = ""
    
    @State private var gasPrice: String = ""
    
    @State private var gasLimit: String = ""
    
    @State private var nonce: String = ""
    
    @State private var chain: String = ""
    
    @State private var data: String = ""
    
    @State private var privateKeyData: String = ""
    
    @State var alertShow = false
    @State var transactionResultShow = false
    
    var bottomButtonPadding: CGFloat {
        if keyboard.height > 0 {
            return (10 - (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0)) + keyboard.height
        } else {
            return (20 + (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0)) + keyboard.height
        }
    }
    
    var errorState: Published<String?>.Publisher {
        store.state.ethTransactionState.$errorMessage
    }
    
    var errorText: String {
        store.state.ethTransactionState.errorMessage ?? ""
    }
    
    var transactionInfo: EthereumTransactionInfo {
        EthereumTransactionInfo(address: self.address,
                                amount: self.amount,
                                gasPrice: self.gasPrice,
                                gasLimit: self.gasLimit,
                                nonce: self.nonce,
                                chain: self.chain,
                                data: self.data,
                                privateKeyData: self.privateKeyData)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22, content: {
                    
                    LumiHeaderTexField(header: EthereumTransactionText.addressTitle, input: $address, placeholder: EthereumTransactionText.addressPlaceholder)
                    
                    LumiTextField(title: EthereumTransactionText.amountTitle, endTitle: "WEI", placeholder: "0", input: $amount)
              
                    LumiTextField(title: EthereumTransactionText.gasPriceTitle, endTitle: "WEI", placeholder: "0", input: $gasPrice)
                                      
                    LumiTextField(title: EthereumTransactionText.gasLimitTitle, endTitle: "WEI", placeholder: "0", input: $gasLimit)
                                  
                    LumiTextField(title: EthereumTransactionText.nonceTitle, endTitle: "", placeholder: "0", input: $nonce)
                               
                    LumiTextField(title: EthereumTransactionText.chainTitle, endTitle: "", placeholder: "0", input: $chain)
                    
                    LumiHeaderTexField(header: EthereumTransactionText.dataTitle, input: $data, placeholder: EthereumTransactionText.dataPlaceholder)
                                  
                    LumiHeaderTexField(header: EthereumTransactionText.privateKeyTitle, input: $privateKeyData, placeholder: EthereumTransactionText.privateKeyPlaceholder)
                })
            }
            .padding(.top, 20)

            Spacer()
            
            Button(action: {
                self.actionBuild()
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
                                bottom: bottomButtonPadding,
                                trailing: 20))
        }
        .navigationBarTitle("\(NavigationBarTitleText.ethereumTransactionInfo)", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.store.send(action: .txEthereum(.clear))
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
                self.store.send(action: .txEthereum(.resetError))
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
        .onReceive(store.state.ethTransactionState.$transactionResultInfo) { output in
            guard let _ = output else {
                return
            }
            self.transactionResultShow = true
        }
        .sheet(isPresented: $transactionResultShow) { 
            EthereumTransactionResultView().environmentObject(self.store)
        }
        .onDisappear {
            self.store.send(action: .txEthereum(.clear))
        }
    }
    
    
    func actionBuild() {
        store.send(action: .txEthereum(.build(info: transactionInfo)))
    }
}
