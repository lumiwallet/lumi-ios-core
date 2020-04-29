//
//  Hex2DecimalConverter.h
//  LumiCore
//
//  Copyright © 2020 LUMI WALLET LTD. All rights reserved.
//

#ifndef Hex2DecimalConverter_h
#define Hex2DecimalConverter_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hex2DecimalConverter : NSObject

+ (NSString *)convertToHexStringFromDecimalString:(NSString *)string;
+ (NSString *)convertToDecimalStringFromHexString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END

#endif /* Hex2DecimalConverter_h */
