//
//  CCGCDVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/05/01.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCGCDVC.h"

@interface CCGCDVC ()
@property (nonatomic, strong) UIButton *timerBtn;

@end

@implementation CCGCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    // 计时器按钮
    self.timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timerBtn.frame = CGRectMake(100, 64, 100, 30);
    self.timerBtn.backgroundColor = [UIColor redColor];
    [self.timerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.timerBtn addTarget:self action:@selector(timerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.timerBtn];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self testGCD];
    
    // 一.  dispatch_once （GCD 一次性代码执行）
//    for (int i=0; i<3; i++) {
//        [self disaptchOnce];
//    }
    
    // 二. dispatch_group 测试代码1
//    [self dispatchGroup];
    // dispatch_group 测试代码2
//    [self dispatchGroupEnterAndleave];
    
    // 三. dispatch_after（GCD 延时执行）
//    [self dispatchAfter];
    
    // 四. dispatch_apply（GCD 快速迭代）
//    [self dispatchApply];
    
    // 六. dispatch_barrier_async（GCD 栅栏方法）
//    [self dispatchBarrier];
    
    // 七. dispatch_semaphore（GCD 信号量）
//    [self dispatchSemaphore];
}

- (void)timerBtnClicked:(UIButton *)btn {
    // 五. dispatch_source（GCD 实现定时器）
    [self dispatchSource];
}

- (void)testGCD {
    
    /**
     创建队列
     
     第一个参数： "com.zerocc.testQueue" 队列名 可用于 Instruments 的调试和 CrashLog 查看
     第二个参数： NULL 指定为 NULL 或 DISPATCH_QUEUE_SERIAL,生成 Serial Dispatch Queue (串行队列)；
     指定为 DISPATCH_QUEUE_CONCURRENT，生成 Concurrent Dispatch Queue (并发队列)。
     返回值：    队列，dispatch_queue_t 类型
     */
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.testQueue", DISPATCH_QUEUE_CONCURRENT);
    // 异步执行
    dispatch_async(queue, ^{
        for (int i=0; i<6; ++i) {
            [NSThread sleepForTimeInterval:10];
            NSLog(@"任务1---%@", [NSThread currentThread]);
        }
    });
}

- (void)disaptchOnce {
    NSLog(@"%s", __func__);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"dispatch_once - 执行任务");
    });
}

// GCD 队列组常规使用
- (void)dispatchGroup {
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.group", DISPATCH_QUEUE_CONCURRENT);
    // 1. 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 2. 将队列中的任务添加到队列组 group 中
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:5];
            NSLog(@"任务1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"任务2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"任务3---%@", [NSThread currentThread]);
        }
    });
    
    // 3. 监听到所有队列中任务已完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务123都执行完毕---%@",[NSThread currentThread]);
    });
}

// GCD 队列组 dispatch_group_enter 和 dispatch_group_leave 配合使用
- (void)dispatchGroupEnterAndleave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t group = dispatch_group_create();

    // 队列1任务1添加进 group 中
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:5];
            NSLog(@"任务1---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    // 队列2任务2添加进 group 中
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"任务2---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    // enter 和 leave 一定是成对的，例如任务2中 少了enter则执行完任务2直接走下面block回调，执行完任务1后会出现崩溃；
    // 如果少了leave则执行完任务1和2后不走下面block回调
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务12都执行完毕---%@",[NSThread currentThread]);
    });
}

- (void)dispatchAfter {

    // 主队列中任务3.0秒后延迟执行，这里也可以换成其它队列
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"延迟3.0秒执行---%@",[NSThread currentThread]);
    });
}

- (void)dispatchApply {
    NSLog(@"迭代---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_apply(10, queue, ^(size_t index) {
        [NSThread sleepForTimeInterval:2];
        NSLog(@"迭代%zd---%@",index, [NSThread currentThread]);
    });
    
    NSLog(@"迭代---end");
}

- (void)dispatchSource {
    __block int timeout = 15;
    
    //获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /**
     1. 创建GCD中的定时器,并将定时器的任务交给全局并发队列执行(不会造成主线程阻塞)

     第一个参数: DISPATCH_SOURCE_TYPE_TIMER source的类型 DISPATCH_SOURCE_TYPE_TIMER 表示是定时器
     第二个参数: 0 索引
     第三个参数: 0 描述
     第四个参数: queue 队列
     返回值： timer dispatch_source_t 类型
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 2. 设置定时器(timer 定时器，起始时间，间隔时间，精准度); 1.0 * NSEC_PER_SEC 时间单位为纳秒，设置定时器触发的时间间隔为1s; 0 * NSEC_PER_SEC 精确度 0s
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    // block内部 使用弱引用修饰 避免循环调用
    __weak typeof(self)weakSelf = self;
    weakSelf.timerBtn.userInteractionEnabled = false;
    
    // 3. 设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        timeout--;
        
        if (timeout > 0) {
            // 回到主队列主线程设置 UI
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * title = [NSString stringWithFormat:@"%d秒后重新",timeout];
                [weakSelf.timerBtn setTitle:title forState:UIControlStateNormal];
            });
        }else {
            // 5. 取消定时器
            dispatch_source_cancel(timer);
        }
    });
    
    // 6. 取消定时器回调
    dispatch_source_set_cancel_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.timerBtn.userInteractionEnabled = YES;
            [weakSelf.timerBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        });
        NSLog(@"定时取消");
    });
    
    // 4. 启动定时器
    dispatch_resume(timer);
}

- (void)dispatchBarrier {
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.barrier", DISPATCH_QUEUE_CONCURRENT);
    
    // 任务1
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:3];
            NSLog(@"任务1---%@",[NSThread currentThread]);
        }
    });
    
    // 任务2
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务2---%@",[NSThread currentThread]);
        }
    });
    
    // barrier 分割等待
    dispatch_barrier_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"barrier---%@",[NSThread currentThread]);
        }
    });
    
    // 任务3
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"任务3---%@",[NSThread currentThread]);
        }
    });
}

- (void)dispatchSemaphore {
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.zerocc.semaphore", DISPATCH_QUEUE_CONCURRENT);

    // 1. 初始化信号量值为1
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    // 任务1
    dispatch_async(queue, ^{
        // 2. 判断信号量值, 信号量 > 0 继续执行并且信号量值 -1；信号量 <= 0, 当前线程进入休眠等待状态
        // 这里信号量为0了，所以任务2要等待ing
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [NSThread sleepForTimeInterval:5];
        NSLog(@"任务1---%@",[NSThread currentThread]);
        // 3. 信号量值 +1
        dispatch_semaphore_signal(semaphore);
    });
    
     // 任务2
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        for (int i = 0; i < 3; ++i) {
            [NSThread sleepForTimeInterval:3];
            NSLog(@"任务2---%@",[NSThread currentThread]);
        }
        dispatch_semaphore_signal(semaphore);
    });
    
     // 任务3
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        for (int i = 0; i < 3; ++i) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"任务3---%@",[NSThread currentThread]);
        }
        dispatch_semaphore_signal(semaphore);
    });
}

@end
