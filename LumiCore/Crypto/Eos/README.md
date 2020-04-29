#  EosKey

Object for working with EOS private key

## Initializers

```swift
public init(data: Data)
```

#### Parameters:

* **data** - Private key data (should be 32 bytes long)

</br>

```swift
public init(wif: String)
```

#### Parameters:

* **wif** - WIF representation of a private key (Base58 encoded string)

</br>

## Properties

**data** - The private key data

```swift
public let data: Data
```

**wif** - The Wallet Import Format representation of the private key

```swift
public var wif: String
```

## Methods

Get public key

```swift
public func getPublicKey() throws -> EosPublicKey
```

# EosPublicKey 

Object for working with EOS public key

## Initializer

```swift
public init(data: Data)
```

### Parameters: 

* **data** - A public key data. Should be 33 bytes long (compressed public key)

## Properties

**data** - The public key data

```swift
public let data: Data
```

**raw** - A raw representation of the public key with 'EOS' prefix

```swift
public var raw: String
```

## Errors

* EosKeyError
    * *decodeBase58* - Decode Base58 representation key error
    
    * *dataLength* - Wrong length of the key

## Usage examples

### Initialize an EosKey object with private key
```swift
let wif: String = "5HpHagT65TZzG1PH3CSu63k8DbpvD8s5ip4nEB3kEsreAbuatmU"
do {
    let eosKey = try EosKey(wif: wif)
    
} catch let e as EosKeyError {

} catch {

}
```
