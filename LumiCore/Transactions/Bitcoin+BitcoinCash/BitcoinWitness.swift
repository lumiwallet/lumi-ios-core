//
//  BitcoinWitness.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public class BitcoinWitness: CustomStringConvertible {
    public struct WitnessRecord: CustomStringConvertible {
        public let components: [Data]
        
        public init(components: [Data]) {
            self.components = components
        }
        
        public var data: Data {
            if components.count == 1 && components[0] == Data(count: 1) {
                return components[0]
            }
            
            var payload = VarInt(value: components.count).data
            for component in components {
                payload += VarInt(value: component.count).data + component
            }
            return payload
        }
        
        public var componentsLength: Int {
            components.map({ $0.count }).reduce(0, +)
        }
        
        public var dataLength: Int {
            data.count
        }
        
        public var description: String {
            var string = "BITCOIN_WITNESS_RECORD \n"
            for (index, component) in components.enumerated() {
                string += "Component\(index): \(component.hex) \n"
            }
            string += "Serialized: \(data.hex)"
            return string
        }
    }
    
    public var records: [WitnessRecord] = []
    
    public func add(witness: WitnessRecord) {
        records.append(witness)
    }
    
    public func add(components: [Data]) {
        add(witness: WitnessRecord(components: components))
    }
    
    public var data: Data {
        records.map({ $0.data }).reduce(Data(), +)
    }
    
    public var length: Int {
        data.count
    }
    
    public var description: String {
        if records.isEmpty {
            return ""
        }
        
        return "BITCOIN_WITNESS" + "\n" + records.map({ $0.description }).joined(separator: "\n")
    }
}
