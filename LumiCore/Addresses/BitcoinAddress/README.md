# BitcoinPublicKeyAddress 

## **Initializers**

Initializes an object with public key

```swift
public init(publicKey: Data, type: PublicKeyAddressHashType = .bitcoin(.P2PKH))
```

#### Parameters:
* **publicKey** - Public key data. Must be 33 bytes long (compressed public key)
* **type** - Hash type of the public key address (P2PKH, P2SH, P2WPKH, P2WSH)

</br>

Initialize with Key object

```swift
public init(key: Key, type: PublicKeyAddressHashType = .bitcoin(.P2PKH))
```
#### Parameters:
* **key** - Public or private type Key
* **type** - Hash type of the public key address (P2PKH, P2SH, P2WPKH, P2WSH)

</br>

Initializes an object with the public key hash or script hash data

```swift
public init(data: Data)
```

#### Parameters:
* **data** - The public key hash or script hash data (with version byte in prefix)

</br>

Initializes an object with bitcoin address

```swift
public init(string: String)
```

#### Parameters:
* **string** - BC1 or Base58 bitcoin address string

</br>

Initializes an object with base58 representation of legacy or script hash bitcoin address

```swift
public init(base58: String)
```

#### Parameters:
* **base58** - Legacy or script hash bitcoin address

</br>

Initialize an object with a bech32 representation of legacy or script hash bitcoin address

```swift
public init(bech32: String)
```

#### Parameters:
* **bech32** - BC1 bitcoin address string


## **Properties**

**hashType** - Bitcoin address hash type (P2PKH, P2SH, P2WPKH, P2WSH)

```swift 
public let hashType: PublicKeyAddressHashType
```

**address** - Bitcoin address

```swift
public let address: String
```

**publicKeyHash** - Data representation of public key

```swift
public var publicKeyHash: Data
```


# BitcoinPrivateKeyAddress 

## **Initializers**

Initializes an object with private key data

```swift
public init(privateKeyData: Data, version: UInt8 = CoinVersionBytesConstant.bitcoin_prvkey_version)
```

#### Parameters:
* **privateKeyData** - Private key data (must be 32 bytes long)
* **version** - Version

</br>

Initialize with Key object

```swift
public init(key: Key, version: UInt8 = CoinVersionBytesConstant.bitcoin_prvkey_version)
```

#### Parameters:

* **key** - Private type Key
* **version** - Version

## **Properties**

**wif** - The Wallet Import Format representation of the legacy address

```swift
public let wif: String
```

## Errors
* BitcoinCreateAddressError:
    * *.invalidDataLength* -  The input data length is invalid

    * *.invalidHashDataLength* -  The input hash data length is invalid

    * *.invalidKeyType* -  Wrong input Key type

    * *.invalidAddressVersion* -  Wrong address version

    * *.invalidWIFAddressVersion* - Wrong WIF address version
    
    * *.invalidWIFAddressLength* - The input WIF address data length is invalid

## Usage examples

### Initialize a BitcoinPublicKeyAddress object with public key data

```swift
let publicKeyHex: String = "023bb2a1107059704e232d2ce9231d545be591fe0b66f0fddb66fd31f232192f39"
do {
    let data: Data = Data(hex: publicKeyHex)
    let btcAddress = try BitcoinPublicKeyAddress(publicKey: data, type: .bitcoin(.P2PKH))
    
    print(btcAddress.address)
} catch let e as BitcoinCreateAddressError {
   
} catch {
   
}
```

### Initialize a BitcoinPrivateKeyAddress object with private key data

```swift
let privateKeyHex: String = "dbe336a640d8b0bb67bd87e175bb18a13942b9aaaeea28bdfa62c076df844c38"
do {
    let data: Data = Data(hex: privateKeyHex)
    let btcAddress = try BitcoinPrivateKeyAddress(privateKeyData: data)
    
     print(btcAddress.wif)
} catch let e as BitcoinCreateAddressError {
   
} catch {
   
}
```

