//
//  CCDataPacket.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/16.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import "CCDataPacket.h"

@implementation CCDataPacket


/**
 普通字符串转 16 进制字符串

 @param string 普通字符串
 @return hexString 16 进制字符串
 */
+ (NSString *)hexStringFromString:(NSString *)string {
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    const Byte *bytes = (Byte *)[myD bytes];
    NSString *hexString = @"";
    for (int i = 0; i < [myD length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if([newHexStr length]==1) {
            hexString = [NSString stringWithFormat:@"%@0%@",hexString,newHexStr];
        }else {
            hexString = [NSString stringWithFormat:@"%@%@",hexString,newHexStr];
        }
    }
    
    return hexString;
}

/**
 计算 16 进制字符串数据长度并取长度低字节长度高字节(奇数个高位补0)组成一个16进制数表示数据长度

 @param hexString 16 进制字符串
 @return lengthHexString 数据域长度 (还是16 进制字符串形式)
 */
+ (NSString *)lengthHexStringFromHexString:(NSString *)hexString {
    unsigned long hexStringLength = hexString.length / 2;
    // HexStrLength 转为16进制
    NSString *lengthHerStr = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1lx",hexStringLength]];
    NSString *lengthHexString = nil;
    NSString *littleStr = [lengthHerStr substringToIndex:(lengthHerStr.length / 2)];
    NSString *bigStr = [lengthHerStr substringFromIndex:(lengthHerStr.length / 2)];
    if ((lengthHerStr.length % 2) == 0) { // 判断数据域长度的16进制数奇偶个 如 a10 ->100a ab01 - 01ab
        lengthHexString = [NSString stringWithFormat:@"%@%@",bigStr,littleStr];
    }else{
        lengthHexString = [NSString stringWithFormat:@"%@0%@",bigStr,littleStr];
    }

    return lengthHexString;
}


@end
