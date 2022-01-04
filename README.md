

[![License](https://img.shields.io/badge/license-MIT-black.svg?style=flat)](https://mit-license.org)
[![Platform](https://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/resources/)
[![Swift](https://img.shields.io/badge/swift-5.0-brightgreen.svg)](https://developer.apple.com/resources/)
[![Version](https://img.shields.io/badge/Version-1.0.2-orange.svg)]()

![lumicore](https://user-images.githubusercontent.com/46525159/78136697-beff3200-742c-11ea-853a-d598444f50f8.png)

# LumiCore

The LumiCore library is an implementation of tools for working with [Bitcoin, BitcoinCash, Ethereum, EOS]. It allows to create and work with mnemonic following the BIP39 standard, to run the private/public keys derivation tree following the BIP32/BIP44 standard and sign transactions. LumiCore is available under the MIT license.

## Requirements

* macOS 10.15.4
* XCode Version 11.4

## Installation

LumiCore can be integrated into your Xcode project using `CocoaPods`. 

1. Install CocoaPods

```
$ gem install cocoapods
```
2. Clone or download repo, add the following line to your `Podfile`

```ruby
# platform :ios, '10.0'

target 'YourTargetName' do
  use_frameworks!
  
  pod 'LumiCore', :path => 'path/to/LumiCore' 
end
```
3. Execute following command

```
$ pod install
```

### Additional

LumiCore contains OpenSSL static libraries. You can build or update them using a [script](LumiCore/Scripts/openssl_update.sh "script"), running it in with the following comand: 

```
$ sh openssl_update.sh
```

## Content
* [Mnemonic](/LumiCore/Mnemonic/README.md)
* [HD Key Generation](LumiCore/Crypto/KeyGeneration/README.md)
* [ECDSA](LumiCore/Signatures/README.md)
* [Random Bytes Generation and NIST SP 800-22 testing](LumiCore/Random/README.md)
* Addresses
    * [Bitcoin Public/Private Key Address](LumiCore/Addresses/BitcoinAddress/README.md)
    * [Ethereum Address](LumiCore/Addresses/EthereumAddress/README.md)
    * [BitcoinCash Address](LumiCore/Addresses/BitcoinCashAddress/README.md)
* Transactions
    * [Bitcoin Transaction](LumiCore/Transactions/Bitcoin+BitcoinCash/README.md)
    * [BitcoinCash Transaction](LumiCore/Transactions/Bitcoin+BitcoinCash/README.md)
    * [Ethereum Transaction](LumiCore/Transactions/Ethereum/README.md)
    * [EOS Transaction](LumiCore/Transactions/Eos/README.md)
* [EOS Key](LumiCore/Crypto/Eos/README.md)


# LumiCoreApp

## Run

To run the test application, you need:
1. Open the LumiCore.xcodeproj project
2. Select a scheme called LumiCoreApp and a run destination, and click the Run button

## Created using
* [_OpenSSL 1.1.1j_](https://github.com/openssl/openssl)
* [_keccak-tiny_](https://github.com/coruus/keccak-tiny)

## License

LumiCore is available under the MIT license. See the [_LICENSE_](LICENSE) file for more info.


