//
//  EthereumTransactionState.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore
import LumiCore.Utils


public struct EthereumTransactionInfo {
    var address: String
    var amount: String
    var gasPrice: String
    var gasLimit: String
    var nonce: String
    var chain: String
    var data: String
    var privateKeyData: String
}


public struct EthereumTransactionResultInfo {
    let raw: String
    let description: String
}


class EthereumTransactionState {
    var address: String = ""
    var amount: String.DecimalString = "0"
    var gasPrice: String.DecimalString = "0"
    var gasLimit: String.DecimalString = "0"
    var nonce: Int = 0
    var chainId: UInt8 = 1
    var data: String.HexString = "0x00"
    
    var serialized: String = ""
    var raw: String = ""
    var txDescription: String = ""
    
    @Published var errorMessage: String?
    
    @Published var transactionResultInfo: EthereumTransactionResultInfo?
    
    func build(info: EthereumTransactionInfo) {
        
        self.address = info.address
        
        guard !Data(hex: self.address).isEmpty else {
            self.errorMessage = EthereumErrorDescription.ethereumAddressError
            return
        }

        self.amount = info.amount
        self.gasPrice = info.gasPrice
        self.gasLimit = info.gasLimit
        
        guard let _nonce = Int(info.nonce, radix: 10) else {
            self.errorMessage = EthereumErrorDescription.nonceError
            return
        }
        guard let _chain = UInt8(info.chain, radix: 10) else {
            self.errorMessage = EthereumErrorDescription.chainError
            return
        }
        self.nonce = _nonce
        self.chainId = _chain
        
        let unspentTransation = EthereumUnspentTransaction(chainId: self.chainId,
                                                           nonce: self.nonce,
                                                           amount: self.amount,
                                                           address: self.address,
                                                           gasPrice: self.gasPrice,
                                                           gasLimit: self.gasLimit,
                                                           data: self.data)
        
        let privateKey = Data(hex: info.privateKeyData)
        
        guard !privateKey.isEmpty else {
            self.errorMessage = EthereumErrorDescription.privateKeyDataError
            return
        }
        
        let ethereumTransaction = EthereumTransaction(unspentTx: unspentTransation)
        
        do {
            try ethereumTransaction.sign(key: privateKey)
            
            transactionResultInfo = EthereumTransactionResultInfo(raw: ethereumTransaction.raw, description: "\(ethereumTransaction)")
        } catch {
            self.errorMessage = EthereumErrorDescription.signingTransactionError
        }
    }
}
