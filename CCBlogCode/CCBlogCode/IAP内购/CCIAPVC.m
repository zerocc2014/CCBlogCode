//
//  CCIAPVC.m
//  CCBlogCode
//
//  Created by zerocc on 2019/4/5.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCIAPVC.h"
#import "CCIAPManager.h"

@interface CCIAPVC ()

@end

@implementation CCIAPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CCIAPManager shareCCIAPManager] purchaseWithProductID:@"1111"
                                         purchaseCompletion:^(CCIAPPaymentState stateType, NSData * _Nonnull data) {
        
        
    }];

}


@end
