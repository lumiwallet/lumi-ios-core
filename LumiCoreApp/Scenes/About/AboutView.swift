//
//  AboutView.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                Image(ImageName.logoAboutScreen)
                    .frame(width: 84)

                VStack(alignment: .leading) {
                    Text(AboutText.lumiWalletTitle)
                        .lumiTextStyle(.title)
                    Text(AboutText.openSourceAppTitle)
                        .lumiTextStyle(.title)
                }
                .padding(.top, 5)
                .padding(.leading, 24)
                
                Spacer()
            }
            .padding([.top, .leading], 24)
            
            Group {
                Text(AboutText.aboutAppTitle)
                    .lumiTextStyle(.aboutHeader)
                    .padding(EdgeInsets(top: 24, leading: 24, bottom: 8, trailing: 24))
                LumiText(AboutText.aboutAppBodyText)
                    .lumiTextStyle(.aboutBody)
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 24))
            }
            
            Group {
                Text(AboutText.websiteTitle)
                    .lumiTextStyle(.aboutHeader)
                    .padding(EdgeInsets(top: 24, leading: 24, bottom: 8, trailing: 24))
                Button(action: {
                    
                    guard let url = URL(string: AboutText.websiteLink) else {
                        return
                    }
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }) {
                    Text(AboutText.websiteButton)
                    .lumiTextStyle(.aboutBody)
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 24))
                }
            }
            
            Group {
                Text(AboutText.mailTitle)
                    .lumiTextStyle(.aboutHeader)
                    .padding(EdgeInsets(top: 24, leading: 24, bottom: 8, trailing: 24))
                Button(action: {
                    
                    guard let url = URL(string: AboutText.mailLink) else {
                        return
                    }
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }) {
                    Text(AboutText.mailButton)
                    .lumiTextStyle(.aboutBody)
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 24))
                }
                
            }
            
            Spacer()
            
            Text(AboutText.copyright)
                .lumiTextStyle(.infoPrefix)
                .padding(.leading, 24)
                .padding(.bottom, (UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.bottom ?? 0) + 20)
        }
        .navigationBarTitle("\(NavigationBarTitleText.about)", displayMode: .inline)
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
    }
}
