//
//  Key.h
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

#ifndef Key_h
#define Key_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KeyCompression) {
    CompressedConversion = 1,
    UncompressedConversion = 2
};

typedef NS_ENUM(NSUInteger, KeyType) {
    Public = 1,
    Private = 2
};

@interface Key : NSObject <NSCopying>

@property (nonatomic, readonly, assign) KeyType type;
@property (nonatomic, readonly, nonnull) NSData *data;

- (instancetype)initWithPublicKey:(NSData *)key;
- (instancetype)initWithPrivateKey:(NSData *)key;

- (NSData *)publicKeyCompressed:(KeyCompression)compression;

@end

@interface ExtendedKey : NSObject

@property (nonatomic, readonly, copy, nonnull) Key *key;
@property (nonatomic, readonly, copy, nonnull) NSData *chaincode;

@property (nonatomic, readonly, assign) int depth;
@property (nonatomic, readonly, assign) int parent;
@property (nonatomic, readonly, assign) int sequence;

- (instancetype)initWithSerializedString:(NSString *)string;
- (instancetype)initWithSerializedData:(NSData *)data;
- (instancetype)initWithKey:(Key *)key chaincode:(NSData *)chaincode;
- (instancetype)initWithExtendedKey:(ExtendedKey *)key;

- (NSString *)serializedPub;
- (NSString *)serializedPrv;


- (NSString *)serializedString;
- (NSData *)serializedData;

- (void)derived:(uint32_t)sequence hardened:(BOOL)hardened;

@end

NS_ASSUME_NONNULL_END

#endif /* Key_h */
