//
//  EdDSA.h
//  LumiCore
//
//  Copyright © 2021 LUMI WALLET LTD. All rights reserved.
//

#ifndef EdDSA_h
#define EdDSA_h

@interface EdDSA : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (nonnull NSData *)sign:(NSData *)message donnaKey:(NSData *)key;

+ (BOOL)validateDonnaSignature:(NSData *)signature message:(NSData *)message forPublicKey:(NSData *)key;

NS_ASSUME_NONNULL_END

@end

#endif /* EdDSA_h */
