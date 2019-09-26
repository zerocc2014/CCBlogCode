//
//  CCIAPManager.h
//  CCPackageTools
//
//  Created by zerocc on 2019/4/22.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, CCIAPPaymentState) {
    CCIAPPaymentStateSuccess,     // 购买成功
    CCIAPPaymentStateFailed,      // 购买失败
    CCIAPPaymentStateCancle,      // 取消购买
    CCIAPPaymentStateNotArrow,    // 不允许内购
    CCIAPPaymentStateOrderAppStoreLose,
    CCIAPPaymentStateOrderVerifyFailed
};

typedef void (^PurchaseCompletion)(CCIAPPaymentState stateType,NSData *data);
typedef void (^OrderLoseHandler)(CCIAPPaymentState stateType,NSData *data);

@interface CCIAPManager : NSObject
+ (instancetype)shareCCIAPManager;

- (void)purchaseWithProductID:(NSString *)productID purchaseCompletion:(PurchaseCompletion)completion;

- (void)gainLoseOrderHandler:(OrderLoseHandler)handler;

@end

NS_ASSUME_NONNULL_END
