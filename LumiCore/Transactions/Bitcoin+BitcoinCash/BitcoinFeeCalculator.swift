//
//  BiticoinFeeCalculator.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation


public enum BtcBchCalcuateFeeError: Error {
    case spendingAmountIsZero
    case availableBalanceTooSmall
}

/// An object for calculating the commission based on the target quantity for sending and receiving UnspentOuputs
public class BtcBchFeeCalculator {
    
    let amount: UInt64
    let availableAmount: UInt64
    let utxo: [BitcoinUnspentOutput]
    let isSendAll: Bool
    let isWitness: Bool
    
    public var usedInputs: [BitcoinUnspentOutput] = []
    public var usedInputsCount: Int {
        usedInputs.count
    }
    
    let allowedScriptTypes: [BitcoinScript.ScriptType]
    
    /// Init
    /// - Parameter amount: Amount for spent in Satoshis
    /// - Parameter utxo: Available unspent outputs
    /// - Parameter isSendAll: This flag indicates that the maximum available quantity will be sent
    public init(amount: UInt64, utxo: [BitcoinUnspentOutput], isSendAll: Bool) {
        self.amount = amount
        self.availableAmount = utxo.map({ $0.value }).reduce(0, +)
        self.utxo = utxo
        self.isSendAll = isSendAll
        
        self.allowedScriptTypes = [BitcoinScript.ScriptType.P2PKH]
        self.isWitness = false
    }
    
    public init(amount: UInt64, utxo: [BitcoinUnspentOutput], isSendAll: Bool, settings: BitcoinTransactionSettings = .bitcoinDefaults) {
        self.amount = amount
        self.availableAmount = utxo.map({ $0.value }).reduce(0, +)
        self.utxo = utxo
        self.isSendAll = isSendAll
        
        self.allowedScriptTypes = settings.allowedScriptTypes
        self.isWitness = settings.isWitness
    }
    
    /// Calculate
    /// - Parameter feePerByte: Value in Satoshis
    /// - Throws: BtcBchCalcuateFeeError.spendingAmountIsZero, BtcBchCalcuateFeeError.availableBalanceTooSmall
    public func calculate(with feePerByte: UInt64) throws -> UInt64 {
        let targetAmount = isSendAll ? availableAmount : amount
        
        if targetAmount == 0 { throw BtcBchCalcuateFeeError.spendingAmountIsZero }
        
        let dust: UInt64 = isSendAll ? 0 : 1000
        
        var expectedSize = findTransactionSize(with: targetAmount + dust)
        
        let transactionFee = expectedSize * feePerByte
        
        if transactionFee >= availableAmount { throw BtcBchCalcuateFeeError.availableBalanceTooSmall }
        
        if isSendAll {
            return transactionFee
        }
        
        var totalValue = targetAmount + dust + transactionFee
        
        if totalValue > availableAmount { throw BtcBchCalcuateFeeError.availableBalanceTooSmall }
        
        while totalValue < availableAmount {
            expectedSize = findTransactionSize(with: totalValue)
            totalValue = targetAmount + dust + (expectedSize * feePerByte)
            
            if totalValue > availableAmount {
                throw BtcBchCalcuateFeeError.availableBalanceTooSmall
            }
            if totalValue < availableAmount {
                break
            }
        }
        
        if totalValue > usedInputs.map({ $0.value }).reduce(0, +) && !isSendAll {
            throw BtcBchCalcuateFeeError.availableBalanceTooSmall
        }
        
        let result = expectedSize * feePerByte
        
        return result
    }
    
    @discardableResult
    private func findTransactionSize(with amount: UInt64) -> UInt64 {
        usedInputs.removeAll()
        let targetValue = amount

        var inputsSum: UInt64 = 0
        var countInputs = 0

        for input in utxo {
            if allowedScriptTypes.contains(input.script.type) {
                usedInputs.append(input)
                inputsSum += input.value
                countInputs += 1
            }
            if inputsSum >= targetValue {
                break
            }
        }

        let countOutputs = isSendAll ? 1 : 2
        
        var s: Int
        var result: Int
        
        if isWitness {
            s = (41 * countInputs) + (32 * countOutputs) + 10
            let w = (149 * countInputs) + (32 * countOutputs) + 12
            
            result = ((3 * s) + w) / 4
        } else {
            s = (148 * countInputs) + (34 * countOutputs) + 10
            result = s
        }

        return UInt64(result)
    }
}
