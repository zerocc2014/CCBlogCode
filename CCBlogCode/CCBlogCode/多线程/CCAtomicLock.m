//
//  CCAtomicLock.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/03.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCAtomicLock.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>

@interface CCAtomicLock ()
@property (nonatomic, assign) int money;
@property (assign, nonatomic) OSSpinLock moneyOSSpinLock;
@property (assign, nonatomic) os_unfair_lock moneyOSUnfairLock;

@end

@implementation CCAtomicLock

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self moneyOSSpinLockLockScene];
    [self moneyOsUnfairLockScene];
}


// OSSpinLock 存取钱场景线程同步
- (void)moneyOSSpinLockLockScene {
    self.money = 100;
    // 初始化 OSSpinLock
    self.moneyOSSpinLock = OS_SPINLOCK_INIT;
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            // 加锁
            OSSpinLockLock(&_moneyOSSpinLock);
            [self moneySave];
            // 解锁
            OSSpinLockUnlock(&_moneyOSSpinLock);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            // 加锁
            OSSpinLockLock(&_moneyOSSpinLock);
            [self moneyDraw];
            // 解锁
            OSSpinLockUnlock(&_moneyOSSpinLock);
        }
    });
}

// os_unfair_lock 存取钱场景线程同步
- (void)moneyOsUnfairLockScene {
    self.money = 100;
    self.moneyOSUnfairLock = OS_UNFAIR_LOCK_INIT;
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            os_unfair_lock_lock(&_moneyOSUnfairLock);
            [self moneySave];
            os_unfair_lock_unlock(&_moneyOSUnfairLock);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            os_unfair_lock_lock(&_moneyOSUnfairLock);
            [self moneyDraw];
            os_unfair_lock_unlock(&_moneyOSUnfairLock);
        }
    });
}


// 存钱 10 元
- (void)moneySave {
    int oldMoney = self.money;
    sleep(3);
    oldMoney += 10;
    self.money = oldMoney;
    NSLog(@"存10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

// 取钱 10 元
- (void)moneyDraw {
    int oldMoney = self.money;
    sleep(3);
    oldMoney -= 10;
    self.money = oldMoney;
    NSLog(@"取10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

@end
