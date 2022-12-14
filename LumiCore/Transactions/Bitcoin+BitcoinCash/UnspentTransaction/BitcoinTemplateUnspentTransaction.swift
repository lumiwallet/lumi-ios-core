//
//  BitcoinTemplateUnspentTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// An object for forming template source data required for building Bitcoin/BitcoinCash transactions
/// - amount: Quantity to be sent
/// - address: Recipient's address
/// - changeAddress: Address to which the change will be sent (difference between the total transaction amount and the commission)
/// - feeCalculator: BtcBchFeeCalculator (uses to calculate the commission)
public class BitcoinTemplateUnspentTransaction<T: BitcoinTemplateTransaction> {
    public let amount: UInt64
    
    var feePerByte: UInt64 = 0
    public var expectedFeeValue: UInt64 = 0
    
    public let address: String
    public let changeAddress: String
    let utxo: [BitcoinUnspentOutput]
    let isSendAll: Bool
    let settings: BitcoinTransactionSettings
    
    public var feeCalculator: BtcBchFeeCalculator
    
    /// Initialization with empty/zero values
    public init() {
        amount = 0
        feePerByte = 0
        address = ""
        changeAddress = ""
        utxo = []
        isSendAll = true
        settings = .bitcoinDefaults
        
        feeCalculator = BtcBchFeeCalculator(amount: amount, utxo: utxo, isSendAll: isSendAll)
    }
    
    /// Init
    /// - Parameter amount: Amount for spending (in Satoshis)
    /// - Parameter addresss: Base58 encoded recipient bitcoin address string
    /// - Parameter changeAddress: Base58 encoded bitcoin address for change string
    /// - Parameter utxo: Unspent outputs
    /// - Parameter isSendAll: This flag indicates that the maximum available quantity will be sent
    /// - Parameter settings: Transaction build settings
    public init(amount: UInt64, addresss: String, changeAddress: String, dust: UInt64 = 1000, utxo: [BitcoinUnspentOutput], isSendAll: Bool, settings: BitcoinTransactionSettings) {
        self.amount = amount
        self.address = addresss
        self.changeAddress = changeAddress
        self.utxo = utxo
        self.isSendAll = isSendAll
        self.settings = settings
        
        feeCalculator = BtcBchFeeCalculator(amount: amount, utxo: utxo, isSendAll: isSendAll, dust: dust, settings: settings)
    }
    
    /// Transaction creation
    /// - Parameter feePerByte: Transaction fee value per byte in Satoshis
    public func buildTransaction(feePerByte: UInt64) throws -> T {
        self.feePerByte = feePerByte
        expectedFeeValue = try feeCalculator.calculate(with: feePerByte)
        let usedInputs = feeCalculator.usedInputs.map({
            BitcoinTransactionInput(hash: $0.transactionHash,
                                    id: Data($0.transactionHash.reversed()).hex,
                                    index: Int($0.outputN),
                                    value: UInt64($0.value),
                                    script: $0.script)
        })
        let inputsAmount = usedInputs.map({ $0.value }).reduce(0, +)

        
        var usedOutputs: [BitcoinTransactionOutput] = []
        
        let outputAddress = try BitcoinPublicKeyAddress(string: address)
        let output = BitcoinTransactionOutput(amount: amount, address: outputAddress)
        
        usedOutputs.append(output)
        
        if !isSendAll && !changeAddress.isEmpty {
            let outputChangeAddress = try BitcoinPublicKeyAddress(string: changeAddress)
            let changeOutput = BitcoinTransactionOutput(amount: inputsAmount - (amount + expectedFeeValue), address: outputChangeAddress)
            
            usedOutputs.append(changeOutput)
        }
        
        return T(inputs: usedInputs, outputs: usedOutputs, settings: settings)
    }
    
    /// Transaction creation
    /// - Parameter feeAmount: The commission value for the transaction which will be set without calculation in accordance with its size
    public func buildTransaction(feeAmount: UInt64) throws -> T {
        let dust: UInt64 = isSendAll ? 0 : 1000
         
        let unspentSorted = utxo.sorted(by: { $0.value > $1.value })
        var usedInputs: [BitcoinTransactionInput] = []
         
        var total: UInt64 = 0
         
        for txinput in unspentSorted {
            if settings.allowedScriptTypes.contains(txinput.script.type) {
                let input = BitcoinTransactionInput(hash: txinput.transactionHash,
                                                    id: Data(txinput.transactionHash.reversed()).hex,
                                                    index: Int(txinput.outputN),
                                                    value: UInt64(txinput.value),
                                                    script: txinput.script)
                usedInputs.append(input)
                total += txinput.value
            }
            if total > amount + dust { break }
        }
         
        var usedOutputs: [BitcoinTransactionOutput] = []
         
        let outputAddress = try BitcoinPublicKeyAddress(string: address)
        let output = BitcoinTransactionOutput(amount: amount, address: outputAddress)
        
        usedOutputs.append(output)
        
        if !isSendAll && !changeAddress.isEmpty {
            let outputChangeAddress = try BitcoinPublicKeyAddress(string: changeAddress)
            let changeOutput = BitcoinTransactionOutput(amount: UInt64(total) - (amount + feeAmount), address: outputChangeAddress)
            
            usedOutputs.append(changeOutput)
        }
         
        return T(inputs: usedInputs, outputs: usedOutputs, settings: settings)
    }
}


// MARK: - CustomStringConvertible

extension BitcoinTemplateUnspentTransaction: CustomStringConvertible {
    public var description: String {
        """
        BITCOIN_UNSPENT_TRANSACTION
        AMOUNT: \(amount)
        FEE_PER_BYTE: \(feePerByte)
        EXPECTED_FEE_VALUE: \(expectedFeeValue)
        ADDRESS: \(address)
        CHANGE_ADDRESS: \(changeAddress)
        UTXO: \(utxo)
        USING_UTXO: \(feeCalculator.usedInputs)
        IS_SEND_ALL: \(isSendAll)
        """
    }
}

