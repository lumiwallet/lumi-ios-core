//
//  EosTransactionState.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation
import LumiCore


public struct EosTransactionInfo {
    let address: String
    let amount: String
    let memo: String
    let bin: String
    let actor: String
    let permission: String
    let expiration: String
    let chain: String
    let referenceBlockNum: String
    let referenceBlockPrefix: String
    let wifPrivateKey: String
}

public struct EosTransactionResultInfo {
    let packedTrx: String
    let signatures: String
}


public class EosTransactionState {
    var address: String = ""
    var amount: String.DecimalString = "0"
    var memo: String = ""
    var bin: String.DecimalString = "0"
    var account: String = ""
    var permission: String = ""
    var refBlockNum: Int = 0
    var refBlockPrefix: Int = 0
    var chainId: String.HexString = ""
    var expiration: String = ""
    
    @Published var errorMessage: String?
    @Published var transactionResultInfo: EosTransactionResultInfo?
    
    func build(info: EosTransactionInfo) {
        self.address = info.address
        self.account = info.actor
        self.amount = info.amount
        self.memo = info.memo
        self.bin = info.bin
        self.permission = info.permission
        
        guard let _refBlockNum = Int(info.referenceBlockNum, radix: 10) else {
            errorMessage = EosErrorDescription.referenceBlockNumError
            return
        }
        
        guard let _refBlockPrefix = Int(info.referenceBlockPrefix, radix: 10) else {
            errorMessage = EosErrorDescription.referenceBloclPrefixError
            return
        }
        
        self.refBlockNum = _refBlockNum
        self.refBlockPrefix = _refBlockPrefix
        self.chainId = info.chain
        self.expiration = info.expiration
        
        
        let unspentTransaction = EosUnspentTransaction(account: self.account,
                                                       action: .transfer(account: "eosio.token", from: self.account, to: self.address, quanity: self.amount, memo: self.memo))
        unspentTransaction.expiration = Date(timeIntervalSince1970: Double(expiration) ?? 0)
        
        let packedTransaction = unspentTransaction.buildPackedTransaction(bin: self.bin,
                                                                          chain: self.chainId,
                                                                          blockNum: self.refBlockNum,
                                                                          blockPrefix: self.refBlockPrefix,
                                                                          authorization: EosAuthorization(actor: self.account, permission: self.permission))
        
        
        
        guard !info.wifPrivateKey.isEmpty else {
            self.errorMessage = EosErrorDescription.privateKeyDataError
            return
        }
        
        do {
            let eosKey = try EosKey(wif: info.wifPrivateKey)
            try packedTransaction.sign(key: eosKey)
            
            self.transactionResultInfo = EosTransactionResultInfo(packedTrx: packedTransaction.packedTrx, signatures: packedTransaction.signatures.joined(separator: "\n"))
            
        } catch let e as EosKeyError {
            self.errorMessage = description(from: e)
        } catch let e as EosCreateTransactionError {
            self.errorMessage = description(from: e)
        } catch {
            self.errorMessage = EosErrorDescription.unknownError
        }
    }
    
    public func description(from error: EosKeyError) -> String {
        switch error {
        case .dataLength:
            return EosErrorDescription.eosKeyDataError
        case .decodeBase58:
            return EosErrorDescription.eosBase58DecodeError
        }
    }
    
    public func description(from error: EosCreateTransactionError) -> String {
        switch error {
        case .wrongSignature:
            return EosErrorDescription.signingTransactitonError
        }
    }
}

