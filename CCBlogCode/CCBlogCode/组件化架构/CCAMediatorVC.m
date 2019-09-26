//
//  CCAMediatorVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCAMediatorVC.h"
#import "Mediator.h"

@interface CCAMediatorVC ()

@end

@implementation CCAMediatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)a_VC_detailViewController:(NSString *)parent{
    NSLog(@"======通过runtime进行调用 ====== ==%@", parent );
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [Mediator CCBMediatorVC_viewcontroller:1];
}

@end
