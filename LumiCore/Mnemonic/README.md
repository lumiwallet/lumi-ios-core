# Mnemonic

An object for working with mnemonic according to the standard described in [BIP-39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki "BIP-39")

## Initializers

Initializes an object with the given byte set

```swift
public init(entropy: Data, pass: String = "")
```

#### Parameters:
* **entropy** - Initial byte set. It can be 16, 20, 24, 28 or 32 bytes long
* **pass** - Password phrase that is used as a salt to PBKDF2 function

</br>

Initializes an object with an array of mnemonic words   

```swift
public init(words: [String], pass: String = "", listType: Mnemonic.WordListType)
```

#### Parameters:
* **words** - An array of strings with mnemonic words (e.g ["apple", "shadow", "nature"...]). It can be 12, 15, 18, 21 or 24 words long
* **pass** - Password phrase that is used as a salt to PBKDF2 function
* **listType** - Mnemonic words list language (currently only English is available)  

</br>

Initializes an object with a mnemonic phrase

```swift
convenience public init(mnemonic phrase: String, pass: String = "", listType: Mnemonic.WordListType)
```

#### Parameters:
* **mnemonic** - A string with mnemonic words. It may contain 12, 15, 18, 21 or 24 words.
* **pass** - Password phrase that is used as a salt to PBKDF2 function
* **listType** - Mnemonic words list language (currently only English is available)

</br>

Initializes an object of given length with random words

```swift
convenience public init(length: Mnemonic.Length = .ms12)
```

#### Parameters:
* **length** - A mnemonic length parameter. It can be 12, 15, 18, 21 or 24 words long.

## Properties

**words** - Mnemonic words

```swift
public var words: [String]
```

**seed** - A binary seed from the mnemonic

```swift
public var seed: Data
```

## Errors

* MnemonicError:
    * *.wordsError* -  The given word was not found in mnemonic words list
    * *.wordsCountError* - The mnemonic phrase has the wrong number of words (not 12, 15, 18, 21 or 24)
    * *.checksumError*- Checksum calculation error
    * *.generationError* - A random function cannot create a mnemonic phrase with a given length
    * *.bitsLengthError* - The entropy bit length is not equal to any of the given lengths

## Usage examples

### Create an object with a random mnemonic phrase

```swift
do {
    let mnemonic = try Mnemonic() 
    print(mnemonic.words)
    
} catch let e as MnemonicError {
    
} catch {
    
}
```

### Create an object from the given mnemonic phrase

```swift
do {
    let phrase: String = "chicken behind foam door remove attack achieve burden syrup jaguar slogan husband brush owner wealth appear valley find dumb dry upon teach desk swamp"
    
    let mnemonic = try Mnemonic(mnemonic: phrase, pass: "", listType: .english)
    print(mnemonic.words)
    
} catch let e as MnemonicError {

} catch {

}
```
