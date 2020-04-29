//
//  HashFunctions.h
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

#ifndef HashFunctions_h
#define HashFunctions_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HashFunction : NSObject

+ (nonnull NSData *)keccak256From:(nonnull NSData *)data;
+ (nonnull NSData *)sha256From:(nonnull NSData *)data;
+ (nonnull NSData *)sha256DoubleFrom:(nonnull NSData *)data;
+ (nonnull NSData *)ripemd160From:(nonnull NSData *)data;
+ (nonnull NSData *)ripemd160Sha256From:(nonnull NSData *)data;

@end

NS_ASSUME_NONNULL_END

#endif /* HashFunctions_h */
