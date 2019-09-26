//
//  CCMenuView.h
//  CCBlogCode
//
//  Created by zerocc on 2019/9/4.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CCMenuView, CCViewModel;

@protocol CCMenuViewDelegate <NSObject>
@optional
- (void)viewDidClick:(CCMenuView *)menuView;

@end

@interface CCMenuView : UIView
@property (weak, nonatomic) id<CCMenuViewDelegate> delegate;
@property (weak, nonatomic) CCViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
