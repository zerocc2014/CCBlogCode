//
//  CCModuleVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/8/30.
//  Copyright © 2019年 zerocc. All rights reserved.
//

/*
 组件分类：基础功能组件，业务逻辑组件；
 
 组件化由来：解决的是各个模块间的依赖复杂的问题，模块之间解耦；
 
 组件化方案有：
 1、利用url-scheme注册
 2、Protocol-class注册
 3、利用runtime实现的target-action方法
 */
#import "CCModuleVC.h"

#import "CCAVC.h"
#import "CCAMediatorVC.h"

@interface CCModuleVC ()

@end

@implementation CCModuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - URL—Scheme ()
/*
 调用者通过依赖中间件，中间件的category来提供服务给调用者，这样使用者只需要依赖中间件，而组件则不需要依赖中间件
 
 在APP启动的时候，或者向以下实例中的在每个模块自己的load方法里面注册自己的短链、
 以及对外提供服务（通过block）通过URL-scheme标记好，然后维护在URL-Router里面。

 URL-Router中保存了各个组件对应的URL-scheme，
 只要其他组件调用了 open URL的方法，URL-Router就会去根据URL查找对应的服务并执行。
 */
- (void)test0 {
    CCAVC *avc = [[CCAVC alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
    
    /* 问题：
     1. 当组件多起来的时候，需要提供一个关于URL和服务的对应表并维护；
     2. 在应用启动时每个组件需要到路由管理中心注册自己的URL及服务，因此内存中需要保存这样一份表，内存耗费；
     3. 混淆了本地调用和远程调用，
     */
}

#pragma mark - target-action ()
/*
 
 借助了OC运行时的特征,无需注册即可实现组件间的调用,
 
 */
- (void)test1 {
    
    CCAMediatorVC *avc = [[CCAMediatorVC alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
    
    /* 问题：
     1. 当组件多起来的时候，需要提供一个关于URL和服务的对应表并维护；
     2. 在应用启动时每个组件需要到路由管理中心注册自己的URL及服务，因此内存中需要保存这样一份表，内存耗费；
     3. 混淆了本地调用和远程调用，
     */
}




@end
