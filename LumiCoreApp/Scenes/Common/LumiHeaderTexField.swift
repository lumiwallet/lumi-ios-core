//
//  LumiHeaderTexField.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct LumiHeaderTexField: View {
    
    let header: String
    @Binding var input: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
          Text(header)
            .lumiTextStyle(.title)
          
          HStack {
              TextField(placeholder, text: $input)
                .lumiTextStyle(.title)
                .disableAutocorrection(true)
          }
        }
        .underlined()
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}
