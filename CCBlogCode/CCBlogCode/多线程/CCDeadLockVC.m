//
//  CCDeadLockVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/02.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCDeadLockVC.h"

@interface CCDeadLockVC ()
@property (nonatomic, assign) int money;

@end

@implementation CCDeadLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 线程死锁
//    [self syncAndSerialQueue];
//    [self syncAndMainQueue];
    // 线程任务执行顺序
//    [self syncAndOtherSerialQueue];
//    [self syncAndOtherConcurrentQueue];
    
//    [self asyncAndSerialQueue];
//    [self asyncAndConcurrentQueue];
    
    // 线程安全
    [self moneySaveAndDrawScene];
    
}

// 同步执行 + 串行队列 (主线程调用此方法) 死锁
- (void)syncAndSerialQueue {
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.serialQueue",DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"1---%@",[NSThread currentThread]);
    
    dispatch_async(queue,^{ // block块任务 A
        NSLog(@"2---%@",[NSThread currentThread]);
        
       
        dispatch_sync(queue,^{ // block块任务 B
            NSLog(@"3---%@",[NSThread currentThread]);
        });
        
        NSLog(@"4---%@",[NSThread currentThread]);
    });
    
    NSLog(@"5---%@",[NSThread currentThread]);
    // 死锁
}

// 同步执行 + 主队列 (主线程调用此方法) 死锁
- (void)syncAndMainQueue{
    
    NSLog(@"1");
    
    dispatch_sync(dispatch_get_main_queue(),^{ // block块任务 A
        NSLog(@"2");
    });
    
    NSLog(@"3");
    // 死锁
}

// 同步执行 + 另一个串行队列
- (void)syncAndOtherSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.serialQueue",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("com.zerocc.serialQueue3",DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"1---%@",[NSThread currentThread]);
    
    dispatch_async(queue,^{ // block块任务 A
        NSLog(@"2---%@",[NSThread currentThread]);
        
        // 同步执行阻塞当前线程, sync 不具备开启新线程，所以一定是先执行 3 再 4
        dispatch_sync(queue2,^{ // block块任务 B
            sleep(3);
            NSLog(@"3---%@",[NSThread currentThread]);
        });
        
        NSLog(@"4---%@",[NSThread currentThread]);
    });
    
    NSLog(@"5---%@",[NSThread currentThread]);
    // 执行结果 15234
}

- (void)syncAndOtherConcurrentQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.serialQueue",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("com.zerocc.serialQueue3",DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"1---%@",[NSThread currentThread]);
    
    dispatch_async(queue,^{ // block块任务 A
        NSLog(@"2---%@",[NSThread currentThread]);
        
        // 同步执行阻塞当前线程, sync 不具备开启新线程，所以一定是先执行 3 再 4
        dispatch_sync(queue2,^{ // block块任务 B
            sleep(3);
            NSLog(@"3---%@",[NSThread currentThread]);
        });
        
        NSLog(@"4---%@",[NSThread currentThread]);
    });
    
    NSLog(@"5---%@",[NSThread currentThread]);
    // 执行结果 15234
}

// 异步执行 + 串行队列 (主线程调用此方法) 同一队列 FIFO
- (void)asyncAndSerialQueue {
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.serialQueue",DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"1---%@",[NSThread currentThread]);
    
    dispatch_async(queue,^{ // block块任务 A
        NSLog(@"2---%@",[NSThread currentThread]);
        
        // 同一串行队列 FIFO，先执行完任务 A 中的代码再执行B，所以先4 后 3
        dispatch_async(queue,^{ // block块任务 B
            NSLog(@"3---%@",[NSThread currentThread]);
        });
        
        sleep(3);
        NSLog(@"4---%@",[NSThread currentThread]);
    });
    
    NSLog(@"5---%@",[NSThread currentThread]);
    // 执行结果 15243
}

// 异步执行 + 并发队列 (主线程调用此方法) 同一队列 FIFO
- (void)asyncAndConcurrentQueue {
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.serialQueue",DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"1---%@",[NSThread currentThread]);
    
    dispatch_async(queue,^{ // block块任务 A
        NSLog(@"2---%@",[NSThread currentThread]);
        
        // 同一并发队列又是async 会开启新线程， 虽然也FIFO，但是会将任务从并发队列中取出仍到多个线程中执行，所以 3 4就不定了
        dispatch_async(queue,^{ // block块任务 B
            NSLog(@"3---%@",[NSThread currentThread]);
        });
        
        sleep(3);
        NSLog(@"4---%@",[NSThread currentThread]);
    });
    
    NSLog(@"5---%@",[NSThread currentThread]);
    // 执行结果 15234
}

// 存取钱场景示例
- (void)moneySaveAndDrawScene {
    
    self.money = 100;
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.money", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self moneySave];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self moneyDraw];
        }
    });
}

// 存钱 10 元
- (void)moneySave {
    int oldMoney = self.money;
    sleep(1);
    oldMoney += 10;
    self.money = oldMoney;
    
    NSLog(@"存10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

// 取钱 10 元
- (void)moneyDraw {
    int oldMoney = self.money;
    sleep(1);
    oldMoney -= 10;
    self.money = oldMoney;
    
    NSLog(@"取10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

@end
