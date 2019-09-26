//
//  CCRuntimePerson.h
//  CCBlogCode
//
//  Created by zerocc on 2016/8/7.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCRuntimePerson : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;

- (void)studyCourse:(NSString *)course;
+ (void)play;
@end

NS_ASSUME_NONNULL_END
