//
//  CCSwizzleMethod.m
//  CCBlogCode
//
//  Created by zerocc on 2019/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCSwizzleMethod.h"
#import <objc/runtime.h>

@implementation CCSwizzleMethod
void Swizzle_(Class cls, SEL origSEL, SEL sizSEL) {
    
    Method origMethod = class_getInstanceMethod(cls, origSEL);
    
    Method newMethod = nil;
    if (!origMethod) {
        origMethod = class_getClassMethod(cls, origSEL);
        if (!origMethod) {
            return;
        }
        newMethod = class_getClassMethod(cls, sizSEL);
        if (!newMethod) {
            return;
        }
    }else{
        newMethod = class_getInstanceMethod(cls, sizSEL);
        if (!newMethod) {
            return;
        }
    }
    
    // 自身已经实现了这个方法 就添加不成功，直接交换即可
    if(class_addMethod(cls, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        
        class_replaceMethod(cls, sizSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@end
