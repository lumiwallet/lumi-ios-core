//
//  HashFunctions.m
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

#import "HashFunctions.h"
#import <openssl/ripemd.h>
#import <keccak-tiny.h>
#include <CommonCrypto/CommonCrypto.h>

@implementation HashFunction

+ (nonnull NSData *)keccak256From:(nonnull NSData *)data {
    const uint8_t *input = [data bytes];
    uint8_t output[32];
    memset(output, 0, sizeof(output));
    
    sha3_256(output, 32, input, (size_t)data.length);
    
    return [NSData dataWithBytes:output length:32];
}

+ (nonnull NSData *)ripemd160From:(nonnull NSData *)data {
    unsigned char output[RIPEMD160_DIGEST_LENGTH];
    __block RIPEMD160_CTX ctx;
    RIPEMD160_Init(&ctx);
    
    [data enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        RIPEMD160_Update(&ctx, bytes, byteRange.length);
    }];
    
    RIPEMD160_Final(output, &ctx);
    NSData *hash = [NSData dataWithBytes:output length:sizeof(output)];
    memset(output, 0, sizeof(output));
    return hash;
}

+ (nonnull NSData *)sha256From:(nonnull NSData *)data {
    unsigned char output[CC_SHA256_DIGEST_LENGTH];
    memset(output, 0, CC_SHA256_DIGEST_LENGTH);
    CC_SHA256([data bytes], (CC_LONG)[data length], output);
    
    NSData *hash = [NSData dataWithBytes:output length:CC_SHA256_DIGEST_LENGTH];
    memset(output, 0, sizeof(output));
    return hash;
}

+ (nonnull NSData *)sha256DoubleFrom:(nonnull NSData *)data {
    return [HashFunction sha256From:[HashFunction sha256From:data]];
}

+ (nonnull NSData *)ripemd160Sha256From:(nonnull NSData *)data {
    return  [HashFunction ripemd160From: [HashFunction sha256From:data]];
}

@end
