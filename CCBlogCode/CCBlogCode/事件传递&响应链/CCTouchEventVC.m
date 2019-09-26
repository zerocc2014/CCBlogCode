//
//  CCTouchEventVC.m
//  CCBlogCode
//
//  Created by zerocc on 2019/9/8.
//  Copyright © 2019年 zerocc. All rights reserved.
//
// 参考链接：https://www.jianshu.com/p/2e074db792ba

/*
 1. 事件的分发过程: 从父控件传递到子控件找到最合适的 view 处理通过hitTest:withEvent:方法；
    UIApplication -> UIWindow -> Root View -> ··· -> subview
    产生触摸事件->UIApplication事件队列->[UIWindow hitTest:withEvent:]->返回更合适的view->[子控件 hitTest:withEvent:]->返回最合适的view
 
 2. 事件的响应过程: 响应者对象 UIResponder,
    Initial View -> View Controller（如果存在） -> superview -> · ··  -> rootView -> UIWindow -> UIApplication
    找到最合适的View->调用控件的touches方法来作具体的事件处理(touchesBegan、touchesMovedtouchedEnded)->touches方法的默认做法是将事件顺着响应者链条向上传递(touch 方法不处理事件只向上传递事件),将事件交给上一个响应者进行处理

 事件的传递是从上到下（父控件到子控件），事件的响应是从下到上（顺着响应者链条向上传递：子控件到父控件。
 
 
 系统检测到手指触摸(Touch)操作时，将Touch 以UIEvent的方式加入UIApplication事件队列中，UIApplication从事件队列中取出最新的触摸事件进行分发传递到UIWindow进行处理。UIWindow 会通过hitTest:withEvent:方法寻找触碰点所在的视图，这个过程称之为hit-test view；在顶级视图（Root View）上调用pointInside:withEvent:方法判断触摸点是否在当前视图内；如果返回NO，那么hitTest:withEvent:返回nil；如果返回YES，那么它会向当前视图的所有子视图发送hitTest:withEvent:消息，直到有子视图返回非空对象或者全部子视图遍历完毕。如果所有subview遍历结束仍然没有返回非空对象，则hitTest:withEvent:返回self；系统就是这样通过hit test找到触碰到的视图(Initial View)进行响应。
 
 Touch后系统通过hit test 机制找到了触碰到的Initial View，但是Initial view并没有或者无法正常处理此次Touch。这个时候，系统便会通过响应者链寻找下一个响应者，以对此次Touch 进行响应;如果一个View有一个视图控制器（View Controller），它的下一个响应者是这个视图控制器，紧接着才是它的父视图（Super View），如果一直到Root View都没有处理这个事件，事件会传递到UIWindow（iOS中有一个单例Window），此时Window如果也没有处理事件，便进入UIApplication，UIApplication是一个响应者链的终点，它的下一个响应者指向nil，以结束整个循环。
 
 苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。
 
 当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。这个过程的详细情况可以参考这里。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的 App 进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。
 
 _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。
 */

#import "CCTouchEventVC.h"

@interface CCTouchEventVC ()
@property (nonatomic, strong) UIView *tmpview;
// UIControl类重写了touches系列方法
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CCTouchEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
