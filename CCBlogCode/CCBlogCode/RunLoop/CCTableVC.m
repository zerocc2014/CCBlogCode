//
//  CCTableVC.m
//  RunLoop
//
//  Created by zerocc on 2017/5/29.
//  Copyright © 2017年 zerocc. All rights reserved.
//

// runloop的循环是因为cpu的循环造成的，可以在cpu的间隙去加载cell上的图片


// 解决问题：卡顿问题
// 分析：为什么卡顿？？
// 一次runloop循环需要绘制屏幕上所有的点，一次runloop需要绘制15张高清图片
// 将绘制15张图片分别派发给每一次runloop 循环
// 每次runloop 循环加载一张图片！ 由于runloop 循环非常快，所以加载图片不影响

/* 思路：
 1.监听runloop 循环，c语言
 2.在runloop循环一次的时候，从数组里面拿代码执行！！（数组有长度，滑动很快可能一次性有上百行cell，但是我不需要这所有滑动的cell都加载，我只需要拿屏幕上的，最后几十行就行）
 
 
  Run Loop Observer Activities 监听runloop一些活动事件 的枚举
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry = (1UL << 0),  枚举值是位运算，苹果的宏定义都是位运算，为什么，就是为了组合，为了多个枚举 多个使用用或达到多个都可行
    kCFRunLoopBeforeTimers = (1UL << 1),  即将处理timer
    kCFRunLoopBeforeSources = (1UL << 2),
    kCFRunLoopBeforeWaiting = (1UL << 5),
    kCFRunLoopAfterWaiting = (1UL << 6),
    kCFRunLoopExit = (1UL << 7),
    kCFRunLoopAllActivities = 0x0FFFFFFFU
};
 
 要监听这个runloop 就必须要一个观察者，其是苹果定义的结构体，它是一个结构体是cfrunloop观察者，当runloop发生变化接收回调，在corefoundation ref结尾的都是指针，在oc中接收回调三种，但是在c中回调是通过函数指针，定义好一个函数，然后将函数指针传给它，它就知道发生一个事情后，它就调用你定义好的函数
 typedef struct CF_BRIDGED_MUTABLE_TYPE(id) __CFRunLoopObserver * CFRunLoopObserverRef;
 
 */

#import "CCTableVC.h"

// 定义一个 block
typedef BOOL(^RunloopBlock)(void);

@interface CCTableVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *tasks;
// 最大的任务数，数组的长度
@property (nonatomic, assign) NSUInteger maxQueueLength;
@end

@implementation CCTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    _maxQueueLength = 30;
    _tasks = [NSMutableArray array];
    [self initUI];
    
    // 添加runloop的观察者
    [self addRunloopObserver];
}

// 这里设置的timer 只是为了让runloop 转起来，runloop回调函数就能快速起来，
- (void)timerMethod
{
    NSLog(@"xxxx");
    
}

- (void)initUI
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ccRunloopCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ccRunloopCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 干掉cell.contentView上的子控件节约内存
    // 来回滑动重复添加控件，cell重复利用时候，干掉其子控件通过tag值for循环，但是干不干净，其内部循环利用机制还有一些缓存机制，这种方式是不够的，滚动特别快是干不掉的。自定义cell就可以干掉，用runtime给uitableview添加一个属性也可以做到
    for (NSInteger i=1; i<= 5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
    
    [CCTableVC addlabel:cell indexPath:indexPath];
    
    // 加载图片 这个地方是个耗时操作 不希望在这个代理方法中一次性加载 希望可以每一次runloop循环 加载一张图片
    // 可以把这个耗时操作的代码扔到数组里面去，先不执行，我只是知道这里要加载图片，但是我不立即加载，不放到一个runloop循环中执行
//    [CCTableVC addImage1With:cell];
//    [CCTableVC addImage2With:cell];
//    [CCTableVC addImage3With:cell];
    
    [self addTasks:^BOOL{
        [CCTableVC addImage1With:cell];
        return YES;
    }];
    
    [self addTasks:^BOOL{
        [CCTableVC addImage2With:cell];
        return YES;
    }];
    
    [self addTasks:^BOOL{
        [CCTableVC addImage3With:cell];
        return YES;
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135.1;
}

+ (void)addlabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 20)];
    label.text = @"xxxxxxxxxxxxxxxx";
    [cell.contentView addSubview:label];
}
// 加载第一张图
+ (void)addImage1With:(UITableViewCell *)cell
{
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 85, 85)];
    imageView1.tag = 1;
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"cc" ofType:@"png"];
    UIImage *image1 = [UIImage imageNamed:@"zero.jpg"];
