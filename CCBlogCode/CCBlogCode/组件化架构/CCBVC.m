//
//  CCBVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCBVC.h"
#import "URL_Router.h"

@interface CCBVC ()

@end

@implementation CCBVC

+ (void)load {
    [[URL_Router sharedInstance] registerURLPattern:@"test://B_Action" toHandler:^(NSDictionary* para) {
        NSString *para1 = para[@"para1"];
        NSInteger para2 = [para[@"para2"]integerValue];
        NSInteger para3 = [para[@"para3"]integerValue];
        NSInteger para4 = [para[@"para4"]integerValue];
        [[self new] action_B:para1 para2:para2 para3:para3 para4:para4];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 调用A
    [[URL_Router sharedInstance]openURL:@"test://A_Action" withParam:@{@"para1":@"param1"}];
}

- (void)action_B:(NSString*)para1 para2:(NSInteger)para2 para3:(NSInteger)para3 para4:(NSInteger)para4 {
    NSLog(@"call action_B: %@---%zd---%zd---%zd",para1,para2,para3,para4);
}

@end
