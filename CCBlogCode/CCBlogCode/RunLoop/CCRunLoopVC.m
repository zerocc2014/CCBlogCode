//
//  CCRunLoopVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/5/29.
//  Copyright © 2017年 zerocc. All rights reserved.
//

#import "CCRunLoopVC.h"
#import "CCThread.h"

#import "CCTableVC.h"
#import "CCTestTableVC.h"

@interface CCRunLoopVC ()
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) UILabel *myTipLabel;
@property (nonatomic, strong) UIView *aview;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) CCThread *thread;
@property (nonatomic, assign) BOOL finised;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSTimer *time;


@end

@implementation CCRunLoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听RunLoop状态
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopOberverCallBack, &context);
    if (observer) {
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    }
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerCallBack:) userInfo:nil repeats:YES];
    
    //增加这行代码，则timer不受滑动tableview影响，没有这行代码则滑动tableview时定时器暂停
    //    CFRunLoopAddTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)_myTimer, kCFRunLoopCommonModes);
    
    _myTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 50, 30)];
    _myTipLabel.backgroundColor = [UIColor grayColor];
    _myTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_myTipLabel];
    
    _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    _myTable.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_myTable];
}

- (void)timerCallBack:(NSTimer *)timer {
    static int flag = 0;
    _myTipLabel.text = @(flag++).stringValue;
}

void runLoopOberverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"进入RunLoop ，Mode:%@",(__bridge_transfer NSString*)CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()));
            break;
        case kCFRunLoopExit:
            NSLog(@"退出RunLoop ，Mode:%@",(__bridge_transfer NSString*)CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()));
            break;
        default:
            break;
    }
}


- (void)test1 {
    
    // 创建一个时钟
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    // dispatch_get_global_queue(0, 0) 第一个参数 优先级 第二个参数 苹果预留的参数
    //
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{ // 子线程
    //        // 子线程特点：异步销毁
    //        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    //        self.time = timer;
    //        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    //
    //
    //        CCThread *thread = [CCThread currentThread]; // 这只是一个类的多态，只是 NSThread类 的多种形态，并不会走delloc 还是走NSThread的方法
    //
    ////        NSLog(@"来了。。%@",[NSThread currentThread]);
    //        NSLog(@"%@aaa",thread);
    //
    //    });
    
    //
    //    CCThread *thread = [[CCThread alloc] initWithBlock:^{ // 创建一个子线程
    //        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    //        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //
    //        NSLog(@"来了。。%@",[NSThread currentThread]);
    //
    //    }];
    //
    //    [thread start];
    
    // 如何让子线程不挂？线程常驻。这里全局强引用保活这个CCThread也是不行的，为什么呢？多线程种thread 是CCThread 是NSThread 它只是一个oc对象，并不是真的执行代码的线程，它只是苹果封装好让你操作线程的oc对象，对象没有挂没有用，在cpu的调度池里面有一个叫多线程(线程池)这样的一个对象，我们根本操作不了它，oc对象只是一个对象并不能真正的代表线程，我们只能通过NSThread去操作它，oc对象没有销毁self.thread,但是线程池中已经没有这个线程了，所以你重新启动start 会崩溃，reason: '*** -[CCThread start]: attempt to start the thread again'
    
    
    // 多线程
    // 每一条线程独有一个runloop
    // 主线程为什么不会挂？会常驻，因为其上的runloop正在run
    // 子线程上的runloop默认不启动，所以子线程只要一执行完代码就挂掉了，要保证子线程不挂就让其runloop run起来
    //    self.thread = [[CCThread alloc] initWithBlock:^{ // 和gcd 写法是一样的，创建一个子线程
    //        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    //        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // default模式下也还是可以的，因为拖拽ui事件是将主线程的runloop切换到UITraking 模式下，但是time事件是在子线程的runloop下得default模式下的事情，相互没有干扰
    //
    //        NSLog(@"来了。。%@",[NSThread currentThread]);
    //
    //        // 子线程保活
    //        [[NSRunLoop currentRunLoop] run];
    //        NSLog(@"come here"); // 这行能执行吗？不会执行为什么呢？因为上面是一个死循环就停在上面的run，只是在这个子线程中循环并不能影响主线程，但是这也也是不合理，我们要如何干掉这个子线程呢？
    
    //
    //    }];
    //
    //    [_thread start];
    
    //    CCThread *thread = [[CCThread alloc] initWithBlock:^{ // 和gcd 写法是一样的，创建一个子线程
    //        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    //        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // default模式下也还是可以的，因为拖拽ui事件是将主线程的runloop切换到UITraking 模式下，但是time事件是在子线程的runloop下得default模式下的事情，相互没有干扰
    //
    //        NSLog(@"来了。。%@",[NSThread currentThread]);
    //
    //        // 子线程保活
    ////        [[NSRunLoop currentRunLoop] run];
    //
    //        while (!_finised) {
    //            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; // 循环0.1 秒
    //        }
    //        NSLog(@"这个子线程销毁啦"); // 这样就会销毁同时也会走这个CCThread delloc销毁方法
    //    }];
    //
    //    [thread start];
    
    // 主线程的开启是在main函数里代码的的 UIApplicationMain 函数开启的，main函数中是没有开启的主线程的runloop，main函数可能还只是在系统的线程待研究系统线程概念，主线程是通过mian函数中代码 UIApplicationMain 函数开启，从而启动应用程序启动runloop，
    //    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, <#dispatchQueue#>);
    //    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, <#intervalInSeconds#> * NSEC_PER_SEC, <#leewayInSeconds#> * NSEC_PER_SEC);
    //    dispatch_source_set_event_handler(timer, ^{
    //        <#code to be executed when timer fires#>
    //    });
    //    dispatch_resume(timer);
    
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //
    //    // 这里创建的timer 也是一个source,创建source，第一个参数source 类型，第二 3个参数是回调的handle 也就是回调的指针
    //    // gcd dispatch_source_t本质上是一个oc对象
    //    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //
    //    // 设置回调 设置时间回调 gcd参数，第二个开始时间(dispatch_time_t),第二个参数间隔时间（持续时间）单位是纳秒
    //    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //    // 设置 事件回调，是触发了timer后的事件回调
    //    dispatch_source_set_event_handler(_timer, ^{
    //        NSLog(@".......%@",[NSThread currentThread]);
    //    });
    //    // 启动定时器
    //    dispatch_resume(self.timer);
    
    //    [self performSelectorInBackground:@selector(test) withObject:nil];
}

// 主线程
- (void)timerMethod
{
    // 加一个耗时操作 发现拖拽屏幕出现卡顿
    NSLog(@"睡会");
    //    [NSThread sleepForTimeInterval:1.0];
    static int num = 0;
    NSLog(@"num%d%@",num++,[NSThread currentThread]);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    [_thread start];
    
    self.finised = YES;
    
    CCTableVC *vc = [[CCTableVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)test
{
    NSLog(@"In Background");
}

- (void)ARC
{
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @autoreleasepool {
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