//    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.image = image1;
    [cell.contentView addSubview:imageView1];
//    [UIView transitionWithView:cell.contentView duration:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//        [cell.contentView addSubview:imageView1];
//    } completion:nil];
//    
}

// 加载第二张图
+ (void)addImage2With:(UITableViewCell *)cell
{
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(115, 20, 85, 85)];
    imageView2.tag = 2;
    UIImage *image2 = [UIImage imageNamed:@"zero.jpg"];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.image = image2;
    [cell.contentView addSubview:imageView2];
//    [UIView transitionWithView:cell.contentView duration:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//        [cell.contentView addSubview:imageView2];
//    } completion:nil];
    
}

// 加载第三张图
+ (void)addImage3With:(UITableViewCell *)cell
{
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(225, 20, 85, 85)];
    imageView3.tag = 3;
    UIImage *image3 = [UIImage imageNamed:@"zero.jpg"];
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    imageView3.image = image3;
    [cell.contentView addSubview:imageView3];
//    [UIView transitionWithView:cell.contentView duration:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//        [cell.contentView addSubview:imageView3];
//    } completion:nil];
    
}

// 这里都是c语言的
- (void)addRunloopObserver
{
    // 获取当前runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
   /* typedef struct {
        CFIndex	version;
        void *	info;
        const void *(*retain)(const void *info);
        void	(*release)(const void *info);
        CFStringRef	(*copyDescription)(const void *info);
    } CFRunLoopObserverContext; */

    //定义一个上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    // 定义一个观察者  搞一个静态的 只需要一个
    // calback 是一个回调函数
    static CFRunLoopObserverRef defaultObserver;
    //CFRunLoopObserverRef CFRunLoopObserverCreate(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, CFIndex order, CFRunLoopObserverCallBack callout, CFRunLoopObserverContext *context);
    // 创建观察者
    defaultObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, NSIntegerMax - 999, &Callback, &context);
    
    // 添加当前runloop的观察者
    CFRunLoopAddObserver(runloop, defaultObserver, kCFRunLoopDefaultMode);
    
    /*typedef struct {
        CFIndex	version;
        void *	info;
        const void *(*retain)(const void *info);
        void	(*release)(const void *info);
        CFStringRef	(*copyDescription)(const void *info);
        Boolean	(*equal)(const void *info1, const void *info2);
        CFHashCode	(*hash)(const void *info);
        void	(*schedule)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
        void	(*cancel)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
        void	(*perform)(void *info);
    } CFRunLoopSourceContext; */
    
//    CFRunLoopSourceContext context = {
//        
//    }
    // c语言有create就需要release
    CFRelease(defaultObserver);
    
//    static CFRunLoopSourceRef customSource;
//    customSource = CFRunLoopSourceCreate(<#CFAllocatorRef allocator#>, <#CFIndex order#>, <#CFRunLoopSourceContext *context#>)
}

//runloop的回调函数， 其中info参数就是self前面已经传入的这里拿到的就是self
// 从数组里面拿代码执行
static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSLog(@"callback come");  // nslog其实是耗时操作，加载图片能够更加迅速
    CCTableVC *vc = (__bridge CCTableVC *)(info);
    if (vc.tasks.count == 0) { //
        return;
    }
    BOOL result = NO; // 这就是为什么上面block定位为bool值
    while (result == NO && vc.tasks.count) { // 这样可以外界控制传入block 控制这个runloop一次循环只执行一次
        // 取出任务
        RunloopBlock unit = vc.tasks.firstObject;
        // 执行任务
        result = unit();
        // 干掉执行完毕的任务
        [vc.tasks removeObjectAtIndex:0];
    }
//    // 取出任务
//    RunloopBlock unit = vc.tasks.firstObject;
//    // 执行任务
//    unit();
//    // 干掉执行完毕的任务
//    [vc.tasks removeObjectAtIndex:0];
    
    
}

// 添加任务的方法
- (void)addTasks:(RunloopBlock)unit
{
    [self.tasks addObject:unit];
    
    // 保证数组里只有30个任务
    if (self.tasks.count > self.maxQueueLength) {
        [self.tasks removeObjectAtIndex:0]; // 把最前面最前添加的先干掉显示目前屏幕上的
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
