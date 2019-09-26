//
//  main.m
//  CCBlogCode
//
//  Created by zerocc on 2015/10/01.
//  Copyright © 2015年 zerocc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        // UIApplicationMain 有三个参数，第三个是nil默认 就是@"UIApplication" 单例对象，如果要操作系统级别的东西，可以自定义Application继承父类UIApplicationMain去重写方法去拦截系统的一些事件
    }
}

//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//        NSLog(@"%@",[NSThread currentThread]);
//    }
//}


//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        BOOL running = YES;
//        do {
//
//            NSLog(@"excute loop function \n %@",[NSThread currentThread]);
//        }while (running);
//
//
//        return 0;
//    }
//
//}
