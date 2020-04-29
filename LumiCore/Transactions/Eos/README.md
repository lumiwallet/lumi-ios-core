#  EosPackedTransaction

Object for creating and signing EOS transactions 

## Initializer

Initializes an object with [EosUnspentTransaction](#EosUnspentTransaction)

```swift
public init(unspentTransaction: EosUnspentTransaction, compress: String)
```

#### Parameters:

* **unspentTransaction** - EosUnspentTransaction instance (should be filled with refBlockNum, refBlockPrefix, expiration and chain ID)

* **compress** - Compression type

## Properties

**transaction** - EosUnspentTransaction instance

```swift
public var transaction: EosUnspentTransaction
```

**signatures** - Transaction signatures

```swift
public var signatures: [String]
```

**compress** - Transaction compression type 

```swift
public var compression: String
```

**packedTrx** - Serialized transaction

```swift
public var packedTrx: String
```

## Methods

Sign a transaction with [EosKey](../../Crypto/Eos/README.md)

```swift
public func sign(key: EosKey)
```


# EosUnspentTransaction

An object that contains a set of data for [EosPackedTransaction](#EosPackedTransaction)

## Initializers

```swift
public init(account: String, action: EosTransactionAction)
```

#### Parameters

* **account** - Eos account name
* **action** - [Eos transaction action](#EosTransactionAction) (e.g. .buyRam or .stake)

</br>

```swift
public init(unspentTransaction: EosUnspentTransaction, acts: [EosAct])
```

#### Parameters

* **unspentTransaction** - Instance of EosUnspentTransaction
* **acts** - Array of [EosActs](#EosAct)

## Properties

**account** - Account name

```swift 
public let account: String
```

**action** - EOS action

```swift
public let action: EosTransactionAction
```

**acts** - Array of [EosActs](#EosAct)

```swift
public var acts: [EosAct]
```

**refBlockNum** - EOS block parameter

```swift
public var refBlockNum: Int
```

**refBlockPrefix** - EOS block parameter

```swift
public var refBlockPrefix: Int
```

**expiration**  - Transaction expiration

```swift
public var expiration: Date
```

**chain** - EOS chain ID

```swift
public var chain: String
```

## Methods

Create an ABI from action

```swift
public func abi(action: EosTransactionAction) -> EosABI
```

Prepare [EosPackedTransaction](#EosPackedTransaction)

```swift
public func buildPackedTransaction(bin: String, chain: String.HexString, blockNum: Int, blockPrefix: Int, autorization: EosAutorization, compression: String = "none") -> EosPackedTransaction
```

# EosTransactionAction

Enum with available EOS actions

## Cases

* **transfer** - Simple transfer from one account to another

```swift
case transfer(account: String, from: String, to: String, quanity: String, memo: String)
```

* **buyRam** - Buy RAM action

```swift
case buyRam(payer: String, receiver: String, bytes: Int)
```

* **stake** - Resources stake action

```swift
case stake(from: String, receiver: String, stakeCPU: String, stakeNET: String, transfer: Int)
```

## Properties

**name** - Action name in String

```swift
public var name: String
```

**code** - Action code

```swift
public var code: String
```

**dictionary** - Action info in a dictionary

```swift
public var dictionary: [String : Any]
```

# EosAuthorization

## Initializer 

```swift
public init(actor: String, permission: String)
```

## Properties

**actor** - Account name

```swift
public var actor: String
```

**permission** - Permission for an account (e.g. "active")

```swift
public var permission: String
```

# EosABI 

## Initializer 

Initializes an object from [EosTransactionAction](#EosTransactionAction) instance

```swift 
public init(action: EosTransactionAction)
```

## Properties

**code** - Action code

```swift
public let code: String
```

**action** - Action name

```swift
public let action: String
```

**args** - Dictionary from action

```swift
public let args: [String: Any]
```

# EosAct

An intermediate structure for working with EOS transaction

## Initializer

```swift
public init(action: EosTransactionAction, autorization: EosAutorization, bin: String)
```

#### Parameters

* **action** - [EosTransactionAction](#EosTransactionAction) instance
* **autorization** - [EosAutorization](#EosAutorization) instance
* **bin** - ABI bin string

## Properties

**account** - Code from action

```swift
public let account: String
```

**name** - Action name

```swift
public let name: String
```

**autorization** - [EosAuthorization](#EosAuthorization) instance

```swift
public let autorization: EosAutorization
```

**data** -  ABI bin string

```swift
public let data: String
```

# Errors
* EosCreateTransactionError
    * *wrongSignature* - An error occurred while signing a transaction with EosKey    

# Usage example

```swift
let account: String = "eosio.token"
let action: EosTransactionAction = .transfer(account: "eosio.token", from: "testaccount1", to: "testaccount2", quanity: "0.0001 EOS", memo: "Memo")
let expiration = 1580811780.835552

let bin: String = "10f2d4142193b1ca20f2d4142193b1ca010000000000000004454f5300000000044d656d6f"
let chainId: String = "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906"
let blockNum: Int = 103423741
let blockPrefix: Int = 2142807285

let authorization = EosAutorization(actor: "testaccount1", permission: "active")

let eosUnspentTransaction = EosUnspentTransaction(account: account, action: action)
eosUnspentTransaction.expiration = Date(timeIntervalSince1970: expiration)
let eosPackedTransaction = eosUnspentTransaction.buildPackedTransaction(bin: bin, chain: chainId, blockNum: blockNum, blockPrefix: blockPrefix, autorization: authorization)

...

do {
    let key = try EosKey(data: privateKey)
    try eosPackedTransaction.sign(key: key)
} catch let e as EosCreateTransactionError {
    
} catch let e as EosKeyError {
    
} catch {
    
}
```
