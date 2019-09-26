//
//  URL_Router.h
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^componentBlock) (NSDictionary *param);

@interface URL_Router : NSObject
+ (instancetype)sharedInstance;
- (void)registerURLPattern:(NSString *)urlPattern toHandler:(componentBlock)blk;
- (void)openURL:(NSString *)url withParam:(id)param;

@end

NS_ASSUME_NONNULL_END
