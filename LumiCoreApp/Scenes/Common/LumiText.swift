//
//  LumiText.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct LumiText: View {
    
    private let string: String
    
    @State var tapped: Bool = false
    
    init(_ string: String) {
        self.string = string
    }
    
    var body: some View {
        Text(self.string)
            .fixedSize(horizontal: false, vertical: true)
        .onTapGesture {
            UIPasteboard.general.string = self.string
            withAnimation {
                self.tapped.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tapped.toggle()
            }
        }
        .overlay(
            Text("Copied")
            .frame(width: 90, height: 30)
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(radius: 5, corners: .allCorners)
            .offset(x: 0, y: -5)
            .opacity( self.tapped ? 1 : 0 )
                .animation(.easeIn(duration: 0.2))
        )
    }
}
