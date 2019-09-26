//
//  CCNSOperationVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/01.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCNSOperationVC.h"

@interface CCNSOperationVC ()

@end

@implementation CCNSOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 1. NSInvocationOperation 实现多线程示例
//    [self InvocationOperation];
    
    // 2. NSBlockOperation 实现多线程示例
//    [self BlockOperation];
    
//    [self OperationQueueMaxConcurrentOperationCount];

    [self OperationBackMainThread];
//    [self OperationAddDependency];
//    [self test];
    
}

- (void)InvocationOperation {
    // 1. 创建操作 NSInvocationOperation
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(executeOperation:) object:@"zeroccOperation"];
    
    // 2. 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 3. 操作加入队列 (加入队列后系统调起执行任务)  操作会在新的线程中
    [queue addOperation:operation];
    
    // 4. 任务完成监听回调
    operation.completionBlock = ^{
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
        }];
        NSLog(@"NSInvocationOperation 任务执行完成");
    };
    
    // 第三步也可以直接我们手动调起操作直接执行，这种情况下任务默认是在当前线程执行不会开启新线程。但是与第三步不能同时使用否则崩溃
//    [operation start];
}

- (void)executeOperation:(id)object {
     NSLog(@" NSInvocationOperation 执行任务---%@：%@",object,[NSThread currentThread]);
}

- (void)BlockOperation {
    // 1. 创建操作 NSBlockOperation 并往操作中添加任务
    // 任务1
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务1---%@",[NSThread currentThread]);
    }];
    
    // 任务2加入到操作中
    [operation addExecutionBlock:^{
        NSLog(@"任务2---%@",[NSThread currentThread]);
    }];

    // 2. 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 3. 操作添加到队列
    [queue addOperation:operation];
    
    // 4. 任务完成监听回调
    operation.completionBlock = ^{
        NSLog(@"NSBlockOperation 任务执行完成");
    };
}

- (void)OperationQueueMaxConcurrentOperationCount{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;

    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        // 任务1加入到操作中
        NSLog(@"任务1---%@",[NSThread currentThread]);
    }];
    // 任务2加入到操作中
    [operation1 addExecutionBlock:^{
        NSLog(@"任务2---%@",[NSThread currentThread]);
    }];
    // 任务3加入到操作中
    [operation1 addExecutionBlock:^{
        NSLog(@"任务3---%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"operation2---%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"operation3---%@",[NSThread currentThread]);
    }];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
}

- (void)OperationBackMainThread {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // 执行耗时操作
        [NSThread sleepForTimeInterval:3];
        NSLog(@"任务1---%@",[NSThread currentThread]);

        // 获取主队列并添加操作
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 刷新 UI 等
            NSLog(@"刷新 UI---%@",[NSThread currentThread]);
        }];
    }];
}

- (void)OperationAddDependency {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"operation1---%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"operation2---%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation3---%@",[NSThread currentThread]);
    }];
    
    // 添加依赖
    // 让operation3 依赖于 operation2，operation2 依赖于 operation1;
    // 尽管是操作1 和 2 都有延迟，其执行顺序也是先operation1->operation2->operation3
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
}

- (void)test {
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务1---%@",[NSThread currentThread]);
    }];
    
    //
    NSOperationQueue *queue = [NSOperationQueue mainQueue];

    //
    [queue addOperation:operation];
    [queue addOperationWithBlock:^{
        // 执行任务
        NSLog(@"任务1---%@",[NSThread currentThread]);
    }];
    
    queue.maxConcurrentOperationCount = 1;
    
    [queue cancelAllOperations];
    [queue setSuspended:YES];
    [queue setSuspended:NO];
}

@end
