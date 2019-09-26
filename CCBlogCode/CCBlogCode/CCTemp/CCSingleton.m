//
//  CCSingleton.m
//  CCBlogCode
//
//  Created by zerocc on 2015/6/5.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCSingleton.h"

@implementation CCSingleton
+ (instancetype)shareInstance {
    static CCSingleton *_single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _single = [[super allocWithZone:NULL] init];
    });
    return _single;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

@end
