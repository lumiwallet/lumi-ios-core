//
//  Store.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Combine
import Foundation


public final class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State
    
    private let reducer: Reducer<State, Action>
    private var cancelables: Set<AnyCancellable> = []
    
    init(state: State, reducer: Reducer<State, Action>) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(action: Action) {
        reducer.reduce(state, action).receive(on: DispatchQueue.main).sink(receiveValue: perform).store(in: &cancelables)
    }
    
    func perform(change: Reducer<State, Action>.Change) {
        change(&state)
    }
}
