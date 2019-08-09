//
//  CCNSThreadVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/01.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCNSThreadVC.h"
#include  <pthread.h>

@interface CCNSThreadVC ()

@end

@implementation CCNSThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Pthread
    //    [self testPthread];
    
    // NSThread
    //    [self testNSthread01];
    //    [self testNSthread02];
    [self testNSthread03];
    
    
}

- (void)testPthread {
    // 创建线程——定义一个 pthread_t 类型变量 Thread ID
    pthread_t thread;
    
    
    // 开启线程——执行任务
    /*
     第一个参数 &thread 是线程对象
     第二个和第四个是线程属性，可赋值NULL
     第三个run表示指向函数的指针(run对应函数里是需要在新线程中执行的任务)
     */
    pthread_create(&thread, NULL, pthreadStart, NULL);
}

void *pthreadStart (void *data) {
    NSLog(@"pthreadStart-----%@",[NSThread currentThread]);
    return NULL;
}

// 1. NSThread 线程的创建与启动
- (void)testNSthread01 {
    
    // NSThread 创建线程方式一 需调用 start 方法启动
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(NSthreadMethod) object:nil];
    [thread start];
}

- (void)testNSthread02 {
    
    // NSThread 创建线程方式二  自动启动线程
    [NSThread detachNewThreadSelector:@selector(NSthreadMethod) toTarget:self withObject:nil];
}

- (void)testNSthread03 {
    
    // NSThread 创建线程方式三  NSObject 类的扩展方法 自动启动线程 (线程运行任务可以在后台执行)
    [self performSelectorInBackground:@selector(NSthreadMethod) withObject:nil];
}

// 2. NSThread 线程任务的执行
- (void)NSthreadMethod {
    int a = 0;
    while (![[NSThread currentThread] isCancelled]) {
        NSLog(@"a = %d", a);
        a++;
        
        // 3. 阻塞正在运行的线程
        if (a == 5) {
            // 休眠到指定日期
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3.0]];
            
            // 休眠指定时长
            [NSThread sleepForTimeInterval:2.0];
        }
        
        // 4. 取消线程
        if (a == 10) {
            [[NSThread currentThread] cancel];
            NSLog(@"终止循环");
            
            // 5. 回到主线程
            // 线程间通信方式一
            [self performSelectorOnMainThread:@selector(backToMainThread:) withObject:@"回到主线程刷新UI方式一" waitUntilDone:NO];
            // 线程间通信方式二
            [self performSelector:@selector(backToMainThread:) onThread:[NSThread mainThread] withObject:@"回到主线程刷新UI方式二" waitUntilDone:YES];
            break;
        }
        
    }
}

- (void)backToMainThread:(NSString *)str {
    
    NSLog(@"%@ \n %@",str,[NSThread currentThread]);
}


@end
