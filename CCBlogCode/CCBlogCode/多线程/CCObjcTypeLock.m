//
//  CCObjcTypeLock.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/03.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCObjcTypeLock.h"

@interface CCObjcTypeLock ()
@property (nonatomic, assign) int money;
@property (strong, nonatomic) NSLock *lock;
@property (nonatomic, strong) NSRecursiveLock *recursiveLock;
@property (strong, nonatomic) NSCondition *condition;
@property (strong, nonatomic) NSConditionLock *conditionLock;


@end

@implementation CCObjcTypeLock

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self moneySynchronizedScene];
}

// 存取钱场景示例
- (void)moneyLockScene {
    self.money = 100;
    self.lock = [[NSLock alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(3);
            [self.lock lock];
            [self moneySave];
            [self.lock unlock];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(1);
            [self.lock lock];
            [self moneyDraw];
            [self.lock unlock];
        }
    });
}

- (void)moneySynchronizedScene {
    self.money = 100;
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(3);
            @synchronized(self) {
                [self moneySave];
            }

        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(1);
            @synchronized(self) {
                [self moneyDraw];
            }
        }
    });
}

- (void)moneySave {
    int oldMoney = self.money;
    oldMoney += 10;
    self.money = oldMoney;
    
    NSLog(@"存10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

- (void)moneyDraw {
    int oldMoney = self.money;
    oldMoney -= 10;
    self.money = oldMoney;
    
    NSLog(@"取10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

@end
