//
//  KeyboardResponder.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


class KeyboardResponder: ObservableObject {
    
    @Published var height: CGFloat = 0
    
    var _center: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        _center = center
        
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
               height = keyboardSize.height
            }
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation {
           height = 0
        }
    }
}
