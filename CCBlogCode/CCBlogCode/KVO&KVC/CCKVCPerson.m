//
//  CCKVCPerson.m
//  CCBlogCode
//
//  Created by zerocc on 2016/11/16.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCKVCPerson.h"
#import "CCKVCDog.h"

@implementation CCKVCPerson

#pragma mark - kvc 赋值第一步：先顺序查找以下方法赋值 set<Key>:、 _set<Key>:、setIs<Key>:;
//// 先执行
//- (void)setAge:(NSString *)age {
//
//    NSLog(@"%s", __func__);
//}
//
//// 没有上面执行这个
//- (void)_setAge:(NSString*)age {
//
//    NSLog(@"%s", __func__);
//}
//
//// 都没有最后执行这个方法
//- (void)setIsAge:(NSString*)age {
//    _age = age;
//    NSLog(@"%s", __func__);
//}

#pragma mark - kvc 赋值第二步：第一步方法都没找到则执行下面方法，系统返回是Yes 继续往下执行，如果我们重写此方法返回 NO 则直接执行setValue:forUndefinedKey:方法抛出异常，报 key 不存在错误

+ (BOOL)accessInstanceVariablesDirectly {
    
    return YES;
}

#pragma mark - kvc 赋值第三步: 第二步返回YES 的话，继续找相关变量 _key，_iskey，key，iskey 有就设值
// 这里定义@property  isAge 成员变量直接验证

#pragma mark - kvc 赋值第四步: 第三步后方法或成员都不存在，setValue:forUndefinedKey:方法，默认是抛出异常
- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"不能将%@设成nil", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"出现异常，该key不存在%@",key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"出现异常，该key不存在%@", key);
}

// 取值类似赋值
// 1. 先找相关方法  get<Key>, key
// 2. 若没有相关方法 + (BOOL)accessInstanceVariablesDirectly， 如果是判断是NO,直接执行KVC的valueForUndefinedKey:(系统抛出一个异常，未定义key)
// 3. 如果是YES，继续找相关变量_<key> _is<Key> <key> is<Key>
// 4. 方法或成员都不存在，valueForUndefinedKey:方法，默认是抛出异常


#pragma mark - 扩展容错处理策略

//// 对非对象类型，值不能为空
//- (void) setNilValueForKey:(NSString *)key {
//    NSLog(@"%@ 值不能为空", key);
//}
//
// 赋值key值不存在
//- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
//    NSLog(@"key = %@值不存在 ", key);
//}
//
//// 取值key值不存在
//- (id) valueForUndefinedKey:(NSString *)key {
//    NSLog(@"key=%@不存在", key);
//    return nil;
//}
//
//- (BOOL) validateAge:(inout id  _Nullable __autoreleasing *)ioValue  error:(out NSError * _Nullable __autoreleasing *)outError {
//    NSNumber* value = (NSNumber*)*ioValue;
//    NSLog(@"%@", value);
////    if (value <= 0 || value >= 200) {
////        return NO;
////    }
//    return YES;
//}

@end
