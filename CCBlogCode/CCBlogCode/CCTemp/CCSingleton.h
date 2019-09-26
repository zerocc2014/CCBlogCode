//
//  CCSingleton.h
//  CCBlogCode
//
//  Created by zerocc on 2015/6/5.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCSingleton : NSObject<NSCopying,NSMutableCopying>
+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
