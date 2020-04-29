//
//  Strings.swift
//  LumiCoreApp
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import Foundation

public struct ImageName {
    static let logo = "Logo"
    static let logoAboutScreen = "LogoAbout"
    static let navigationBackButton = "NavigationArrowLeft"
}

public struct NavigationBarTitleText {
    static let main = ""
    static let mnemonicInfo = "Mnemonic"
    static let bitcoinTransactionInfo = "Bitcoin"
    static let bitcoinCashTransactionInfo = "BitcoinCash"
    static let bitcoinAddInput = "Add input"
    static let bitcoinAddOutput = "Add output"
    static let ethereumTransactionInfo = "Ethereum"
    static let eosTransactionInfo = "EOS"
    static let about = "About"
}

// MARK: - MainView text

public struct MainViewText {
    
    public struct Titles {
        static let mnemonicPhrase = "Mnemonic phrase"
        static let createTransaction = "Create transaction manually"
    }
    
    public struct MenuItems {
        static let createMnemonic = "Create a new mnemonic"
        static let importMnemonic = "Import your mnemonic"
        static let bitcoinTransaction = "BTC transaction"
        static let bitcoinCashTransaction = "BCH transaction"
        static let ethereumTransaction = "ETH transaction"
        static let eosTransaction = "EOS transaction"
        static let aboutLumi = "About Lumi"
    }
}


// MARK: - PickerView text

public struct MnemonicPickerViewText {
    static let title = "Mnemonic words count"
    static let buttonText = "Done"
}


// MARK: - InputPhraseView text

public struct MnemonicInputPhraseViewText {
    static let title = "Enter mnemonic phrase"
    static let buttonTitle = "Import"
}


// MARK: - MnemonicInfoView text

public struct MnemonicInfoViewText {
    static let mnemonicPhraseTitle = "Mnemonic phrase"
    static let seedRepresentationTitle = "Seed hex representation"
    static let bip32title = "Bip32 path"
    static let masterPrivateTitle = "Master xprv"
    static let rangeTitle = "Keys in range"
    static let bip32button = "generate"
    static let rangeButton = "set"
    
    struct KeyInfo {
        static let sequnceTitle = "Sequence:"
        static let addressesTitle = "Addresses:"
        static let btcAddress = "btc:"
        static let bchAddress = "bch:"
        static let ethAddress = "eth:"
        static let keysTitle = "Keys:"
        static let xpub = "xpub:"
        static let xprv = "xprv:"
        static let pubData = "pub:"
        static let prvData = "wif:"
    }
}


// MARK: - BitcoinTransactionInfoView text

public struct BitcoinTransactionText {
    static var addInputButton = "Add inputs"
    static var addOutputButton = "Add output"
    
    static var inputsTitle = "Inputs"
    static var ouputsTitle = "Outputs"
    
    static var legacyBitcoinAddressChangeTitle = "Legacy bitcoin address for change"
    static var bitcoinAddressPlaceholder = "BTC address"
    static var feePerByteTitle = "Fee per byte"
    
    static var buttonBuild = "Build"
    
    public struct Input {
        static var bitcoinAddressTitle = "Legacy bitcoin address"
        static var bitcoinAddressPlaceholder = "Enter bitcoin address"
        static var amountTitle = "Amount in satoshi"
        static var outputTitle = "Output N"
        static var scriptTitle = "Script data (hex)"
        static var scriptPlaceholder = "Enter hex"
        static var transactionHashTitle = "Transaction hash"
        static var transactionHashPlaceholder = "Enter hash"
        static var privateKeyTitle = "Private key (WIF)"
        static var privateKeyPlaceholder = "Enter private key"
    }
    
    public struct InputInfo {
        static let valueTitle = "Value"
        static let addressTitle = "Address"
        static let scriptTitle = "Script"
        static let hashTitle = "Hash"
        static let wifTitle = "WIF"
    }
    
    public struct Output {
        static var addressTitle = "Legacy bitcoin address"
        static var amountTitle = "Amount in satoshi"
    }
    
    struct OutputInfo {
        static let valueTitle = "Value"
        static let addressTitle = "Address"
    }
    
    public struct Result {
        static let hashTitle = "Hash:"
        static let rawTitle = "Raw:"
        static let descriptionTitle = "Description"
    }
}


// MARK: - EthereumTransactionInfoView text

public struct EthereumTransactionText {
    static var addressTitle = "Ethereum address"
    static var addressPlaceholder = "0x..."
    static var amountTitle = "Amount"
    static var gasPriceTitle = "Gas price"
    static var gasLimitTitle = "Gas limit"
    static var nonceTitle = "Nonce"
    static var chainTitle = "Chain"
    static var dataTitle = "Data"
    static var dataPlaceholder = "Hex data"
    static var privateKeyTitle = "Private key (HEX)"
    static var privateKeyPlaceholder = "Enter private key"
    
