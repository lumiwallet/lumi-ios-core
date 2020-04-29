#  KeyGenerator

An object to generate keys according to [BIP-32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) standard

## Initializers

Initializes an object with seed data

```swift
public init(seed: Data)
```

#### Parameters

* **seed** - Seed data

</br>

Initializes an object with serialized extended key

```swift
public init(xpubORxprv: String)
```

#### Parameters

* **xpubORxprv** - Serialized extended public or private key

</br>

Initializes an object with an extended key

```swift
public init(extendedKey: ExtendedKey)
```

* **extendedKey** - Extended key

## Properties

**HMACKey** - BIP32  HMAC key

```swift
static public let HMACKey = "Bitcoin seed"
```

 **generated** - ??

```swift
public var generated: ExtendedKey
```

 **extPrv** - Extended private key for last generated key

```swift
public var extPrv: String
```

 **extPub**- Extended public key for last generated key

```swift
public var extPub: String
```

## Methods

Derives the key for BIP32 derivation path

```swift
public func generate(for path: String)
```

Generates a key at the specified sequence

```swift
public func generate(sequence: UInt32, hardened: Bool)
```

Resets the generator to its initial state. Used if need to change the path.

```swift
public func reset()
```

Generates a child key using the last generated key

```swift
public func generateChild(for sequence: UInt, hardened: Bool) -> ExtendedKey
```

## Errors

* KeyDerivationError
    * *wrongPath* - Invalid BIP32 derivation path
    
## Usage example

```swift
var seed = Data(hex: "000102030405060708090a0b0c0d0e0f")
var generator = KeyGenerator(seed: seed)

do {
    try generator.generate(for: "m/0'/1/2'/2")
    generator.reset()
} catch let e as KeyDerivationError {
    
} catch {
    
}
```
