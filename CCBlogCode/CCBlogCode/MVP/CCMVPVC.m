//
//  CCMVPVC.m
//  CCBlogCode
//
//  Created by zerocc on 2017/5/4.
//  Copyright © 2017年 zerocc. All rights reserved.
//

#import "CCMVPVC.h"
#import "CCPresenter.h"

@interface CCMVPVC ()
@property (strong, nonatomic) CCPresenter *presenter;

@end

@implementation CCMVPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[CCPresenter alloc] initWithController:self];
}


@end
