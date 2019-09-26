//
//  CCViewModel.m
//  CCBlogCode
//
//  Created by zerocc on 2019/9/4.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCViewModel.h"
#import "CCPerson.h"
#import "CCMenuView.h"

@interface CCViewModel () <CCMenuViewDelegate>
@property (weak, nonatomic) UIViewController *controller;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *image;

@end

@implementation CCViewModel

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [super init]) {
        self.controller = controller;
        
        // 创建View
        CCMenuView *menuView = [[CCMenuView alloc] init];
        menuView.frame = CGRectMake(100, 100, 100, 150);
        menuView.delegate = self;
        menuView.viewModel = self;
        [controller.view addSubview:menuView];
        
        // 加载模型数据
        CCPerson *person = [[CCPerson alloc] init];
        person.name = @"zerocc";
        person.image = @"imgUrl";
        
        // 设置数据
        self.name = person.name;
        self.image = person.image;
    }
    return self;
}

#pragma mark - MJAppViewDelegate
- (void)appViewDidClick:(CCMenuView *)appView {
    NSLog(@"viewModel 监听了 appView 的点击");
}

@end
