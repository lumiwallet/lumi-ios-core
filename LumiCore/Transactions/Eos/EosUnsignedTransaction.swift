//
//  EosUnsignedTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

public protocol ABIConvertable {
    var dictionary: [String: Any] { get }
}

/// EOS transaction basic actions
/// - transfer
/// - buyRam
/// - stake
public enum EosTransactionAction: ABIConvertable {
    /// Simple transfer between users accounts
    /// - account: Contract identificator
    /// - from, to: Users account names
    /// - quantity: Value for transfer
    /// - memo: Additional message
    case transfer(account: String, from: String, to: String, quanity: String, memo: String)
    
    /// Buy RAM action
    /// - payer: Payer account name
    /// - receiver: Receiver account name
    /// - bytes: Amount bytes
    case buyRam(payer: String, receiver: String, bytes: Int)
    
    /// Stake resources
    /// - from: Payer account name
    /// - receiver: Receiver account name
    /// - stakeCPU: Staked CPU value
    /// - stakeNET: Staked NET value
    /// - transfer: Transfer value
    case stake(from: String, receiver: String, stakeCPU: String, stakeNET: String, transfer: Int)
    
    public var name: String {
        switch self {
        case .transfer:
            return "transfer"
        case .buyRam:
            return "buyrambytes"
        case .stake:
            return "delegatebw"
        }
    }
    
    public var code: String {
        switch self {
        case let .transfer(account: account, from: _, to: _, quanity: _, memo: _):
            return account
        case .buyRam:
            return "eosio"
        case .stake:
            return "eosio"
        }
    }
    
    public var dictionary: [String : Any] {
        switch self {
        case let .transfer(account: _, from: from, to: to, quanity: quantity, memo: memo):
            return [ "memo" : memo, "from" : from, "to" : to, "quantity" : quantity]
        case let .buyRam(payer: payer, receiver: receiver, bytes: bytes):
            return [ "payer" : payer, "receiver" : receiver, "bytes" : bytes]
        case let .stake(from: from, receiver: receiver, stakeCPU: stakeCPU, stakeNET: stakeNET, transfer: transfer):
            return [ "from" : from, "receiver" : receiver, "stake_cpu_quantity" : stakeCPU, "stake_net_quantity" : stakeNET, "transfer": transfer]
        }
    }
}


/// ABI. An intermediate structure for working with EOS ABI
public struct EosABI {
    public let code: String
    public let action: String
    public let args: [String: Any]
    
    public init(action: EosTransactionAction) {
        self.code = action.code
        self.action = action.name
        self.args = action.dictionary
    }
}


/// Authorization
public struct EosAuthorization {
    public var actor: String
    public var permission: String
    
    /// Init
    /// - Parameter actor: Account name
    /// - Parameter permission: Permission for account (e.g. "active")
    public init(actor: String, permission: String) {
        self.actor = actor
        self.permission = permission
    }
}


/// Packed transaction
public class EosPackedTransaction {
    public var transaction: EosUnspentTransaction
    public var signatures: [String] = []
    public var compression: String
    public var packedTrx: String = ""
    
    /// Init. Fills 'transaction' property and fills 'packedTrx' property with serialized instance of itself
    /// - Parameter unspentTransaction: Instance of EosUnspentTransaction (should be filled with refBlockNum, refBlockPrefix, expiration and chain ID)
    /// - Parameter compress: Compression type
    public init(unspentTransaction: EosUnspentTransaction, compress: String) {
        transaction = unspentTransaction
        signatures = []
        compression = compress
        packedTrx = EosSerialization().data(chain: "", packedTransaction: self).hex
    }
    
    /// Signs a transaction and adds a signature in 'signatures' property
    /// - Parameter key: Instance of EOS private key
    public func sign(key: EosKey) throws {
        let coder = EosSerialization()
        let data = coder.data(chain: transaction.chain, packedTransaction: self)
        
        let digest = data.sha256()
        
        var recid: Int = 0
        let signature = ECDSAfunctions.sign(target: .eos, data: digest, key: key.data, recid: &recid)
        
        guard ECDSAfunctions.validate(signature: signature, data: data, for: key.data, type: .Compact) else {
            throw EosCreateTransactionError.wrongSignature
        }
        
        recid += 4 + 27
        let r = signature.subdata(in: 0..<32)
        let s = signature.subdata(in: 32..<64)
        
        let signatureData = UInt8(recid).data + r + s
        let hashedData = signatureData + key.enclave.data
        let checksum = hashedData.ripemd160().subdata(in: 0..<4)
        let bin = signatureData + checksum 
        let base58 = bin.base58(usingChecksum: false)
        
        signatures.append(["SIG", key.enclave.name, base58].joined(separator: "_"))
    }
}


