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
    
    public var usedInputs: [BitcoinUnspentOutput] = []
    public var usedInputsCount: Int {
        usedInputs.count
    }
    
    /// Init
    /// - Parameter amount: Amount for spent in Satoshis
    /// - Parameter utxo: Available unspent outputs
    /// - Parameter isSendAll: This flag indicates that the maximum available quantity will be sent
    public init(amount: UInt64, utxo: [BitcoinUnspentOutput], isSendAll: Bool) {
        self.amount = amount
        self.availableAmount = utxo.map({ $0.value }).reduce(0, +)
        self.utxo = utxo
        self.isSendAll = isSendAll
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
            if input.script.isPayToPublicKeyHashScript() {
                usedInputs.append(input)
                inputsSum += input.value
                countInputs += 1
            }
            if inputsSum >= targetValue {
                break
            }
        }

        let countOutputs = isSendAll ? 1 : 2
        let size = (148 * countInputs) + (34 * countOutputs) + 10

        return UInt64(size)
    }
}
