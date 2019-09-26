//
//  NSObject+KVC.h
//  CCBlogCode
//
//  Created by zerocc on 2016/11/16.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVC)
- (void)KVCSetValue:(nullable id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
