//
//  CCBMediatorVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCBMediatorVC.h"
#import "Mediator.h"

@interface CCBMediatorVC ()

@end

@implementation CCBMediatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)b_VC_detailViewController:(NSInteger)type {
    NSLog(@"======通过runtime进行调用 ====== ==%ld", (long)type );
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [Mediator CCAMediatorVC_viewcontroller:@"ZEROCC"];
}


@end
