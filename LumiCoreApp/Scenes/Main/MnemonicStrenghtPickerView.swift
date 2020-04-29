//
//  MnemonicStrenghtPickerView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI

struct MnemonicStrenghtPickerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    
    @State var selected: Int = 0
    @Binding var isPresent: Bool
    
    var body: some View {
            VStack {
                Text(MnemonicPickerViewText.title)
                    .lumiTextStyle(.header)
                    .padding()
                
                Picker(selection: $selected, label: Text("")) {
                    ForEach(0..<MnemonicStrenghtList.values.count) { index in
                        Text("\(MnemonicStrenghtList.values[index].rawValue)")
                    }
                }
                .labelsHidden()
                
                Button(action: {
                    self.isPresent = false
                    self.store.send(action: .mnemonic(.createWithStrenght(self.selected)))
                }, label: {
                    HStack {
                        Spacer()
                        Text(MnemonicPickerViewText.buttonText)
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
                                        bottom: 20 + (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0),
                                        trailing: 20))
            }
            .background(Color.white)
            .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
            .zIndex(.infinity)
    }
}
