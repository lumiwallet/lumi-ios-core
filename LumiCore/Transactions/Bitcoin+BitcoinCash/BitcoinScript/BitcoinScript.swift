//
//  BitcoinScript.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for representing and performing operations with scripts for bitcoin
public class BitcoinScript {
    
    public enum ScriptType {
        case P2PKH
        case P2PK
        case P2SH
        case P2WPKH
        case P2WSH
        case none
    }
    
    public var data: Data
    public var elements: [BitcoinScriptElement]
    
    public var multisigSignaturesRequired: Int = 0
    public var multisigPublicKeysData: [Data] = []
    
    public var type: ScriptType {
        if isPayToPublicKeyHashScript() { return .P2PKH }
        if isPayToPublicKeyScript() { return .P2PK }
        if isPayToScripHashScript() { return .P2SH }
        if isPayToWitnessPublicKeyHash() { return .P2WPKH }
        if isPayToWitnessScriptHash() { return .P2WSH }
        return .none
    }
    
    /// Init
    public init() {
        data = Data()
        elements = []
    }
    
    /// Initializing a script from a set of bytes
    /// - Parameter data: Script data (set of bytes)
    public init(data: Data) throws {
        self.data = data
        let parts = try BitcoinScript.parse(data: data)
        elements = parts
    }
    
    /// Initializing a script with a bitcoin public key address
    /// - Parameter address: Object BitcoinPublicKeyAddress
    public convenience init(address: BitcoinPublicKeyAddress) {
        self.init()
        
        switch address.hashType.typeValue {
        case .P2PKH:
            self.add(opcode: OPCode.OP_DUP)
            self.add(opcode: OPCode.OP_HASH160)
            self.addScript(from: address.publicKeyHash)
            self.add(opcode: OPCode.OP_EQUALVERIFY)
            self.add(opcode: OPCode.OP_CHECKSIG)
        case .P2SH:
            self.add(opcode: OPCode.OP_HASH160)
            self.addScript(from: address.publicKeyHash)
            self.add(opcode: OPCode.OP_EQUAL)
        case .P2WPKH:
            self.add(opcode: OPCode.OP_0)
            self.addScript(from: address.publicKeyHash)
        case .P2WSH:
            self.add(opcode: OPCode.OP_0)
            self.addScript(from: address.publicKeyHash)
        }
        

    }
    
    /// Adds a script for the bitcoin public key address with the corresponding OPCode values
    /// - Parameter address: Object BitcoinPublicKeyAddress
    public func addScript(from address: BitcoinPublicKeyAddress) {
        let script = BitcoinScript()
        
        switch address.hashType.typeValue {
        case .P2PKH:
            script.add(opcode: OPCode.OP_DUP)
            script.add(opcode: OPCode.OP_HASH160)
            script.addScript(from: address.publicKeyHash.dropFirst())
            script.add(opcode: OPCode.OP_EQUALVERIFY)
            script.add(opcode: OPCode.OP_CHECKSIG)
        case .P2SH:
            script.add(opcode: OPCode.OP_HASH160)
            script.addScript(from: address.publicKeyHash.dropFirst())
            script.add(opcode: OPCode.OP_EQUAL)
        case .P2WPKH:
            self.add(opcode: OPCode.OP_0)
            self.addScript(from: address.publicKeyHash)
        case .P2WSH:
            self.add(opcode: OPCode.OP_0)
            self.addScript(from: address.publicKeyHash)
        }
        
        self.data.append(script.data)
        self.elements.append(contentsOf: script.elements)
    }
    
    /// Adds OPCode value to the script
    /// - Parameter opcode: OPCode
    public func add(opcode: OPCode) {
        self.data.append(opcode.value)
        self.elements.append(BitcoinScriptElement(opcode: opcode.value, data: opcode.value.data))
    }
    
    /// Adds a script to a set of bytes with the corresponding OPCode values
    /// - Parameter data: Data for script
    public func addScript(from data: Data) {
        var pushData = Data()
        
        switch UInt32(data.count) {
        case 0x00..<0x4c:
            let length = UInt8(data.count & 0xff)
            pushData.append(length.data)
            pushData.append(data)
            
        case 0x4c...0xff:
            let length = UInt8(data.count & 0xff)
            pushData.append(OPCode.OP_PUSHDATA1.value)
            pushData.append(length.data)
            pushData.append(data)
            
        case 0xff...0xffff:
            let length = UInt16(data.count & 0xffff)
            pushData.append(OPCode.OP_PUSHDATA2.value)
            pushData.append(length.data)
            pushData.append(data)
            
        case 0xffff...0xffffffff:
            let length = UInt32(data.count) & (0xffffffff as UInt32)
            pushData.append(OPCode.OP_PUSHDATA4.value)
            pushData.append(length.data)
            pushData.append(data)
            
        default:
            ()
        }
        
        guard let newElements = try? BitcoinScript.parse(data: pushData) else {
            return
        }
        
        self.data.append(pushData)
        self.elements.append(contentsOf: newElements)
    }
    
