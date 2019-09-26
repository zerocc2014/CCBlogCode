//
//  CCAVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCAVC.h"
#import "URL_Router.h"

@interface CCAVC ()

@end

@implementation CCAVC

+ (void)load{
    [[URL_Router sharedInstance] registerURLPattern:@"test://A_Action" toHandler:^(NSDictionary* para) {
        NSString *para1 = para[@"para1"];
        [[self new] action_A:para1];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 调用组件B
    [[URL_Router sharedInstance] openURL:@"test://B_Action" withParam:@{@"para1":@"PARA1", @"para2":@(222),@"para3":@(333),@"para4":@(444)}];
}

-(void)action_A:(NSString*)para1 {
    
    NSLog(@"call action_A: %@",para1);
}

@end
