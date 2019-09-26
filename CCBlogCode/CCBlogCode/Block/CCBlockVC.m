//
//  CCBlockVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/9/8.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCBlockVC.h"

@interface CCBlockVC ()

@end

@implementation CCBlockVC

- (void)viewDidLoad {
    [super viewDidLoad];

    /* block基础
     
     block是苹果官方推荐的类型,效率高,在运行中保存代码.
     用来封装和保存代码,类似方法(函数),block可以在任何时候执行
     
     block 和 方法(函数)相似之处
     1.都可以保存代码
     2.返回值
     3.有参数
     4.调用方式
     */
    
    //-------无返回值无参数block
    
    void (^MyBlock)(void) = ^(){
        NSLog(@"无返回值,无参数的block");
    };
    MyBlock();
    
    //--------无返回值有参数block
    void (^MyBlock1)(int,int) = ^(int a,int b){
        NSLog(@"有参数的block----a=%d--b=%d",a,b);
    };
    MyBlock1(99,66);
    
    //---------有返回值有参数block
    int (^SumBlock)(int,int) = ^(int a,int b){
        
        return a+b;
    };
    NSLog(@"返回值是%d",SumBlock(9,1));
    
    // 给block取别名MyBlock2
    typedef void(^MyBlock2) (int a,int b);
    typedef int(*MyFunction) (int a,int b);  //给指向函数的指针取别名MyFunction
}



@end