    public func isStandart() -> Bool {
        return isPayToPublicKeyHashScript() ||
               isPayToScripHashScript() ||
               isPayToPublicKeyScript() ||
               (isMultisigScript() && multisigSignaturesRequired <= 3)
    }
    
    public func isPayToPublicKeyScript() -> Bool {
        if elements.count != 2 { return false }
        return elements[0].OpCode == .OP_UNKNOWN
    }
    
    public func isPayToPublicKeyHashScript() -> Bool {
        if elements.count != 5 { return false }
        
        return elements[0].OpCode == .OP_DUP &&
        elements[1].OpCode == .OP_HASH160 &&
        elements[2].OpCode == .OP_UNKNOWN &&
        elements[2].data.count == 20 &&
        elements[3].OpCode == .OP_EQUALVERIFY &&
        elements[4].OpCode == .OP_CHECKSIG
    }
    
    public func isPayToScripHashScript() -> Bool {
        if elements.count != 3 { return false }
        
        return elements[0].OpCode == .OP_HASH160 &&
        elements[1].opcodeValue == 0x14 &&
        elements[2].OpCode == .OP_EQUAL &&
        elements[1].data.count == 20
    }
    
    public func isPayToWitnessPublicKeyHash() -> Bool {
        if !isPayToWitnessScriptHash() { return false }
        if elements.count != 2 { return false }
        return elements[0].OpCode == .OP_0 &&
        elements[1].opcodeValue == 0x14 &&
        elements[1].data.count == 0x14
    }
    
    public func isPayToWitnessScriptHash() -> Bool {
        if elements.count != 2 { return false }
        return elements[0].OpCode == .OP_0 &&
        (elements[1].data.count == 0x20 || elements[1].opcodeValue == 0x14)
    }
    
    public func isWitnessProgram() -> Bool {
        if data.count < 4 || data.count > 42 || data.count != (elements[1].opcodeValue + 2) { return false }
        if elements[0].OpCode != .OP_0 &&
        (elements[0].opcodeValue < OPCode.OP_1.value || elements[0].opcodeValue > OPCode.OP_16.value) { return false }
        
        return true
    }
    
    static func parse(data: Data) throws -> [BitcoinScriptElement] {
        var subscripts: [BitcoinScriptElement] = []
        
        var i = 0
        var range: Range<Int>
        
        while i < data.count {
            let opcode = OPCode(value: data[i])
            
            switch opcode {
            case .OP_PUSHDATA1:
                range = (i+1)..<(i + Int(opcode.value))
                
            case .OP_PUSHDATA2:
                var end = 0
                end = Int( data[i + 1] ) & 0xff
                end |= (Int( data[i + 2] ) & 0xff ) << 8
                
                range = (i+2)..<end
                
            case .OP_PUSHDATA4:
                var end = 0
                end = Int( data[i+1] ) << 24
                end |= (Int( data[i+2] ) & 0xff) << 16
                end |= (Int( data[i+3] ) & 0xff) << 8
                end |= (Int( data[i+4] ) & 0xff)
                
                range = (i+4)..<end
                
            default:
                let value = data[i]
                
                if value < OPCode.OP_PUSHDATA4.value &&
                   value < OPCode.OP_PUSHDATA1.value {
                    range = (i+1)..<(i + 1 + Int(value))
                } else {
                    range = (i + 1)..<(i + 1)
                }
            }
            
            if range.upperBound > data.count { throw BitcoinScriptError.errorParseData }
            
            subscripts.append(BitcoinScriptElement(opcode: data[i], data: data.subdata(in: range)))
            i = range.upperBound
        }
        
        return subscripts
    }
    
    public func isMultisigScript() -> Bool {
        if elements.count < 4 { return false }
        if elements.last?.OpCode != OPCode.OP_CHECKMULTISIG { return false }
        
        let multisigCount = Int(elements.first!.opcodeValue)
        let keysCount = Int(elements[elements.endIndex - 1].opcodeValue)
        
        if keysCount < multisigCount { return false }
        var publicKeysData: [Data] = []
        for i in 1...keysCount {
            publicKeysData.append(elements[i].data)
        }
        multisigPublicKeysData = publicKeysData
        multisigSignaturesRequired = multisigCount
        return true
    }
    
    public func script(without: OPCode) -> BitcoinScript {
        var scriptData = Data()
        for element in elements {
            if element.OpCode != without {
                let subscriptData = element.opcodeValue.data + element.data
                scriptData += subscriptData
            }
        }
        
        guard let result = try? BitcoinScript(data: scriptData) else {
            return BitcoinScript()
        }

        return result
    }
    
    public func getPublicKeyHash() throws -> Data {
        switch type {
        case .P2PKH:
            return elements[2].data
        case .P2PK:
            return elements[0].data.ripemd160sha256()
        case .P2SH:
            return elements[1].data
        case .P2WPKH:
            return elements[1].data
        case .P2WSH:
            return elements[1].data
        case .none:
            throw BitcoinCreateAddressError.invalidHashDataLength
        }
    }
}


// MARK: - CustomStringConvertible

extension BitcoinScript: CustomStringConvertible {
    
    public var description: String {
        return elements.map({ $0.description }).joined(separator: " ")
    }
}
