//
//  ViewController.m
//  KVONatureSearch
//
//  Created by 卢育彪 on 2018/12/29.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, strong) Person *per1;
@property (nonatomic, strong) Person *per2;

@end

struct lyb_objc_class {
    Class _Nonnull isa;
    Class _Nullable super_class;
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*添加kvo与否的区别
     1.类名：NSNotifying_Person，继承Person，地址不同;
       方法：地址不同；
     2.类对象的结构不同：setAge:、class、dealloc、_isKVOA;
     3.实现原理：setter方法重写；
     */
    
    self.per1 = [[Person alloc] init];
//    self.per1.age = 1;
    self.per1->_age = 1;
    
//    self.per2 = [[Person alloc] init];
//    self.per2.age = 2;
    
//    [self test1];
//    [self test2];
    [self test3];
    
}

//1.类名：NSNotifying_Person，继承Person，地址不同;方法：地址不同；
- (void)test1
{
    Class per1Class1 = object_getClass(self.per1);
    Class per2Class2 = object_getClass(self.per2);
    NSLog(@"添加kvo之前---className：%@ %@ %p %p", per1Class1, per2Class2, per1Class1, per2Class2);
    NSLog(@"添加kvo之前---setter：%p %p", [self.per1 methodForSelector:@selector(setAge:)], [self.per2 methodForSelector:@selector(setAge:)]);
    
    //基本使用
    [self.per1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:@"per1"];
    
    Class per1Class3 = object_getClass(self.per1);
    Class per2Class4 = object_getClass(self.per2);
    NSLog(@"添加kvo之后---className：%@ %@ %p %p", per1Class3, per2Class4, per1Class3, per2Class4);
    NSLog(@"添加kvo之后---setter：%p %p", [self.per1 methodForSelector:@selector(setAge:)], [self.per2 methodForSelector:@selector(setAge:)]);
}

//2.类对象的结构不同：setAge:、class、dealloc、_isKVOA;
- (void)test2
{
    //基本使用
    [self.per1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:@"per1"];
    
    [self fetchClassMethods:object_getClass(self.per1)];
    [self fetchClassMethods:object_getClass(self.per2)];
    
    struct lyb_objc_class *per1Class = (__bridge struct lyb_objc_class *)object_getClass(self.per1);
    Class per2Class = object_getClass(self.per2);
    
    Class per1Class2 = [self.per1 class];
    
    //打断点
    int i = 0;
}

- (void)test3
{
    NSLog(@"添加kvo之前---setter：%p %p", [self.per1 methodForSelector:@selector(setAge:)], [self.per2 methodForSelector:@selector(setAge:)]);
    
    //基本使用
    [self.per1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:@"per1"];
    
    NSLog(@"添加kvo之后---setter：%p %p", [self.per1 methodForSelector:@selector(setAge:)], [self.per2 methodForSelector:@selector(setAge:)]);
    
    //打断点
    int i = 0;
}

- (void)fetchClassMethods:(Class)cls
{
    unsigned int count;
    NSMutableString *names = [NSMutableString string];
    
    Method *methodList = class_copyMethodList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        Method meth = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(meth));
        [names appendFormat:@"%@, ", methodName];
    }
    
    free(methodList);
    NSLog(@"%@ %@", cls, names);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监测到%@的属性%@已经改变%@---%@", object, keyPath, change, context);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    [self.per1 willChangeValueForKey:@"age"];
//    self.per1.age = 20;
//    self.per1->_age = 20;
    //打开了
    [self.per1 didChangeValueForKey:@"age"];
    
//    self.per1.age = 30;
}


@end