    struct Result {
        static let rawTitle = "Raw:"
        static let descriptionTitle = "Description:"
    }
}


// MARK: - EosTransactionInfoView text

public struct EosTransactionText {
    static let addressTitle = "Address"
    static let addressPlaceholder = "EOS account"
    static let amountTitle = "Amount"
    static let amountPlaceholder = "Amount"
    static let memoTitle = "Memo"
    static let memoPlaceholder = "Message"
    static let actorTitle = "Actor"
    static let actorPlaceholder = "Actor"
    static let permissionTitle = "Permission"
    static let permissionPlaceholder = "Permission"
    static let expirationTitle = "Expiration"
    static let expirationPlaceholder = "Expiration"
    static let binTitle = "Bin"
    static let binPlaceholder = "ABI bin"
    static let referenceBlockPrefixTitle = "Reference block prefix"
    static let referenceBlockPrefixPlaceholder = "EOS block prefix"
    static let referenceBlockNumTitle = "Reference block num"
    static let referenceBlockNumPlaceholder = "EOS block number"
    static let chainTitle = "Chain ID"
    static let chainPlaceholder = "EOS chain id"
    static let privateKeyTitle = "WIF private key"
    static let privateKeyPlaceholder = "WIF private key"
    
    struct Result {
        static let transactionDataTitle = "Packed transaction:"
        static let signaturesTitle = "Signatures:"
    }
}


// MARK: - AboutView text

struct AboutText {
    static let lumiWalletTitle = "Lumi Wallet"
    static let openSourceAppTitle = "Open source app"
    static let aboutAppTitle = "About the app"
    static let aboutAppBodyText = "The LumiCore library is an implementation of tools for working with Bitcoin, BitcoinCash, Ethereum, EOS. It allows to run the private keys derivation tree following the BIP44 standard and sign transactions. LumiCore is available under the MIT license."
    static let websiteTitle = "Our website"
    static let websiteButton = "lumiwallet.com"
    static let websiteLink = "https://lumiwallet.com"
    static let mailTitle = "Drop us a line"
    static let mailButton = "hello@lumiwallet.com"
    static let mailLink = "mailto:hello@lumiwallet.com"
    static let copyright = "© 2020 LUMI WALLET LTD"
}


// MARK: - Error descriptions

struct ErrorText {
    static let title = "ERROR"
}

struct MnemonicErrorDescription {
    static let mnemonicPhraseError = "Wrong mnemonic phrase"
    static let mnemonicWordsCountError = "Wrong words count"
    static let mnemonicCreateError = "Failed to create mnemonic"
    static let mnemonicEntropyError = "Wrong entropy bytes length"
    static let mnemonicChecksumError = "Wrong mnemonic checksum"
    static let generateBIP32pathError = "Invalid BIP-32 path"
    static let unknownError = "Unknown error"
}


struct BitcoinErrorDescription {
    static let amountValueError = "Wrong amount value"
    static let outputNumberValueError = "Wrong output number value"
    static let createInputError = "Failed to create bitcoin/bitcoincash input"
    static let outputAddressError = "Wrong output address string"
    static let bitcoinAddressVersionError = "Wrong Bitcoin address version"
    static let bitcoinWIFAddressVersionError = "Wrong WIF address version"
    static let bitcoinWIFAddressLengthError = "Wrong WIF address"
    static let bitcoinAddressDataLengthError = "Wrong Bitcoin address data length"
    static let bitcoinAddressHashLengthError = "Wrong Bitcoin address hash length"
    static let keyTypeError = "Wrong EC key type"
    static let createTransactionPrivateKeyError = "Can't find appropriate private key for signing input"
    static let createTransactionSigningError = "Failed to signing transaction"
    static let unknownError = "Unknown error"
}


struct EthereumErrorDescription {
    static let ethereumAddressError = "Wrong ethereum address"
    static let nonceError = "Wrong nonce value"
    static let chainError = "Wrong chain value"
    static let privateKeyDataError = "Incorrect private key data"
    static let signingTransactionError = "Failed to signing transaction"
}


struct EosErrorDescription {
    static let referenceBlockNumError = "Incorrect referenceBlockNum"
    static let referenceBloclPrefixError = "Incorrect referenceBlockPrefix"
    static let privateKeyDataError = "Wrong private key data"
    static let eosKeyDataError = "Wrong data length"
    static let eosBase58DecodeError = "Failed to decode input string"
    static let signingTransactitonError = "Failed to signing transaction"
    static let unknownError = "Unknown error"
}
