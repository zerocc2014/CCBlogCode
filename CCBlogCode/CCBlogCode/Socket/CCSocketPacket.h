//
//  CCSocketPacket.h
//  CCBlogCode
//
//  Created by zerocc on 2015/10/16.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCSocketPacket : NSObject
+ (NSString *)hexStringFromString:(NSString *)string;
+ (uint16_t)uint16FromBytes:(NSData *)fData;

@end

NS_ASSUME_NONNULL_END
