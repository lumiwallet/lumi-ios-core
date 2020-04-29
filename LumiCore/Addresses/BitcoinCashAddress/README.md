#  BitcoinCashAddress

## Initializers

Initializes an object with public key

```swift
public init(data: Data)
```

#### Parameters:
* **data** - Public key data (must be 33 bytes long)

---

Initializes an object with a bitcoin legacy address

```swift
public init(legacy: String)
```

#### Parameters:
* **legacy** - A legacy bitcoin address

---

Initializes an object with a Bitcoin Cash address in CashAddress format

```swift
public init(cashaddress: String)
```

#### Parameters:
* **cashaddress** - Bitcoin Cash address in CashAddress format

## Properties

**address** - Address in CashAddress format without 'bitcoincash' prefix

```swift
public var address: String
```

**formattedAddress** - Address in CashAddress format with 'bitcoincash' prefix

```swift
public var formattedAddress: String
```

**legacyAddress** - Bitcoin legacy address

```swift
public let legacyAddress: String
```

## Errors
* BitcoinCreateAddressError:
    * *.invalidDataLength* -  The input data length is invalid

    * *.invalidHashDataLength* -  The input hash data length is invalid

    * *.invalidKeyType* -  Wrong input Key type

    * *.invalidAddressVersion* -  Wrong address version

## Usage examples

### Initialize an object with an address in CashAddress format

```swift
do {
    let cashAddress: String = "bitcoincash:qzsepqzhqnt3k9pn8c0w2hv4rnzm3l6x7540gsuafn"
    let bitcoinCashAddress = try BitcoinCashAddress(cashaddress: cashAddress)
} catch let e as BitcoinCreateAddressError {

} catch {

}
```

