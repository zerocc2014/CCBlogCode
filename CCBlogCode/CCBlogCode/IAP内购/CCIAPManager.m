//
//  CCIAPManager.m
//  CCPackageTools
//
//  Created by zerocc on 2019/4/22.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import "CCIAPManager.h"
#import <StoreKit/StoreKit.h>

@interface CCIAPManager ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) PurchaseCompletion completion;
@property (nonatomic, copy) OrderLoseHandler handler;

@end

@implementation CCIAPManager

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

+ (instancetype)shareCCIAPManager {
    static CCIAPManager *IAPManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        IAPManager = [[CCIAPManager alloc] init];
    });
    
    return IAPManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 开始支付事务监听, 并且开始支付凭证验证队列.
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

- (void)completionStateType:(CCIAPPaymentState)state data:(NSData *)data {
    if (_completion) {
        _completion(state,data);
    }
}

- (void)orderHandlerStateType:(CCIAPPaymentState)state data:(NSData *)data {
    if (_handler) {
        _handler(state,data);
    }
}

- (void)purchaseWithProductID:(NSString *)productID purchaseCompletion:(PurchaseCompletion)completion {
    if (productID) {
        if ([SKPaymentQueue canMakePayments]) {
            // 1. 开始请求购买
            _productID = productID;
            _completion = completion;
            NSSet *productSet = [NSSet setWithArray:@[productID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
            request.delegate = self;
            [request start];
            
        }else {
            [self completionStateType:CCIAPPaymentStateNotArrow data:nil];
        }
        
    }
}

- (void)gainLoseOrderHandler:(OrderLoseHandler)handler {
    if ([SKPaymentQueue canMakePayments]) {
        NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
        // 检测是否有未完成的交易(因为有获得的transactions为空的情况)
        if (transactions.count > 0) {
            SKPaymentTransaction* transaction = [transactions firstObject];
            if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:recepitURL];
                if (!receiptData) { // 发送服务器校验订单，如果为空获取不到则出现掉单情况
                    [self orderHandlerStateType:CCIAPPaymentStateSuccess data:receiptData];
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }else { // 还是获取不到服务器去手动补单吧 finish掉 (appStore 返回掉单情况)
                    [self orderHandlerStateType:CCIAPPaymentStateOrderAppStoreLose data:nil];
                }

                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
        }
    }else {
        [self orderHandlerStateType:CCIAPPaymentStateNotArrow data:nil];
    }
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] > 0){ // 存在商品
        SKProduct *p = nil;
        for(SKProduct *pro in product){
            if([pro.productIdentifier isEqualToString:_productID]){
                p = pro;
                
                break;
            }
        }
        
        // 2. 将购买的商品添加进购买队列
        SKPayment *payment = [SKPayment paymentWithProduct:p];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    // 3. 输入密码确认交易后苹果返回购买回调结果
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:  //正在交易
                
                break;
            case SKPaymentTransactionStatePurchased:
                [self transactionPurchased:transaction];
                
                break;
            case SKPaymentTransactionStateRestored:  //恢复交易

                 [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:    //交易失败
                [self transactionFailed:transaction];
                
                break;
            case SKPaymentTransactionStateDeferred:  // 交易状态未确定
                
                break;

            default:
                break;
        }
    }
}

#pragma mark - transactionState

// 交易中.
- (void)transactionPurchasing:(SKPaymentTransaction *)transaction {
    NSLog(@"交易中...");
}

// 交易成功.
- (void)transactionPurchased:(SKPaymentTransaction *)transaction {
    
    // 4. 获取交易成功的票据
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:recepitURL];
    
    if (!receiptData) {  // 发送服务器校验订单
        [self completionStateType:CCIAPPaymentStateSuccess data:receiptData];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }else { // 一定是掉单了 (appStore 返回掉单情况)
        [self completionStateType:CCIAPPaymentStateOrderAppStoreLose data:nil];
    }
}

// 交易失败.
- (void)transactionFailed:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self completionStateType:CCIAPPaymentStateFailed data:nil];
     }else {
        [self completionStateType:CCIAPPaymentStateCancle data:nil];
     }
    
     [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 已经购买过该商品.
- (void)transactionRestored:(SKPaymentTransaction *)transaction {
    NSLog(@"已经购买过该商品...");
}

// 交易延期.
- (void)transactionDeferred:(SKPaymentTransaction *)transaction {
    NSLog(@"交易延期...");
}

@end
