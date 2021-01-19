//
//  Bitcoin+BitcoinCashTransactionState.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore


public struct TransactionOutputInfo {
    var address: String
    var value: String
}


public struct TransactionInputInfo {
    var address: String
    var value: String
    var n: String
    var script: String
    var hash: String
    var wifPrivateKey: String
}


public struct BitcoinTransactionResult {
    var hash: String
    var raw: String
    var description: String
}

public class BitcoinTransactionState {
    
    public struct InputInfo: Hashable {
        public let address: String
        public let value: String
        public let script: String
        public let hash: String
        public let wifPrivateKey: String
    }
    
    public struct OutputInfo: Hashable {
        public let address: String
        public let value: String
    }
    
    public var _inputs: [BitcoinUnspentOutput] = []
    public var _outputs: [BitcoinTransactionOutput] = []
    
    public var privateKeys: [Key] = []
    
    @Published var transactionResultInfo: BitcoinTransactionResult?
    
    @Published var inputCreated: Bool?
    @Published var outputCreated: Bool?
    @Published var errorMessage: String?
    
    var inputs: [InputInfo] {
        var info: [InputInfo] = []
        for (index, input) in _inputs.enumerated() {
            
            let wif = (try? BitcoinPrivateKeyAddress(key: privateKeys[index]).wif) ?? ""
            let input = InputInfo(address: input.address, value: "\(input.value)", script: input.script.description, hash: input.transactionHash.hex, wifPrivateKey: wif)
            info.append(input)
        }
        return info
    }
    
    var outputs: [OutputInfo] {
        _outputs.map({ OutputInfo(address: (try? BitcoinPublicKeyAddress(data: $0.script.getPublicKeyHash()))?.address ?? "", value: "\($0.value)") })
    }
    
    
    func addUnspentOutput(info: TransactionInputInfo) {
        inputCreated = nil
        errorMessage = nil
          
        guard let value = UInt64(info.value, radix: 10) else {
            errorMessage = BitcoinErrorDescription.amountValueError
            return
        }
        guard let outN = UInt32(info.n, radix: 10) else {
            errorMessage = BitcoinErrorDescription.outputNumberValueError
            return
        }
        
        let script = Data(hex: info.script)
        let hash = Data(hex: info.hash)
        
        do {
            let unspent = try BitcoinUnspentOutput(address: info.address, value: value, outputN: outN, scriptData: script, hashData: hash)
            
            let privateKeyAddrses = try BitcoinPrivateKeyAddress(wif: info.wifPrivateKey)
            let key = Key(privateKey: privateKeyAddrses.data)
            
            _inputs.append(unspent)
            privateKeys.append(key)
            
            inputCreated = true
        } catch {
            self.errorMessage = BitcoinErrorDescription.createInputError
        }
    }
    
    func addOutput(info: TransactionOutputInfo) {
        outputCreated = nil
        errorMessage = nil
        
        guard let value = UInt64(info.value, radix: 10) else {
            errorMessage = BitcoinErrorDescription.amountValueError
            return
        }
        
        do {
            let addr = try BitcoinPublicKeyAddress(string: info.address)
            let out = BitcoinTransactionOutput(amount: value, address: addr)
            
            _outputs.append(out)
            
            outputCreated = true
        } catch {
            self.errorMessage = BitcoinErrorDescription.outputAddressError
        }
    }
    
    func build() {
        errorMessage = nil
        
        do {
            let txOutputs: [BitcoinTransactionOutput] = try _outputs.map({
                let address = try BitcoinPublicKeyAddress(data: $0.script.getPublicKeyHash())
                return BitcoinTransactionOutput(amount: $0.value, address: address)
            })
            
            let txInputs: [BitcoinTransactionInput] = _inputs.map({
                BitcoinTransactionInput(hash: $0.transactionHash,
                                        id: Data($0.transactionHash.reversed()).hex,
                                        index: Int($0.outputN),
                                        value: UInt64($0.value),
                                        script: $0.script)
            })
            
            let transaction = BitcoinTransaction(inputs: txInputs, outputs: txOutputs, settings: .bitcoinWitnessDefaults)
            let signedTransaction = try transaction.sign(keys: privateKeys)
            
            self.transactionResultInfo = BitcoinTransactionResult(hash: signedTransaction.transactionHash.hex,
                                                                  raw: signedTransaction.payload.hex,
                                                                  description: signedTransaction.description)
            
        } catch let e as BitcoinCreateAddressError {
            self.errorMessage = description(from: e)
        } catch let e as BitcoinCreateTransactionError {
            self.errorMessage = description(from: e)
        } catch {
            self.errorMessage = BitcoinErrorDescription.unknownError
        }
        
    }
    
    public func description(from error: BitcoinCreateAddressError) -> String {
        switch error {
        case .invalidAddressVersion:
            return BitcoinErrorDescription.bitcoinAddressVersionError
        case .invalidDataLength:
            return BitcoinErrorDescription.bitcoinAddressDataLengthError
        case .invalidHashDataLength:
            return BitcoinErrorDescription.bitcoinAddressHashLengthError
        case .invalidKeyType:
            return BitcoinErrorDescription.keyTypeError
        case .invalidWIFAddressVersion:
            return BitcoinErrorDescription.bitcoinWIFAddressVersionError
        case .invalidWIFAddressLength:
            return BitcoinErrorDescription.bitcoinWIFAddressLengthError
        }
    }
    
    public func description(from error: BitcoinCreateTransactionError) -> String {
        switch error {
        case .privateKeyNotFound:
            return BitcoinErrorDescription.createTransactionPrivateKeyError
        case .wrongSignature:
            return BitcoinErrorDescription.createTransactionSigningError
        }
    }
}

class BitcoinCashTransactionState: BitcoinTransactionState {
    
    override func build() {
        errorMessage = nil
        
        do {
            let txOutputs: [BitcoinTransactionOutput] = try _outputs.map({
                let address = try BitcoinPublicKeyAddress(data: $0.script.getPublicKeyHash())
                return BitcoinTransactionOutput(amount: $0.value, address: address)
            })

            let txInputs: [BitcoinTransactionInput] = _inputs.map({
                BitcoinTransactionInput(hash: $0.transactionHash,
                                        id: Data($0.transactionHash.reversed()).hex,
                                        index: Int($0.outputN),
                                        value: UInt64($0.value),
                                        script: $0.script)
            })

            let transaction = BitcoinCashTransaction(inputs: txInputs, outputs: txOutputs)
            let signedTransaction = try transaction.sign(keys: privateKeys)

            self.transactionResultInfo = BitcoinTransactionResult(hash: signedTransaction.transactionHash.hex,
                                                                  raw: signedTransaction.payload.hex,
                                                                  description: signedTransaction.description)

        } catch let e as BitcoinCreateAddressError {
            self.errorMessage = description(from: e)
        } catch let e as BitcoinCreateTransactionError {
            self.errorMessage = description(from: e)
        } catch {
            self.errorMessage = BitcoinErrorDescription.unknownError
        }
    }
}
