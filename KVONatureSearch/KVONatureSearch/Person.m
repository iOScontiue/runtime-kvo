//
//  Person.m
//  KVONatureSearch
//
//  Created by 卢育彪 on 2018/12/29.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)setAge:(int)age
{
    if (_age != age) {
        _age = age;
    }
    
    NSLog(@"setAge:");
}

//void _NSSetIntValueAndNotify()
//{
//    [self willChangeValueForKey:@"age"];
//    [super setAge:age];
//    [self didChangeValueForKey:@"age"];//kvo的监听方法在该方法中被触发
//}

- (void)willChangeValueForKey:(NSString *)key
{
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey");
}

- (void)didChangeValueForKey:(NSString *)key
{
    NSLog(@"didChangeValueForKey---begin");
    [super didChangeValueForKey:key];
    NSLog(@"didChangeValueForKey---end");
}

@end
