//
//  TextViewContainer.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import SwiftUI


struct TextViewContainer: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding
    var text: String
    
    public final class Coordinator: NSObject, UITextViewDelegate {
        private let parent: TextViewContainer
        
        public init(_ parent: TextViewContainer) {
            self.parent = parent
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        public func textViewDidBeginEditing(_: UITextView) {
            
        }
        
        public func textViewDidEndEditing(_: UITextView) {
            
        }
    }
    
    func makeCoordinator() -> TextViewContainer.Coordinator {
        .init(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<TextViewContainer>) -> UITextView {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        view.isScrollEnabled = true
        view.isEditable = true
        view.dataDetectorTypes = .all
        view.isSelectable = true
        view.font = UIFont(name: LumiFonts.popinsLight, size: 22)
        view.delegate = context.coordinator
        view.textAlignment = .left
        view.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        view.autocorrectionType = .no
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextViewContainer>) {
        uiView.text = self.text
    }
}
