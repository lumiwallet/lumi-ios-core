//
//  EthereumUnspentTransaction.swift
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

/// Ethereum unspent transaction that contains a dataset for building an EthereumTransaction instance
public class EthereumUnspentTransaction {
    let chainId: UInt
    let nonce: Int
    
    let amount: Data
    let gasPrice: Data
    let gasLimit: Data
    
    let address: Data
    
    let data: Data
    
    var v: Data
    var r: Data
    var s: Data
    
    /// Init
    /// - Parameter chainId: Chain id of ethereum blockchain (main = 1)
    /// - Parameter nonce: Serial number of outgoing transaction
    /// - Parameter amount: Amount data
    /// - Parameter address: Recipient address
    /// - Parameter gasPrice: Current gas price data
    /// - Parameter gasLimit: Gas limit data for transaction
    /// - Parameter data: Additional data
    public init(chainId: UInt, nonce: Int, amount: Data, address: String, gasPrice: Data, gasLimit: Data, data: Data) {
        self.chainId = chainId
        self.nonce = nonce
        
        self.amount = amount
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
        self.address = Data(hex: address)
        self.data = data
        
        v = chainId.bigEndian.data.dropedPrefixZeros
        r = Data(count: 1)
        s = Data(count: 1)
    }
    
    /// Convenience init
    /// - Parameter chainId: Chain id of ethereum blockchain (main = 1)
    /// - Parameter nonce: Serial number of outgoing transaction
    /// - Parameter amount: Amount in decimal string representation
    /// - Parameter address: Recipient address
    /// - Parameter gasPrice: Current gas price in decimal string representation
    /// - Parameter gasLimit: Gas limit for transaction in decimal string representation
    /// - Parameter data: Additional data
    convenience public init(chainId: UInt, nonce: Int, amount: String.DecimalString, address: String, gasPrice: String.DecimalString, gasLimit: String.DecimalString, data: String.HexString) {
        self.init(chainId: chainId,
                  nonce: nonce,
                  amount: Data(hex: Hex2DecimalConverter.convertToHexString(fromDecimalString: amount)).dropedPrefixZeros,
                  address: address,
                  gasPrice: Data(hex: Hex2DecimalConverter.convertToHexString(fromDecimalString: gasPrice)),
                  gasLimit: Data(hex: Hex2DecimalConverter.convertToHexString(fromDecimalString: gasLimit)),
                  data: Data(hex: data))
    }
}


// MARK: - CustomStringConvertible

extension EthereumUnspentTransaction: CustomStringConvertible {
    public var description: String {
        """
        ETHEREUM_TRANSACTION
        CHAIN: \(chainId)
        NONCE: \(nonce)
        AMOUNT: \(Hex2DecimalConverter.convertToDecimalString(fromHexString: amount.hex))
        AMOUNT HEX: \(amount.hex)
        ADDRESS: \(address.hex)
        GAS_PRICE: \(Hex2DecimalConverter.convertToDecimalString(fromHexString: gasPrice.hex))
        GAS_PRICE HEX: \(gasPrice.hex)
        GAS_LIMIT: \(Hex2DecimalConverter.convertToDecimalString(fromHexString: gasLimit.hex))
        GAS_LIMIT HEX: \(gasLimit.hex)
        DATA: \(data.hex)
        V: \(v.hex)
        R: \(r.hex)
        S: \(s.hex)
        """
    }
}
