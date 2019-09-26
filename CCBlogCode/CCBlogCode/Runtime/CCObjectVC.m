//
//  CCObjectVC.m
//  CCBlogCode
//
//  Created by zerocc on 2016/8/6.
//  Copyright © 2016年 zerocc. All rights reserved.
//
// 从OC对象入手分析

/* 转 C++ 代码分析：
xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc CCRuntimePerson.m
 
clang -x objective-c -rewrite-objc -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk CCRuntimePerson.m
 
 多个Xcode：
 sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
 */

#import "CCObjectVC.h"
#import "CCRuntimePerson.h"

#import <objc/runtime.h>
#import <malloc/malloc.h>

@interface CCObjectVC ()

@end

@implementation CCObjectVC

// NSObject 对象本质
//
struct NSObject_IMPL {
    Class isa;  // isa 指针 8个字节，结构体的地址址=其第一个元素地址址
};

// CCRuntimePerson 
struct CCRuntimePerson_IMPL {
    struct NSObject_IMPL NSObject_IVARS; // C++ 中结构体继承关系这里是 8 个字节
    int _age;  // 4个字节
    NSString * _Nonnull _name; // 8个字节  字符串这里分析有问题
};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test0];
//    [self test1];
    
    [self test2];
}

#pragma mark - 对象的创建 成员变量内存布局
// 创建对象分配内存 allocWithZone -> _objc_rootAllocWithZone -> obj = (id)calloc(1, size);
- (void)test0 {
    NSObject *obj = [[NSObject alloc] init];
    
    // 获得NSObject实例对象的成员变量所占用的大小 = 8
    NSLog(@"obj 成员变量所占字节：%zd", class_getInstanceSize([NSObject class]));
    
    // 获得obj指针所指向内存的大小 = 16
    NSLog(@"obj 指针所指向内存大小：%zd", malloc_size((__bridge const void *)obj));
}

// 实例对象中只放类的成员变量，没必要放在实例对象中，创建多个对象可以共用方法列表
- (void)test1 {
    CCRuntimePerson *person = [[CCRuntimePerson alloc] init];
    // person.name = @"zerocc";  malloc_size 字符串的初始化需注意分析
    person.name = [NSString stringWithFormat:@"zeroccccccccccccccc"];
    person.age = 18;
    [person studyCourse:@"iOS"];
    
    // 获得NSObject实例对象的成员变量所占用的大小 = 24 ??????
    NSLog(@"person 成员变量所占字节：%zd", class_getInstanceSize([CCRuntimePerson class]));
    
    // 获得obj指针所指向内存的大小 = 32 (字节对齐的缘故一定是 16 的倍数)
    NSLog(@"person 指针所指向内存大小：%zd", malloc_size((__bridge const void *)person));
}

#pragma mark - 对象的种类

- (void)test2 {
    // 1. 实例对象  每次alloc出来都是一个新对象在内存地址中，储着 isa指针和成员变量信息
    NSObject *object1 = [[NSObject alloc] init];
    NSObject *object2 = [[NSObject alloc] init];
    
    // 2. 类对象   一个类的类对象，每个类在内存中只有同一个类对象，存储着 isa指针、superclass指针、类的属性信息 @property、类的对象方法、类的协议信息 protocol、类的成员变量信息 ivar (是指成员变量类型信息 具体值还是在实例对象中)
    Class objectClass = [NSObject class];
    Class objectClass1 = [object1 class];
    Class objectClass11 = object_getClass(object1);
    
    Class objectClass2 = [object2 class];
    Class objectClass22 = object_getClass(object2);
    
    NSLog(@"object1:%p object2:%p",object1,object2);
    NSLog(@"objectClass:%p objectClass1:%p objectClass11:%p objectClass2:%p objectClass22:%p",
          objectClass,objectClass1,objectClass11,objectClass2,objectClass22);
    
    // 3. 元类对象 每个类只有一个元类对象，存储着 isa指针、superclass指针，类的类方法
    // 将类对象当做参数传入，获得元类对象
    Class objectMetaClass = object_getClass(objectClass);
    BOOL isMetaClass = class_isMetaClass(objectMetaClass);
    NSLog(@"objectMetaClass: %p %d", objectMetaClass,isMetaClass);
    
    NSLog(@"%d",class_isMetaClass([NSObject class])); // 打印0
    
    
    /*
     实例对象 类对象 元类对象结构都是一样的是 objc_class 结构体
     struct objc_class : objc_object {
     // Class ISA;
     Class superclass;
     cache_t cache;             // formerly cache pointer and vtable
     class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags

     }
    struct objc_object {
    private:
        isa_t isa;
        
    public:
        
        // ISA() assumes this is NOT a tagged pointer object
        Class ISA();
        
        // getIsa() allows this to be a tagged pointer object
        Class getIsa();
     ...
     }
     
    */
    
    /*
    Class object_getClass(id obj) {
        if (obj) return obj->getIsa();
        else return Nil;
    }
     
     a. 如果是instance对象，返回class对象
     b. 如果是class对象，返回meta-class对象
     c. 如果是meta-class对象，返回NSObject（基类）的meta-class对象
        任何meta-class对象都指向基类的meta-class对象
     */
    
    BOOL result = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL result1 = [[NSObject class] isMemberOfClass:[NSObject class]];
//    BOOL result1 = [NSObject isMemberOfClass:NSObject];

    NSLog(@"%d %d",result, result1);
}

#pragma mark - 方法的调用 (isa指针指向)  isa & ISA_MASK
- (void)test3 {
    CCRuntimePerson *person = [[CCRuntimePerson alloc] init];
    // objc_msgSend(person, @selector(personInstanceMethod)) 实例对象通过 isa 指针查找到类对象继而调用实例方法
    [person studyCourse:@"iOS"];
    // objc_msgSend([CCRuntimePerson class], @selector(personClassMethod)) 类对象通过 isa 指针查找到元类对象继而调用类方法
    [CCRuntimePerson play];
    
    // isa 指针是查找对象自身的 类对象对象方法实现 元类对象类方法实现
    //superclass 指针是查找继承结构的，查类对象superclass指针指向父类的类对象，元类对象superclass执向父类的元类对象
    
    // isa & ISA_MASK 对象 类对象 元类对象地址址
    // #   define ISA_MASK        0x00000001fffffff8ULL

}


@end
