#  CommonRandom

## Generate method 

Generates the specified number of bytes with random content

```swift
public static func generate(length: Int) -> Data?
```

## Usage example

Notice: for testing random generation algorithm you should install NIST SP 800-22 software with *rbg_install.sh*.

```swift
guard let bytes = CommonRandom.generate(length: 1500000) else {
    print("Random bytes generation error")
    return
}
```

## Testing

For testing generation quality you can install and run [NIST SP 800-22](https://csrc.nist.gov/projects/random-bit-generation/documentation-and-software "NIST SP 800-22")  software. Execute following script: 

```
$ sh path/to/LumiCore/LumiCoreTests/RbgNistSP800-22/rbg_install.sh
```
after, follow the instructions in the  [testRandomBitGeneration()](../../LumiCoreTests/RbgNistSP800-22/RbgNistSP800-22.swift "function") function.