/// Act. An intermediate structure for working with EOS transaction
public struct EosAct {
    public let account: String
    public let name: String
    public let authorization: EosAuthorization
    public let data: String
    
    public init(action: EosTransactionAction, authorization: EosAuthorization, bin: String) {
        self.account = action.code
        self.name = action.name
        self.authorization = authorization
        self.data = bin
    }
}


/// A transaction template that contains a dataset for building an EosPackedTransaction instance
public class EosUnspentTransaction {
    public let account: String
    public let action: EosTransactionAction
    public var acts: [EosAct] = []
    public var refBlockNum: Int = 0
    public var refBlockPrefix: Int = 0
    public var expiration: Date = Date(timeIntervalSinceNow: 360)
    public var chain: String = ""
    
    /// Init
    /// - Parameter account: User account name
    /// - Parameter action: Basci EOS transaction action such as .transfer, .stake, .buyRam
    public init(account: String, action: EosTransactionAction) {
        self.account = account
        self.action = action
    }
    
    /// Init
    /// - Parameter unspentTransaction: Another instance EosUnspentTransaction
    /// - Parameter acts: Array of EOS acts
    public init(unspentTransaction: EosUnspentTransaction, acts: [EosAct]) {
        self.account = unspentTransaction.account
        self.action = unspentTransaction.action
        self.acts = acts
    }
    
    public func abi(action: EosTransactionAction) -> EosABI {
        EosABI(action: action)
    }
    
    /// Method for preparing EosPackedTransaction
    /// - Parameter bin: Encoded EosABI to bin string. Encoding is carried out using EOS node API
    /// - Parameter chain: EOS blockchain chain ID
    /// - Parameter blockNum: EOS blockchain block number
    /// - Parameter blockPrefix: EOS blockchain block prefix
    /// - Parameter autorization: An instance of EosAuthorization struct (includes account name and permission)
    /// - Parameter compression: Compression type string ('none' by default)
    public func buildPackedTransaction(bin: String, chain: String.HexString, blockNum: Int, blockPrefix: Int, authorization: EosAuthorization, compression: String = "none") -> EosPackedTransaction {
        self.chain = chain
        self.refBlockNum = blockNum
        self.refBlockPrefix = blockPrefix
        self.acts = [EosAct(action: action, authorization: authorization, bin: bin)]
        return EosPackedTransaction(unspentTransaction: self, compress: compression)
    }
}

// MARK: - CustomStringConvertible

extension EosAuthorization: CustomStringConvertible {
    
    public var description: String {
        "ACTOR: \(actor), PERMISSION: \(permission)"
    }
}

extension EosAct: CustomStringConvertible {
    
    public var description: String {
        """
        EOS_ACT
        ACCOUNT: \(account)
        NAME: \(name)
        AUTHORIZATION: \(authorization)
        DATA: \(data)
        """
    }
}

extension EosTransactionAction: CustomStringConvertible {
    
    public var description: String {
        """
        EOS_TRANSACTION_ACTION
        NAME: \(name)
        CODE: \(code)
        PARAMS\(dictionary)
        """
    }
}

extension EosUnspentTransaction: CustomStringConvertible {
    
    public var description: String {
        """
        EOS_UNSPENT_TRANSACTION
        ACCOUNT: \(account)
        ACTION: \(action)
        ACTS: \(acts)
        REF_BLOCK_NUM: \(refBlockNum)
        REF_BLOCK_PREFIX: \(refBlockPrefix)
        EXPIRATION: \(expiration)
        CHAIN_ID: \(chain)
        """
    }
}

extension EosPackedTransaction: CustomStringConvertible {
    
    public var description: String {
        """
        EOS_PACKED_TRANSACTION
        UNSPENT_TRANSACTION: \(transaction)
        SIGNATURES: \(signatures)
        COMPRESSION: \(compression)
        PACKED_TRX: \(packedTrx)
        """
    }
}
