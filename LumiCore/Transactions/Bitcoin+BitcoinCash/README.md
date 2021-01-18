#  Bitcoin/BitcoinCash Transaction

_BitcoinTransaction_ and _BitcoinCashTransaction_ is an object for creating, signing and serialization Bitcoin/BitcoinCash transactions. 

## Initializer 

Initializes an object with a sets of [BitcoinTransactionInput](#BitcoinTransactionInput) and [BitcoinTransactionOutput](#BitcoinTransactionOutput)

```swift
public required init(inputs: [BitcoinTransactionInput], outputs: [BitcoinTransactionOutput], settings: BitcoinTransactionSettings)
```

#### Parameters: 
* **inputs** - Set of inputs
* **outputs** - Set of outputs
* **settings** - BitcoinTransactionSettings object

## Properties

**inputs** - 

```swift 
public let _inputs: [BitcoinTransactionInput]
```

**outputs** - 

```swift 
public let _outputs: [BitcoinTransactionOutput]
```

**settings** - An object containing the settings of the transaction fields, such as version, locktime, witness marker, flag, as well as a set of used script 

```swift 
var settings: BitcoinTransactionSettings
```

**version** - Transaction version number

```swift 
public var version: UInt32
```

**locktime** - Locktime for transaction, zero by default

```swift 
public var lockTime: Int
```

**payload** - Serialized transaction data

```swift 
//Computed property
public var payload: Data
```

**transactionHash** - Hash data transaction

```swift 
//Computed property
public var transactionHash: Data
```

**id** - String representation transaction id (transactionHash reversed bytes)

```swift
//Computed property
public var id: String
```

**witness** - Witness data (* available only for BitcoinTransaction object)

```swift
public var witness: Data?
```

**wtxid** - Witness transaction id (* available only for BitcoinTransaction object)

```swift
//Computed property
public var wtxid: String
```

## Methods

Sign a transaction with a set of [Key](#BitcoinTransactionInput) objects

```swift
public func sign(keys: [Key]) throws -> BitcoinTransaction
```
or 
```swift
public func sign(keys: [Key]) throws -> BitcoinCashTransaction
```

## Errors
* BitcoinCreateTransactionError
    * *wrongSignature* - An error occurred while signing a transaction with a set of private keys
    * *privateKeyNotFound* - Private key for signing the transaction is not found

## Usage examples

```swift

let txOutputs: [BitcoinTransactionOutput] = [/*Outputs*/]
let txInputs: [BitcoinTransactionInput] = [/*Inputs*/]

let settings = BitcoinTransactionSettings.new
   .version(1)
   .witness(marker: 0, flag: 1)
   .allowed(scriptTypes: [.P2PK, .P2PKH, .P2WPKH, .P2WSH])
   .lockTime(17)

let privateKeys = [/*Private keys for inputs that will be used in the transaction*/]

//Bitcoin
do {
    let transaction = BitcoinTransaction(inputs: txInputs, outputs: txOutputs, settings: settings)
    
    let signedTransaction = try transaction.sign(keys: privateKeys)
    
} catch let e as BitcoinCreateTransactionError {
    //Error
} catch {
    //Error
}

//BitcoinCash
do {
    let transaction = BitcoinCashTransaction(inputs: txInputs, outputs: txOutputs)
    
    let signedTransaction = try transaction.sign(keys: privateKeys)
    
} catch let e as BitcoinCreateTransactionError {
    //Error
} catch {
    //Error
}

```

# BitcoinTransactionInput

Object for displaying and working with transaction inputs

## Initializers

```swift
public init(hash: Data, id: String, index: Int, value: UInt64, script: BitcoinScript)
```
#### Parameters: 
* **hash** - Input transaction hash data
* **id** - Input transaction id
* **index** - Index in transaction
* **value** - Number in Satoshi
* **script** - BitcoinScript object

```swift
public init(hash: Data, id: String, index: Int, value: UInt64, script: BitcoinScript, sequence: UInt32)
```
#### Parameters: 
* **hash** - Input transaction hash data
* **id** - Input transaction id
* **index** - Index in transaction
* **value** - Number in Satoshi
* **script** - BitcoinScript object
* **sequence** - Sequence

```swift
public convenience init(hash: Data, id: String, index: Int, value: UInt64, scriptData: Data) throws
```
* **hash** - Input transaction hash data
* **id** - Input transaction id
* **index** - Index in transaction
* **value** - Value in Satoshi
* **scriptData** - Data representing script

## Properties

**payload** - Serialized input data

```swift 
//Computed property
public var payload: Data
```

## Errors
* BitcoinScriptError
    * *errorParseData* - Unable to parse data into script

## Usage examples

```swift

let id = Data(hex: "1558ca7fc980d5c570d8d25c481aad4b11714d152747e31e54fe252b33e5b607")
let hash = Data(id.reversed())
let index = 1
let value: UInt64 = 16442
let scriptData = Data(hex: "76a914741ef0668b2e83956832e428f8ae6876c453388388ac")


do {
    let input = try BitcoinTransactionInput(hash: hash, id: id, index: index, value: value, scriptData: scriptData)
    
} catch let e as BitcoinScriptError {
    //Error
} catch {
    //Error
}

```

# BitcoinTransactionOutput

Object for displaying and working with transaction outputs

## Initializers

```swift
public init()
```

```swift
public init(amount: UInt64, address: BitcoinPublicKeyAddress)
```
#### Parameters: 
* **amount** - Number in Satoshi
* **address** - [_BitcoinPublicKeyAddress_](../../Addresses/BitcoinAddress/README.md#BitcoinPublicKeyAddress) object


# BitcoinUnspentOutput

Object for displaying and working with unspent outputs

## Initializers

```swift
public init(address: String, value: UInt64, outputN: UInt32, scriptData: Data, hashData: Data) throws
```
#### Parameters: 
* **address** - Address to which belongs Unspent output
* **value** - Number in Satoshi
* **outputN** - Output number
* **scriptData** - Data representing script
* **hashData** - Hash data output transaction


## Errors
* BitcoinScriptError
    * *errorParseData* - Unable to parse data into script
    
## Usage examples

```swift

let address = "1BazSwJUhyUJkrLQrarRrvw9Bkig7oLrZt"
let hash = Data(hex: "37bad9d6074104c863c0586f828337538893fc0dfad1bf6c2755e566ea587f99")
let outputN: UInt32 = 1
let value: UInt64 = 16442
let scriptData = Data(hex: "76a914741ef0668b2e83956832e428f8ae6876c453388388ac")


do {
    let unspentOutput = try BitcoinUnspentOutput(address: address, value: value, outputN: outputN, scriptData: scriptData, hashData: hash)

} catch let e as BitcoinScriptError {
    //Error
} catch {
    //Error
}

```

# BitcoinTemplateUnspentTransaction

Object for forming template source data required for building Bitcoin/BitcoinCash transaction


```swift
public class BitcoinTemplateUnspentTransaction<T: BitcoinTemplateTransaction>
```

## Initializers


```swift
public init()
```

```swift
public init(amount: UInt64, addresss: String, changeAddress: String, utxo: [BitcoinUnspentOutput], isSendAll: Bool, settings: BitcoinTransactionSettings)
```

#### Parameters: 
* **amount** - Amount for spending, in Satoshis
* **addresss** - String encoded in Base58 recipient bitcoin adress
* **changeAddress** - String encoded in Base58 bitcoin address for change. The address to which the change will be sent, the difference between the total amount in the transaction and the commission
* **utxo** - Set of [_BitcoinUnspentOutput_](#BitcoinUnspentOutput) objects
* **isSendAll** - This flag indicates that the maximum available quantity will be sent
* **settings** - BitcoinTransactionSettings object

## Methods

Build Bitcoin/BitcoinCash transaction with fee per byte value

```swift
public func buildTransaction(feePerByte: UInt64) throws -> T
```

Build Bitcoin/BitcoinCash transaction with fee value that will be set regardless of the transaction size

```swift
public func buildTransaction(feeAmount: UInt64) throws -> T
```

## Errors
* [_BtcBchCalcuateFeeError_](#errors-4)
* [_BitcoinCreateAddressError_](../../Addresses/BitcoinAddress/README.md#errors)
    
## Usage examples

```swift

let amount: UInt64 = 16442
let address = "1BazSwJUhyUJkrLQrarRrvw9Bkig7oLrZt"
let changeAddress = "19fXjxXibr12bjzdJKTtAwhaAwQNC5vt8L"

let feePerByte: UInt64 = 22 //Satoshi

let unspentOutputs: [BitcoinUnspentOutput] = [/*unspent outputs*/]

let privateKeys = [/*Private keys for inputs that will be used in the transaction*/]

let settings = BitcoinTransactionSettings.new
   .version(1)
   .allowed(scriptTypes: [.P2PKH])
   .lockTime(0)

do {
    let unspentTransaction = BitcoinTemplateUnspentTransaction<BitcoinTransaction>(amount: amount, addresss: address, changeAddress: changeAddress, utxo: unspentOutputs, isSendAll: false, settings: settings)
    
    let transaction = try unspentTransaction.buildTransaction(feePerByte: feePerByte)
    let signedTransaction = try transaction.sign(keys: privateKeys)
    
    print(signedTransaction)
    
} catch let e as BtcBchCalcuateFeeError {
    //Error
} catch {
    //Error
}

```

# BtcBchFeeCalculator

An object for calculating the commission based on the target quantity for sending and receiving UnspentOutputs

## Initializers

```swift
public init(amount: UInt64, utxo: [BitcoinUnspentOutput], isSendAll: Bool, settings: BitcoinTransactionSettings = .bitcoinDefaults)
```
#### Parameters: 
* **amount** - Amount for spending, in Satoshis
* **utxo** - Set of [_BitcoinUnspentOutput_](#BitcoinUnspentOutput) objects
* **isSendAll** - This flag indicates that the maximum available quantity will be sent

## Methods

Fee calculation for the amount to be sent based on the number of inputs and outputs in the transaction

```swift
public func calculate(with feePerByte: UInt64) throws -> UInt64
```
### Parameters
* **feePerByte** - Satoshi per transaction byte


## Errors
* BtcBchCalcuateFeeError
    * *spendingAmountIsZero* - Unable to parse data into script
    * *availableBalanceTooSmall* - Unable to parse data into script
    
## Usage examples

```swift

let amoun: UInt64 = 16442
let feePerByte: UInt64 = 22 //Satoshi
let unspentOutputs: [BitcoinUnspentOutput] = [/*unspent outputs*/]

let calculator = BtcBchFeeCalculator(amount: amount, utxo: unspentOutputs, isSendAll: false)

do {
    let fee = try calculator.calculate(with: feePerByte)
    print(fee)
    
} catch let e as BtcBchCalcuateFeeError {
    // Error
} catch {
    // Error
}

```
