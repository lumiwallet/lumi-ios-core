//
//  Base58Tests.swift
//  LumiCoreTests
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

import XCTest
@testable import LumiCore.Base58
@testable import LumiCore


class Base58Tests: XCTestCase {

    func testBase58EncodeDecode() {
        for (index, element) in TestData.ethereumSampleData.enumerated() {
            autoreleasepool(invoking: {
                let message = Data(hex: element.hash)
                
                let base58encoded = Base58.encode(message)
                
                XCTAssertFalse(base58encoded.isEmpty, "Empty");
                XCTAssertFalse(base58encoded != expectedBase58Strings[index], "Wrong base58. Result: \(base58encoded), Expected: \(expectedBase58Strings[index])")
                
                let base58decoded = Base58.decode(base58encoded)
                XCTAssertFalse(base58decoded.hex != element.hash, "Wrong base58. Result: \(base58decoded.hex), Expected: \(element.hash)")
            })
        }
    }
}

let expectedBase58Strings = [
"J8wtixgTqZsWH94iLVfaWdbsqJtvj8Uk22VipzJhdHcH",
"KvD4PBENRFeTHHnfmKtHUk93fZyJoz81uZtBnS1rRJS",
"3bbimqbMR9F4GCQPkJfb3NouMvizaT375wadS3zumjYj",
"Gbvx4iCg6kEJcL7pwepK3fFZQWRxMVMpHg8QyUkpQEZ5",
"4bjza69r78GWhoDt1tEduDRyuytMc2y6ihUo7fG2m4xE",
"DWHjsBifsVk6uaeqY71zYgmJ7RQUbsmfiu2cL5KoC7AA",
"4qXh9mpdUqW9ErALW6EFWkEBVteZ5gMQbnARutmJ7psj",
"3Cj7tv7zmWJgbU27wRczJGWnaXNn8wSuS7gAyFqfwJGP",
"DTLjKwzRHfZB3j2B5yR8zAkPpQo5uSm3Ga4dYNVjd9xd",
"5rrRxGNNMgLUco99u1S3yZZQecn7peTRcjLaYzY4NtUD",
"4EY1Sj2wmfwppA2SfKKKVKiEih14UnuPvoFwJqm77wf7",
"kA5AJNvSjg47zmUqbHVWyRUXv8wvaL1ScW4FdbsvCdS",
"BKLEYHGDpV1VbC8NFi9m6ah2tHMUTfkp471Sv9PH2qTf",
"HHq5Vg3ezmYyLG1MEvwgVP9XG382idwQhKbnh3F1aQZ5",
"39eJDp8bthtgnfEGRXHhPEgvbp38Q49QkcXxjh2U5hb2",
"GNgu7THXub5nXCbyYLuncd282EkpixjA9xMtMLz91wMP",
"9yQSTQpHXV3Fhjn1Dj5XdCroVjDYz2dg7jSfVvoztuRw",
"6HSEPfsHP2SMtMjAKkKYA5iCcYRVyqJw8ZhSAbSq5LmD",
"8rgJnZFwdQQcLu8PCsXdcVXW1qREZKYBGfEj6KZRx5US",
"HyibUyRKhzWdZ8c6TKUXwNHGw6wX81zDRyrRA4P3Bw7Q",
"EywErPzL5NSsfkDBg245jTyKmj7AcNZtxQfH2yZC77Fj",
"8e24F77eQUsM7Z4FxH96pnYnWwamr7f7NmLCzcP1FR3c",
"NZht4m8nAMsqySHoB9nW1SBQrTLqZmvBqQ7rPS8LoBz",
"Dj6rAVSnyifDh8XQvKTNbaLbceUtCJ5rg1teihhueDu7",
"CZhNphDk2vy5JayQGZU2zHQNHG9yxsJ3H3UTJTvKZpY3",
"CmSkPUaVQTHzDryBAQGC8F2URroMnap4cpLpGX2JaaAF",
"EU4A6vCcL69eBqgHV4G2GN1orZDPgTECrse73ZhtMAah",
"3FQ8EqJhYAZQfiYeXd9YPWP3DsNpKWd3ckNjo3mE6VWj",
"JA6KAb1JAJM4TeTbsq3K2a32D1oEu66PjGCj28S5k1Vd",
"48FubEKt592Fv4a7ffhyUH9aLLWH4v1fEGjMJ1ktXxJT",
"B9Cs3GAvXkYtfLs6JVPG9uiFafyuBmuZ245wbmVtS64m",
"CkEuvGm8yNGy1biiT1PZVp9MbiXSVLQYD2wycm82Gc9s",
"CeznDAk2fhUvZJS8FEmNZxWG8jMRbYsu9wgpWA31oPDb",
"Cx2bwoWxj4a7MXpEoDSy8bVYfUNeWd1Cy4NoLgsjTpvT",
"FRvqUdcJV2sWBfZ8wddT4vJUNLLSN8m6HuzJW5H7T72r",
"2YJDAwsDkiorc3Z5odCCnYVQDfWwGAqCZBktyDSxfc2t",
"D3JTuUzLLpeP6wND556SNkSXfz54SR46JyDmkheAvNx1",
"SkztrP7UoCoy8pVgp2qKp1iGmnBK5kSnCZJwxW9QPBx",
"DYgcYKXBRNBdgmLj4Nfq6WzfkBfwEx8NN6exQqY7ydL6",
"HeBFSNpFpFobCPMyqk4mov9a1BYbVM1XP5u15bKrNbaH",
"7WYSJrF1FD5tYWeapaTBfqoyRhYHKVwbJmuq9Dj1Gxux",
"6Df8MiExAEV951E5NmEQrYKNmEkXNdbDngV2s1s8EPyB",
"5dcRb7hoViyV3bY4eRhSKHiEgu9sLMsmMG31iuMMR5bG",
"BJwsBykPAMVFx9Wc5bmFQNuhPE26J5bgJJ7XCHN7fmBm",
"AZC7tXMxU8mnZqCAkJfEDVQwoSaViM4WyAJhE7iD8tVA",
"8chFfNq4ox6LJfkab3iZ5VvCeKEW5N1vm5pNtdcSnMHx",
"FyYKWqFJhBcCQbQSgLSuq7qDZbtYfT82CuVZwoHjZ5ng",
"CQp1HHrrkXnL3PTUMAcnDbNvPbYRuxnuxZNd3tYn3he5",
"6KkD8tV3NrXwXrVXKBq4K1q7tA1HgwPMmxUBDXKTVnuE",
"DU7cWCYcK69iDbR5kdozqH1HfJ4dkt7zLU7oUd6mgxUX",
"7NtEkfwbaYzht5f7svK663eqBb7SyFys6DFVtFKEYntd",
"A9CGqXvhkjTrwnrTx3N8FQSpB6NnGaxebNTZC5cv5rrn",
"GBkyMJLwXpncDHLBZ46ucTmhLZLR3FnS6vQyAJnjCh89",
"8igmt5mNaaJjPo13py72bCDyTHqXwMLd5yQJ3CjU9vxz",
"AWofRjPt4a1QrCRNeYL9KovnyeTGFo1j6vnESMh2k1cH",
"2s3hUY8K9SnwS4xzczHshTWmhJvYBN9SpNCRAUoeCfX5",
"DzoZYxBBeK8aWBNJZCvWW7CY8FWEQfzWiMh1HcDnCPAr",
"JCyAEVmUB2GihLdw2679kLvhH8YWCK5WJJMjTruHVaTG",
"4Cjg1w9fnYCoP6rbgVJWYe1wfXvMk2TpeAoHXz2LG9zK",
"DSYtadZF9eGricEDDcm1Dq1rFJfZJXhP9FVDvp1wMoNe",]
