//
//  Modificators.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct SeparationLineModificator: ViewModifier {
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0, content: {
            content
                .frame(height: 47.5)
            GeometryReader { geometry in
                Rectangle()
                    .background(Color.black)
                    .opacity(0.15)
                    .frame(width: geometry.size.width - 32, height: 0.5, alignment: .bottom)
            }
        })
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .frame(height: 48)
    }
}


struct UnderlineViewModificator: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Rectangle()
                    .frame(width: geometry.size.width, height: 0.5, alignment: .top)
                    .background(Color.black)
                    .opacity(0.15)
                }
            }
        }
    }
}


struct BorderButtonModificator: ViewModifier {
        func body(content: Content) -> some View {
        VStack {
            content
            .border(Color.black.opacity(0.15), width: 1)
            .cornerRadius(2)
        }
    }
}


struct TextModifier: ViewModifier {
    
    enum TextStyle {
        case title
        case listItem
        case header
        case infoPrefix
        case infoBody
        case aboutHeader
        case aboutBody
        
        var font: Font {
            switch self {
            case .title: return .custom(LumiFonts.popinsSemibold, size: 14)
            case .listItem: return .custom(LumiFonts.popinsLight, size: 14)
            case .header: return .custom(LumiFonts.popinsSemibold, size: 17)
            case .infoPrefix: return .custom(LumiFonts.popinsLight, size: 12)
            case .infoBody: return .custom(LumiFonts.popinsLight, size: 12)
            case .aboutHeader: return .custom(LumiFonts.popinsLight, size: 14)
            case .aboutBody: return .custom(LumiFonts.popinsLight, size: 14)
            }
        }
        
        var color: Color {
            switch self {
            case .title: return .black
            case .listItem: return .black
            case .header: return .black
            case .infoPrefix: return .gray
            case .infoBody: return .black
            case .aboutHeader: return .gray
            case .aboutBody: return .black
            }
        }
    }
    
    let style: TextStyle
    
    init(_ style: TextStyle) {
        self.style = style
    }
    
    func body(content: Content) -> some View {
        content
        .font(style.font)
        .foregroundColor(style.color)
    }
}


struct TextCopyModifier: ViewModifier {
    
    let text: String
    
    func body(content: Content) -> some View {
        ZStack {
            GeometryReader { geo in
                Text("Copied")
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(Color.black)
                content.onTapGesture {
                    UIPasteboard.general.string = self.text
                }
            }
        }
    }
}


struct ButtonInsetsModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .listRowInsets(MainView.mainMenuListRowInsets)
            .frame(height: MainView.mainMenuRowHeight)
    }
}


struct PickerSheetModificator<SheetContent: View>: ViewModifier {
    
    @Binding var isPresent: Bool
    
    let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresent {
                Rectangle()
                    .background(Color.black)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            self.isPresent = false
                        }
                    }
                
                VStack {
                    Spacer()
                    sheetContent()
                }
                .edgesIgnoringSafeArea(.all)
                .transition(.move(edge: .bottom))
            } 
        }
    }
}


struct CornerRadiusModifier: ViewModifier {
    
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct RoundedCornerShape: Shape {
        
        var radius: CGFloat
        var corners: UIRectCorner
        
        func path(in rect: CGRect) -> Path {
            Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}
