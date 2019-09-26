//
//  NSArray+CCBounds.m
//  CCBlogCode
//
//  Created by zerocc on 2019/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "NSArray+CCBounds.h"
#import "CCSwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSArray (CCBounds)
+ (void)load {
    Class aClass = objc_getClass("__NSArrayI");
    SEL originalSel = @selector(objectAtIndexedSubscript:);
    SEL swizzledSel = @selector(dym_objectAtIndexedSubscript:);
    Swizzle_(aClass, originalSel, swizzledSel);
}

- (id)dym_objectAtIndexedSubscript:(NSUInteger)index {
    @try {
        return [self dym_objectAtIndexedSubscript:index];
    } @catch (NSException *exception) {
        NSLog(@"数组越界");
        return nil;
    }
}

@end
