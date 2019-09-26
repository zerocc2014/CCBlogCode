//
//  CCView.h
//  CCBlogCode
//
//  Created by zerocc on 2017/5/4.
//  Copyright © 2017年 zerocc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CCView;

@protocol CCViewDelegate <NSObject>
@optional
- (void)viewDidClick:(CCView *)view;

@end

@interface CCView : UIView
@property (weak, nonatomic) id<CCViewDelegate> delegate;

- (void)setName:(NSString *)name andImage:(NSString *)image;

@end

NS_ASSUME_NONNULL_END
