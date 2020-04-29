//
//  BitcoinScriptElement.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for displaying and working with script components
public class BitcoinScriptElement {
    public let opcodeValue: UInt8
    public let data: Data
    
    /// Initialization from the OPCode value and the data in the script
    /// - Parameter opcode: OPCode  value
    /// - Parameter data: Data
    public init(opcode: UInt8, data: Data) {
        self.opcodeValue = opcode
        self.data = data
    }
    
    public var OpCode: OPCode {
        OPCode(value: opcodeValue)
    }
    
    func isCompact() -> Bool {
        if OpCode != .OP_UNKNOWN { return false }
        if opcodeValue < OPCode.OP_PUSHDATA1.value { return true }
        if opcodeValue == OPCode.OP_PUSHDATA1.value { return data.count >= OPCode.OP_PUSHDATA1.value }
        if opcodeValue == OPCode.OP_PUSHDATA2.value { return data.count >= 0xff }
        if opcodeValue == OPCode.OP_PUSHDATA4.value { return data.count >= 0xffff }
        return false
    }
}


// MARK: - CustomStringConvertible

extension BitcoinScriptElement: CustomStringConvertible {
    
    public var description: String {
        var string = ""
        switch OpCode {
        case .OP_UNKNOWN:
            if data.count == 0 {
                string = OPCode.OP_0.additionalDescription
            } else {
                string = data.hex
                if data.count < 16 { string = "\(string)" }
            }
        default:
            return OpCode.description
        }
        
        if !isCompact() {
            switch OpCode {
            case .OP_PUSHDATA2: string = "2:\(string)"
            case .OP_PUSHDATA4: string = "4:\(string)"
            default: string = "1:\(string)"
            }
        }
        
        return string
    }
}
