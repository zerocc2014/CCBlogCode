//
//  CCDataPacket.h
//  CCBlogCode
//
//  Created by zerocc on 2015/10/16.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCDataPacket : NSObject
+ (NSString *)hexStringFromString:(NSString *)string;
+ (NSString *)lengthHexStringFromHexString:(NSString *)hexString;

+ (NSData *)dataFromHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
