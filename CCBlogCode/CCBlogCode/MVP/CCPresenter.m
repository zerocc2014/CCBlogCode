//
//  CCPresenter.m
//  CCBlogCode
//
//  Created by zerocc on 2017/5/4.
//  Copyright © 2017年 zerocc. All rights reserved.
//

#import "CCPresenter.h"
#import "CCView.h"
#import "CCUser.h"

@interface CCPresenter () <CCViewDelegate>
@property (weak, nonatomic) UIViewController *controller;

@end

@implementation CCPresenter

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [super init]) {
        self.controller = controller;
        
        // 创建View
        CCView *view = [[CCView alloc] init];
        view.frame = CGRectMake(100, 100, 100, 150);
        view.delegate = self;
        [controller.view addSubview:view];
        
        // 加载模型数据
        CCUser *user = [[CCUser alloc] init];
        user.name = @"zerocc";
        user.image = @"imgUrl";
        
        // 赋值数据
        [view setName:user.name andImage:user.image];
    }
    return self;
}

#pragma mark - CCViewDelegate
- (void)viewDidClick:(CCView *)view {
    
    NSLog(@"presenter 监听了 appView 的点击");
}

@end
