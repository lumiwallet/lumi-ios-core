//
//  ViewExtensitons.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


extension View {
    func pickerBottomSheet<SheetContent: View>(isPresented: Binding<Bool>, sheetContent: @escaping () -> SheetContent) -> some View {
        self.modifier(PickerSheetModificator(isPresent: isPresented, sheetContent: sheetContent))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        self.modifier(CornerRadiusModifier(radius: radius, corners: corners))
    }
}

extension View {
    func underlined() -> some View {
        self.modifier(UnderlineViewModificator())
    }
}

extension View {
    func lumiBorder() -> some View {
        self.modifier(BorderButtonModificator())
    }
}
