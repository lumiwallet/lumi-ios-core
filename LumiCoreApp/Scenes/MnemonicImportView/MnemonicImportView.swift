//
//  MnemonicImportView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct MnemonicImportView: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @EnvironmentObject var store: Store<AppState, AppAction>

    @Binding var show: Bool
    
    @State var input: String = ""
    
    @State var importButtomPressed = false
    
    var bottomButtonPadding: CGFloat {
        if keyboard.height > 0 {
            return (10 - (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0)) + keyboard.height
        } else {
            return 10 + (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0) + keyboard.height
        }
    }
    
    var body: some View {
        VStack {
            
            Text(MnemonicInputPhraseViewText.title)
                .lumiTextStyle(.header)
                .padding([.top, .bottom], 20)
            
            TextViewContainer(text: $input)
                .padding()
              
            Button(action: {
                self.importButtomPressed = true
                self.show = false
            }, label: {
                HStack {
                    Spacer()
                    Text(MnemonicInputPhraseViewText.buttonTitle)
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
            
        }.onDisappear {
            guard self.importButtomPressed else {
                return
            }
            self.store.send(action: .mnemonic(.createWithPhrase(self.input)))
        }
    }
}
