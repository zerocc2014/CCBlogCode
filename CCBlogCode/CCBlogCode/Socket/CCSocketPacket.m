//
//  CCSocketPacket.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/16.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import "CCSocketPacket.h"

@implementation CCSocketPacket



/**
 普通字符串转 16 进制字符串
 
 @param string 普通字符串
 @return hexString 16 进制字符串
 */
+ (NSString *)hexStringFromString:(NSString *)string {
    NSData *strData = [string dataUsingEncoding:NSUTF8StringEncoding];
    const Byte *bytes = (Byte *)[strData bytes];
    NSString *hexString = @"";
    for (int i = 0; i < [strData length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if([newHexStr length]==1) {
            hexString = [NSString stringWithFormat:@"%@0%@",hexString,newHexStr];
        }else {
            hexString = [NSString stringWithFormat:@"%@%@",hexString,newHexStr];
        }
    }
    
    return hexString;
}


+ (NSString *)asciiStringFromHexString:(NSString *)hexString
{
    NSMutableString *asciiString = [[NSMutableString alloc] init];
    const char *bytes = [hexString UTF8String];
    for (NSUInteger i=0; i<hexString.length; i++) {
        [asciiString appendFormat:@"%0.2X", bytes[i]];
    }
    return asciiString;
}

+ (NSString *)hexStringFromASCIIString:(NSString *)asciiString
{
    NSMutableString *hexString = [[NSMutableString alloc] init];
    const char *asciiChars = [asciiString UTF8String];
    for (NSUInteger i=0; i<asciiString.length; i+=2) {
        char hexChar = '\0';
        
        //high
        if (asciiChars[i] >= '0' && asciiChars[i] <= '9') {
            hexChar = (asciiChars[i] - '0') << 4;
        } else if (asciiChars[i] >= 'a' && asciiChars[i] <= 'z') {
            hexChar = (asciiChars[i] - 'a' + 10) << 4;
        } else if (asciiChars[i] >= 'A' && asciiChars[i] <= 'Z') {
            hexChar = (asciiChars[i] - 'A' + 10) << 4;
        }//if
        
        //low
        if (asciiChars[i+1] >= '0' && asciiChars[i+1] <= '9') {
            hexChar += asciiChars[i+1] - '0';
        } else if (asciiChars[i+1] >= 'a' && asciiChars[i+1] <= 'z') {
            hexChar += asciiChars[i+1] - 'a' + 10;
        } else if (asciiChars[i+1] >= 'A' && asciiChars[i+1] <= 'Z') {
            hexChar += asciiChars[i+1] - 'A' + 10;
        }//if
        
        [hexString appendFormat:@"%c", hexChar];
    }
    return hexString;
}

@end
