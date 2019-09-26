//
//  CCPropertyKeywordVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/04/4.
//  Copyright © 2016年 zerocc. All rights reserved.
//

#import "CCPropertyKeywordVC.h"

@interface CCPropertyKeywordVC ()
@property (nonatomic, copy) NSString *strCopy;
@property (nonatomic, strong) NSString *strStrong;

@property (nonatomic, copy) NSMutableString *strMutableCopyStr;
@property (nonatomic, strong) NSMutableString *strMutableStrongStr;

@end

@implementation CCPropertyKeywordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *stra = [NSString stringWithFormat:@"1"];
    _strStrong = stra;
    _strCopy = _strStrong;
    
    NSLog(@"%p,%p,%p",stra,_strStrong,_strCopy);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test2];
}

 
// 拷贝的目的：产生一个副本对象，跟源对象互不影响
// 修改了源对象，不会影响副本对象
// 修改了副本对象，不会影响源对象
/*
 iOS提供了2个拷贝方法
 1.copy，不可变拷贝，产生不可变副本
 
 2.mutableCopy，可变拷贝，产生可变副本
 
 深拷贝和浅拷贝
 1.深拷贝：内容拷贝，产生新的对象
 2.浅拷贝：指针拷贝，没有产生新的对象
 */

- (void)test {
    //        NSString *str1 = [NSString stringWithFormat:@"test"];
    //        NSString *str2 = [str1 copy]; // 返回的是NSString
    //        NSMutableString *str3 = [str1 mutableCopy]; // 返回的是NSMutableString
    
    NSMutableString *str1 = [NSMutableString stringWithFormat:@"test"];
    NSString *str2 = [str1 copy];
    NSMutableString *str3 = [str1 mutableCopy];
    
    NSLog(@"%@ %@ %@", str1, str2, str3);
}

- (void)test2 {
//    NSString *str1 = [[NSString alloc] initWithFormat:@"t"];
    NSString *str1 = [NSString stringWithFormat:@"test"];
    NSString *str2 = [str1 copy]; // 浅拷贝，指针拷贝，没有产生新对象
    NSMutableString *str3 = [str1 mutableCopy]; // 深拷贝，内容拷贝，有产生新对象
    
    NSLog(@"%@ %@ %@", str1, str2, str3);
    NSLog(@"%p %p %p", str1, str2, str3);
}

- (void)test3 {
    NSMutableString *str1 = [[NSMutableString alloc] initWithFormat:@"test"]; // 1
    NSString *str2 = [str1 copy]; // 深拷贝
    NSMutableString *str3 = [str1 mutableCopy]; // 深拷贝
    NSLog(@"%p %p %p", str1, str2, str3);
}

- (void)test4 {
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"a", @"b", nil];
    NSArray *array2 = [array1 copy]; // 浅拷贝
    NSMutableArray *array3 = [array1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", array1, array2, array3);
}

- (void)test5 {
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithObjects:@"a", @"b", nil];
    NSArray *array2 = [array1 copy]; // 深拷贝
    NSMutableArray *array3 = [array1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", array1, array2, array3);
}

- (void)test6 {
    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"jack", @"name", nil];
    NSDictionary *dict2 = [dict1 copy]; // 浅拷贝
    NSMutableDictionary *dict3 = [dict1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", dict1, dict2, dict3);
}

- (void)test7 {
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"jack", @"name", nil];
    NSDictionary *dict2 = [dict1 copy]; // 深拷贝
    NSMutableDictionary *dict3 = [dict1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", dict1, dict2, dict3);
}

// copy 修饰属性情况
- (void)test8 {
    // 1. 不可变集合类，浅拷贝，是指针地址拷贝
    NSString *aStr = @"i am copy";
    NSString *bStr = @"i am strong";
    self.strCopy = aStr;
    self.strStrong = bStr;
    NSLog(@"aStr = %p",aStr);
    NSLog(@"strCopy = %p",self.strCopy);
    NSLog(@"bStr = %p",bStr);
    NSLog(@"strStrong = %p",self.strStrong);
    
    NSLog(@"----------------------");
    // 2. 可变集合类，深拷贝，是内容拷贝分配新的内存地址
    NSMutableString *aMutableStr = [NSMutableString stringWithString:@"i am mutableCopy"];
    NSMutableString *bMutableStr = [NSMutableString stringWithString:@"i am mutableStrong"];
    self.strMutableCopyStr = aMutableStr;
    self.strMutableStrongStr = bMutableStr;
    NSLog(@"aMutableStr = %p",aMutableStr);
    NSLog(@"strMutableCopyStr = %p",self.strMutableCopyStr);
    NSLog(@"bMutableStr = %p",bMutableStr);
    NSLog(@"strMutableStrongStr = %p",self.strMutableStrongStr);
    
    NSLog(@"----------------------");
    
    // 3. 可变集合类，用 copy 修饰后，属性发送变化不影响新拷贝的；而 strong 修饰的则会跟着一起变，原因就是因为 strong 修饰的是指向同一块内存区域的
    [aMutableStr appendString:@" zerocc"];
    [bMutableStr appendString:@" zerocc"];
    NSLog(@"strMutableCopyStr ::: %@",self.strMutableCopyStr);
    NSLog(@"strMutableStrongStr ::: %@",self.strMutableStrongStr);
}

@end
