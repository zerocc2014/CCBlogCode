//
//  UIViewController+LifeCycle.m
//  AOPTest
//
//  Created by zerocc on 2019/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "UIViewController+LifeCycle.h"
#import <objc/runtime.h>
#import "CCSwizzleMethod.h"


@implementation UIViewController (LifeCycle)

#ifdef DEBUG

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        // 进入画页，快速定位当前要修改的页面名字
        Swizzle_(aClass, NSSelectorFromString(@"viewDidAppear:"), @selector(dym_viewDidAppear:));
        // 画页销毁，是否存在不释放现象
        Swizzle_(aClass, NSSelectorFromString(@"dealloc"), @selector(dym_dealloc));
    });
}

#endif

//- (void)dym_viewDidAppear:(BOOL)animated {
//    NSLog(@"load vc --> %@", [self class]);
//    [self dym_viewDidAppear:animated];
//}
//
//- (void)dym_dealloc {
//    NSLog(@"dealloc vc --> %@", [self class]);
//    [self dym_dealloc];
//}

@end
