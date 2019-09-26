//
//  CCKVOKVCVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/11/16.
//  Copyright © 2016年 zerocc. All rights reserved.
//
// NSKeyValueCoding NSObject扩展

#import "CCKVOKVCVC.h"
#import "CCKVCPerson.h"
#import "CCKVCDog.h"
#import "CCKVOPerson.h"
#import <objc/runtime.h>

#import "NSObject+KVC.h"
#import "NSObject+KVO.h"

@interface CCKVOKVCVC ()
@property (nonatomic, strong) CCKVOPerson *kvoPerson1;
@property (nonatomic, strong) CCKVOPerson *kvoPerson2;

@end

@implementation CCKVOKVCVC

- (void)dealloc {
//    [self.kvoPerson1 removeObserver:self forKeyPath:@"name" context:@"name参数"];
    [self.kvoPerson1 cc_removeObserver:self forKeyPath:@"name"];
    [self.kvoPerson2 cc_removeObserver:self forKeyPath:@"name"];

    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self testKVC];
//    [self testKVC1];
//    [self testKVO];
//    [self testKVO1];
    [self testKVOCategory];

}

#pragma mark - Key-value coding 键值编码
- (void)testKVC {
    CCKVCPerson *person = [[CCKVCPerson alloc] init];
    person.dog = [[CCKVCDog alloc] init];
    // kvc 赋值
    [person setValue:@"zerocc" forKey:@"name"];
    [person setValue:@"旺财" forKeyPath:@"dog.name"];
    NSLog(@"%@ %@", person.name, person.dog.name);
    
    // kvc 取值
    NSString *name = [person valueForKey:@"name"];
    NSString *dogName = [person valueForKeyPath:@"dog.name"];
    NSLog(@"%@ %@", name, dogName);
}

// kvc 原理
- (void)testKVC1 {
    CCKVCPerson *person = [[CCKVCPerson alloc] init];
    [person setValue:@"18" forKey:@"age"];
    NSLog(@"%@ %@", person->_age,person.isAge);
}

#pragma mark - Key-Value Observing 键值监听
- (void)testKVO {
    self.kvoPerson1 = [[CCKVOPerson alloc] init];
    self.kvoPerson1.name = @"zerocc";
    
    // 插入思考问题1 如果两个对象 KVO 监听那个对象的属性变化呢？？？
    self.kvoPerson2 = [[CCKVOPerson alloc] init];
    self.kvoPerson2.name = @"jack";
    
    /*
     NSKeyValueObservingOptionNew: change字典包括改变后的值
     NSKeyValueObservingOptionOld: change字典包括改变前的值
     NSKeyValueObservingOptionInitial: 注册后立刻触发KVO通知
     NSKeyValueObservingOptionPrior:值改变前是否也要通知（这个key决定了是否在改变前改变后通知两次）
     */
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.kvoPerson1 addObserver:self forKeyPath:@"name" options:options context:@"name参数"];
    
    self.kvoPerson1.name = @"zero";
    
    // 插入思考问题手动触发 kvo
    // 通过手动调用如下方法 使得触发kvo 监听器
    self.kvoPerson1.name = @"zero";
    [self.kvoPerson1 willChangeValueForKey:@"name"];
    [self.kvoPerson1 didChangeValueForKey:@"name"];
}

// kvo 原理
- (void)testKVO1 {
    self.kvoPerson1 = [[CCKVOPerson alloc] init];
    self.kvoPerson1.name = @"zerocc";
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.kvoPerson1 addObserver:self forKeyPath:@"name" options:options context:@"name参数"];
    // 打印其内部函数调用过程
    [self printMethodNamesOfClass:object_getClass(self.kvoPerson1)];

    // p self.kvoPerson1.isa  -> (Class) $0 = NSKVONotifying_CCKVOPerson
    self.kvoPerson1.name = @"zero";
    NSLog(@"------");
    
    /*
      isa-swizzling 实现的
     1. 对于使用KVO监听后会动态派生一个类，CCKVOPerson -> NSKVONotifying_CCKVOPerson
     2. isa 指针指向改变，没有使用kvo监听则对象的 isa 指针指向类对象找到对应set get 方法，而使用kvo后对象的 isa 指针指向派生类NSKVONotifying_CCKVOPerson的类对象找到对应方法的实现(set 方法中调用 foundation 框架的 _NSSetxxxValueAndNotify()方法),最后调用本身类对象set 方法；
     */
    
    
    /*
     
     - (void)setName:(NSString)name {
        _NSSetNSStringValueAndNotify();
     }
     
     void _NSSetIntValueAndNotify() {
        [self willChangeValueForKey:@"name"];
        [super setName:name];
        [self didChangeValueForKey:@"name"];
     }
     
     - (void)didChangeValueForKey:(NSString *)key {
        // 通知监听器，某某属性值发生了改变
        [oberser observeValueForKeyPath:key ofObject:self change:nil context:nil];
     }
     
     */
}

// 当监听对象的属性值发生改变时，就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    /* change {
     kind = 1;
     new = zero;
     old = zerocc;}
     */
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
}

- (void)printMethodNamesOfClass:(Class)cls {
    unsigned int count;
    // 获得方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    
    // 存储方法名
    NSMutableString *methodNames = [NSMutableString string];
    
    // 遍历所有的方法
    for (int i = 0; i < count; i++) {
        // 获得方法
        Method method = methodList[i];
        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        // 拼接方法名
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    
    // 释放
    free(methodList);
    
    // 打印方法名
    NSLog(@"%@ %@", cls, methodNames);
}

#pragma mark - 扩展kvo实现
- (void)testKVOCategory {
    self.kvoPerson1 = [[CCKVOPerson alloc] init];
    self.kvoPerson1.name = @"zerocc";
    
    self.kvoPerson2 = [[CCKVOPerson alloc] init];
    self.kvoPerson2.name = @"zerocc";

    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew;
    [self.kvoPerson1 cc_addObserver:self forKeyPath:@"name" options:options context:nil];
    [self.kvoPerson2 cc_addObserver:self forKeyPath:@"name" options:options context:nil];

    self.kvoPerson1.name = @"zero";
    self.kvoPerson2.name = @"jack";
}

@end
