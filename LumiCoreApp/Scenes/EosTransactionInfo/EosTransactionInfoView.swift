//
//  EosTransactionInfoView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI

struct EosTransactionInfoView: View {

    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var address = ""

    @State var amount = ""
    
    @State var memo = ""

    @State var bin = ""

    @State var actor = ""

    @State var permission = ""

    @State var expiration = ""

    @State var chainID = ""

    @State var referenceBlockNum = ""
    
    @State var referenceBlockPrefix = ""

    @State var wifPrivateKey: String = ""
    
    @State var transactionResultShow = false
    @State var alertShow = false
    
    var bottomButtonPadding: CGFloat {
        if keyboard.height > 0 {
            return (10 - (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0)) + keyboard.height
        } else {
            return 20 + (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0) + keyboard.height
        }
    }
    
    var errorState: Published<String?>.Publisher {
        store.state.eosTransactionState.$errorMessage
    }
    
    var errorText: String {
        store.state.eosTransactionState.errorMessage ?? ""
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22, content: {
                    Group {
                        LumiHeaderTexField(header: EosTransactionText.addressTitle, input: $address, placeholder: EosTransactionText.addressPlaceholder)

                        LumiHeaderTexField(header: EosTransactionText.amountTitle, input: $amount, placeholder: EosTransactionText.amountPlaceholder)

                        LumiHeaderTexField(header: EosTransactionText.memoTitle, input: $memo, placeholder: EosTransactionText.memoPlaceholder)
                    }
                    Group {
                        LumiHeaderTexField(header: EosTransactionText.actorTitle, input: $actor, placeholder: EosTransactionText.actorPlaceholder)

                        LumiHeaderTexField(header: EosTransactionText.permissionTitle, input: $permission, placeholder: EosTransactionText.permissionPlaceholder)
                    }

                    LumiHeaderTexField(header: EosTransactionText.expirationTitle, input: $expiration, placeholder: EosTransactionText.expirationPlaceholder)

                    Group {
                        LumiHeaderTexField(header: EosTransactionText.binTitle, input: $bin, placeholder: EosTransactionText.binPlaceholder)
                        
                        LumiHeaderTexField(header: EosTransactionText.referenceBlockPrefixTitle, input: $referenceBlockPrefix, placeholder: EosTransactionText.referenceBlockPrefixPlaceholder)

                        LumiHeaderTexField(header: EosTransactionText.referenceBlockNumTitle, input: $referenceBlockNum, placeholder: EosTransactionText.referenceBlockNumPlaceholder)
                        
                        LumiHeaderTexField(header: EosTransactionText.chainTitle, input: $chainID, placeholder: EosTransactionText.chainPlaceholder)
                    }
                    
                    LumiHeaderTexField(header: EosTransactionText.privateKeyTitle, input: $wifPrivateKey, placeholder: EosTransactionText.privateKeyPlaceholder)
                    
                })
            }.padding([.top, .bottom], 20)
            
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
        .navigationBarTitle("\(NavigationBarTitleText.eosTransactionInfo)", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.store.send(action: .txEos(.clear))
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
                self.store.send(action: .txEos(.resetError))
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
        .onReceive(store.state.eosTransactionState.$transactionResultInfo ) { output in
            guard let _ = output else {
                return
            }
            self.transactionResultShow = true
        }
        .sheet(isPresented: $transactionResultShow) {
            EosTransactionResultView().environmentObject(self.store)
        }
        .onDisappear {
            self.store.send(action: .txEos(.clear))
        }
    }
    
    
    func actionBuild() {
        store.send(action: .txEos(.build(info: self.transactionInfo)))
    }
    
    var transactionInfo: EosTransactionInfo {
        EosTransactionInfo(address: self.address,
                           amount: self.amount,
                           memo: self.memo,
                           bin: self.bin,
                           actor: self.actor,
                           permission: self.permission,
                           expiration: self.expiration,
                           chain: self.chainID,
                           referenceBlockNum: self.referenceBlockNum,
                           referenceBlockPrefix: self.referenceBlockPrefix,
                           wifPrivateKey: self.wifPrivateKey)
    }

}




