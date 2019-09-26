//
//  DYMMail.m
//  AOPTest
//
//  Created by zerocc on 2019/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "DYMMail.h"

@implementation DYMMail

- (void)sendMessage:(NSString *)msg {
    @autoreleasepool {
        for (NSInteger index = 0; index < 1000; index++) {
            @autoreleasepool {
                NSString *str = [NSString stringWithFormat:@"send message %ld : %@", (index + 1), msg];
                NSLog(@"%@", str);
            }
        }
    }
}

@end
