//
//  CCSwizzleMethod.h
//  CCBlogCode
//
//  Created by zerocc on 2019/9/10.
//  Copyright © 2019年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCSwizzleMethod : NSObject
void Swizzle_(Class cls, SEL origSEL, SEL sizSEL);

@end

NS_ASSUME_NONNULL_END
