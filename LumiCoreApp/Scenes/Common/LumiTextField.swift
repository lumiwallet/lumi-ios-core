//
//  LumiTextField.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct LumiTextField: View {
    
    let title: String
    let endTitle: String
    let placeholder: String
    
    @Binding var input: String
    
    var body: some View {
        HStack {
            Text(title)
                .lumiTextStyle(.title)
            
            Spacer()
            
            TextField(placeholder, text: $input)
                .keyboardType(.numberPad)
                .lumiTextStyle(.listItem)
                .disableAutocorrection(true)
            
            if !endTitle.isEmpty {
                Text(endTitle)
                    .lumiTextStyle(.listItem)
            }
          }
          .underlined()
         .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        
    }
}
