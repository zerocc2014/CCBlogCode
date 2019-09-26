//
//  Mediator.m
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "Mediator.h"

@implementation Mediator
+ (UIViewController *)CCAMediatorVC_viewcontroller:(NSString *)parent {
    Class cls = NSClassFromString(@"CCAMediatorVC");
    return  [cls performSelector:NSSelectorFromString(@"a_VC_detailViewController:") withObject:@{@"parent":parent}];
    
}

+ (UIViewController *)CCBMediatorVC_viewcontroller:(NSInteger)type{
    Class cls = NSClassFromString(@"CCBMediatorVC");
    return [cls performSelector:NSSelectorFromString(@"b_VC_detailViewController:") withObject:@{@"type":@(33)}];
}

@end
