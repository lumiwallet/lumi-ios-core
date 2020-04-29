#  EthereumTransaction

Object for creating, signing and serialization Ethereum transactions 

## Initializer 

Initializes an object with [EthereumUnspentTransaction](#EthereumUnspentTransaction)

```swift
public init(unspentTx: EthereumUnspentTransaction)
```

#### Parameters: 
* **unspentTx** - An EthereumUnspentTransaction object


## Properties

**raw** - Serialized transaction

```swift 
public var raw: String.HexString
```

**payload** - An Ethereum transaction payload

```swift
public var payload: Data
```

## Methods
Serialize an object
 
 ```swift
 public func serialize() throws -> Data
 ```
Sign a transaction with a set of private key bytes

```swift
public func sign(key: Data)
```

# EthereumUnspentTransaction

An object that contains a set of data for EthereumTransaction

## Initializers

```swift
public init(chainId: UInt8, nonce: Int, amount: Data, address: String, gasPrice: Data, gasLimit: Data, data: Data)
```
#### Parameters:

* **chainId** - Chain ID of the Ethereum blockchain
* **nonce** - Serial number of the outgoing transaction
* **amount** - Amount of the transaction
* **address** - Recepient address
* **gasPrice** - Current gas price
* **gasLimit** - Gas limit for the transaction
* **data** - Additional data

</br>

```swift
convenience public init(chainId: UInt8, nonce: Int, amount: String.DecimalString, address: String, gasPrice: String.DecimalString, gasLimit: String.DecimalString, data: String.HexString)
```
#### Parameters:

* **chainId** - Chain ID of the Ethereum blockchain
* **nonce** - Serial number of the outgoing transaction
* **amount** - Amount of the transaction in WEI
* **address** - Recepient address
* **gasPrice** - Current gas price in WEI
* **gasLimit** - Gas limit for the transaction in WEI
* **data** - Additional data in hexadecimal representation

## Errors
* EthereumCreateTransactionError
    * *wrongSignature* - An error occurred while signing a transaction with a set of private keys
    
## Usage examples

```swift
let chainId: UInt8 = 1
let nonce: Int = 88
let amount: String = "4000000000000000"
let address: String = "0x9e95ff7bf7a19dd841418eaee4db9e0556db78d8"
let gasPrice: String = "2500000000"
let gasLimit: String = "21000"
let data: String = "0x00"

let ethereumUnspentTransaction = EthereumUnspentTransaction(chainId: chainId, nonce: nonce, amount: amount, address: address, gasPrice: gasPrice, gasLimit: gasLimit, data: data)

let transaction = EthereumTransaction(unspentTx: ethereumUnspentTransaction)

...

do {
    try transaction.sign(key: privateKey)
    print(transaction.raw)
} catch let e as EthereumCreateTransactionError.wrongSignature {
    
} catch {
    
}
```
