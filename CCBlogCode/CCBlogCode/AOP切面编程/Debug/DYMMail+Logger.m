//
//  DYMMail+Logger.m
//  AOPTest
//
//  Created by zerocc on 2019/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "DYMMail+Logger.h"
#import "CCSwizzleMethod.h"

@implementation DYMMail (Logger)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        SEL originalSel = @selector(sendMessage:);
        SEL swizzledSel = @selector(dym_sendMessage:);
        Swizzle_(aClass, originalSel, swizzledSel);
    });
}

- (void)dym_sendMessage:(NSString *)msg {
    [self dym_doSomethingBefore:msg];
    
    NSDate *beginDate = [NSDate date];
    NSTimeInterval beginTime = [beginDate timeIntervalSince1970];
    [self dym_sendMessage:msg];
    
    NSDate *endDate = [NSDate date];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    NSTimeInterval time = endTime - beginTime;
    NSLog(@"time --> %f", time);
    [self dym_doSomethingAfter:msg];
}

- (void)dym_doSomethingBefore:(NSString *)msg {
    NSLog(@"__dym mail send message before, msg length : %ld", msg.length);
}

- (void)dym_doSomethingAfter:(NSString *)msg {
    NSLog(@"__dym mail send message after");
}

@end
