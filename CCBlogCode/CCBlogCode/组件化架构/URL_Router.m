//
//  URL_Router.m
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "URL_Router.h"


@interface URL_Router ()
@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation URL_Router
+ (instancetype)sharedInstance {
    static URL_Router *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[URL_Router alloc] init];
    });
    return router;
}

- (NSMutableDictionary *)cache{
    if (!_cache) {
        _cache = [NSMutableDictionary new];
    }
    return _cache;
}
- (void)registerURLPattern:(NSString *)urlPattern toHandler:(componentBlock)blk {
    [self.cache setObject:blk forKey:urlPattern];
}

- (void)openURL:(NSString *)url withParam:(id)param {
    componentBlock blk = [self.cache objectForKey:url];
    if (blk) blk(param);
}

@end
