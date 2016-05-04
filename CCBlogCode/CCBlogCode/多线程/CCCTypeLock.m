//
//  CCCTypeLock.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/03.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCCTypeLock.h"
#import <pthread.h>

@interface CCCTypeLock ()
@property (assign, nonatomic) pthread_mutex_t mutex;
@property (assign, nonatomic) pthread_cond_t cond;
@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) int money;

@end

@implementation CCCTypeLock

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // pthread_mutex 默认常规使用互斥锁存取钱场景线程同步
//    [self moneyPthreadMutexLockScene];
    
    // pthread_mutex 修改锁属性使用互斥锁+递归锁存取钱场景线程同步
//    [self moneyPthreadMutexRecursionLockScene];
    
    // pthread_mutex 配合 pthread_cond 实现互斥锁+条件锁存取钱场景线程同步
//    [self moneyPthreadMutexCondLockScene];
    
    // dispatch_semaphore 实现线程同步
    [self moneyDispatchSemaphoreLockScene];
}


//- (void)mutex1 {
//    // 初始化属性
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
//    // 初始化锁
//    pthread_mutex_t mutex;
//    pthread_mutex_init(&mutex, &attr);
//    // 加锁
//    pthread_mutex_lock(&mutex);
//    // 解锁
//    pthread_mutex_unlock(&mutex);
//    // 销毁锁属性
//    pthread_mutexattr_destroy(&attr);
//    // 销毁锁
//    pthread_mutex_destroy(&mutex);
//
//
//}

- (void)moneyPthreadMutexLockScene {
    self.money = 100;
    // 初始化 pthread_mutex_t 锁对象
     pthread_mutex_init(&_mutex, NULL);
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(3);
            // 加锁
            pthread_mutex_lock(&self->_mutex);
            [self moneySave];
            // 解锁
            pthread_mutex_unlock(&self->_mutex);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(1);
            // 加锁
            pthread_mutex_lock(&self->_mutex);
            [self moneyDraw];
            // 解锁
            pthread_mutex_unlock(&self->_mutex);
        }
    });
}

- (void)moneyPthreadMutexRecursionLockScene {
    self.money = 100;
    // 初始化锁属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化 pthread_mutex_t 锁对象
    pthread_mutex_init(&_mutex, &attr);
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(3);
            [self moneyRecursionSave];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(1);
            // 加锁
            pthread_mutex_lock(&self->_mutex);
            [self moneyDraw];
            // 解锁
            pthread_mutex_unlock(&self->_mutex);
        }
    });
}

- (void)moneyPthreadMutexCondLockScene {
    self.money = 100;
    // 初始化 pthread_mutex_t 锁对象
    pthread_mutex_init(&_mutex, NULL);
    // 初始化条件
    pthread_cond_init(&_cond, NULL);
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(2);
            // 加锁
            pthread_mutex_lock(&self->_mutex);
            // 信号
            if (self.money >= 110 ) {
                pthread_cond_signal(&self->_cond);
//                pthread_cond_broadcast(&self->_cond);
            }
            [self moneySave];
            // 解锁
            pthread_mutex_unlock(&self->_mutex);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(1);
            // 加锁
            pthread_mutex_lock(&self->_mutex);
            if (self.money < 110) {
                pthread_cond_wait(&self->_cond, &self->_mutex);
            }
            [self moneyDraw];
            // 解锁
            pthread_mutex_unlock(&self->_mutex);
        }
    });
}

- (void)moneyDispatchSemaphoreLockScene {
    self.money = 100;
    // 初始化 dispatch_semaphore_t 信号量对象
    self.semaphore = dispatch_semaphore_create(1);
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(3);
            // 信号量此时为 1 执行后 -1 为0，其它线程等待
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            [self moneySave];
            // 信号量此时为0 执行下面方法 +1 为 1，其它线程可执行
            dispatch_semaphore_signal(self.semaphore);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            sleep(1);
            // 信号量此时为 1 执行后 -1 为0，其它线程等待
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            [self moneyDraw];
            // 信号量此时为0 执行下面方法 +1 为 1，其它线程可执行
            dispatch_semaphore_signal(self.semaphore);
        }
    });
}


// 存钱 10 元
- (void)moneySave {
    int oldMoney = self.money;
//    sleep(3);  // 这里睡模拟耗时看不到效果因为互斥锁已经加了，就算这里耗时再长别的线程也得给我等着
    oldMoney += 10;
    self.money = oldMoney;
    NSLog(@"存10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

// 取钱 10 元
- (void)moneyDraw {
    int oldMoney = self.money;
    oldMoney -= 10;
    self.money = oldMoney;
    NSLog(@"取10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

// 第一次存10块送20块 递归锁
- (void)moneyRecursionSave {
    
    // 线程加锁 存10
    pthread_mutex_lock(&self->_mutex);
    int oldMoney = self.money;
    oldMoney += 10;
    self.money = oldMoney;
    NSLog(@"存送10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
    // 存10送20 再调用一次
    static int count = 0;
    if (count < 2) {
        count++;
        [self moneyRecursionSave];
    }
    // 解锁
    pthread_mutex_unlock(&self->_mutex);
}

@end
