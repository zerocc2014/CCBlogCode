//
//  Mediator.h
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Mediator : NSObject
+ (UIViewController *)CCAMediatorVC_viewcontroller:(NSString *)parent;
+ (UIViewController *)CCBMediatorVC_viewcontroller:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
