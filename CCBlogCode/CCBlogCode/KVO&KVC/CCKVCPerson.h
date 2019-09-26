//
//  CCKVCPerson.h
//  CCBlogCode
//
//  Created by zerocc on 2016/11/16.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CCKVCDog;

@interface CCKVCPerson : NSObject {
    @public
    NSString* _age;
//    NSString* _isAge;
//    NSString* age;
//    NSString* isAge;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) CCKVCDog *dog;

@property (nonatomic, copy) NSString *isAge;

@end

NS_ASSUME_NONNULL_END
