#  ECDSAfunctions

## Methods

ECDSA signing

```swift
public static func sign(target: CoinSignTarget, data: Data, key: Data, recid: inout Int) -> Data
```

#### Parameters

* **target** - Target coin, determines what nonce function and signature serialize type will be used

* **data** - Input message (32 bytes long hash expected)

* **key** - Private key

* **recid** - Inout variable for storing recovery identifier

</br>

ECDSA signature validation

```swift
public static func validate(signature: Data, data: Data, for key: Data, type: SignOutputType) -> Bool
```

#### Parameters

* **signature** - Signature data

* **data** - Message that was signed

* **key** - Private key used for signing

* **type** - Signature serialization type

</br>

Recovering public key data from a signature

```swift
public static func recoveryPublicKey(from signature: Data, hash: Data, compression: PublickKeyCompressionType) -> Data?
```

#### Parameters

* **signature** - Signature data

* **hash** - Message that was signed

* **compression** - Public key point conversion type (Compressed/Uncompressed)

## CoinSignTarget

Enum with available target coins

### Cases

1. bitcoin (also uses for Bitcoin Cash)
2. ethereum
3. eos

## Usage example

```swift
let hash = Data(hex: "fe9fcf4bb778de52d36b684925e099a447628a13cd261ccac1486022fcb2b0be")
let privateKey = Data(hex: "776c223f2851c0bd0507ebd4b0619a61ae5f13fdc49cf234bd6d4a1032f3fdb0")
var id: Int = 0

let signature = ECDSAfunctions.sign(target: .bitcoin, data: hash, key: privateKey, recid: &id)
print(ECDSAfunctions.validate(signature: signature, data: hash, for: privateKey, type: .DER))
```
