//
//  NSObject+KVO.h
//  CCBlogCode
//
//  Created by zerocc on 2016/11/18.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)
// 添加观察者
- (void)cc_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

// 删除观察者
- (void)cc_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
