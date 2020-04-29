#  EthereumAddress

## Initializer

```swift
public init(data: Data)
```

### Parameters:
* **data** - Uncompressed public key data

## Properties

**address** - Hexadecimal representation of the public key

```swift
public var address: String
```

**formattedAddress** - Hexadecimal representation of the public key with '0x' prefix

```swift
public var formattedAddress: String
```
## Errors
* EthereumCreateAddressError:
    * *.invalidPublicKeyDataLength* -  Invalid public key length

## Usage example

### Initialize an EthereumAddress object with public key
```swift
let keyString: String = "04e10667e02525d16bdad8a62ad6c3adbb5a5c8f2c6a18d6e5bd6d7a7ffd85641ac7c1baf36ee9c11a730c90a18626d451ff64171ec270afa6ae4ceb075cee4eaa"
do {
    let key: Data = Data(hex: keyString)
    let ethereumAddress = try EthereumAddress(data: key)
} catch let e as EthereumCreateAddressError {

} catch {

}
```
