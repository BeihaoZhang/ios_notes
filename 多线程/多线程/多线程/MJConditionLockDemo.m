//
//  MJConditionLockDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/3.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJConditionLockDemo.h"

@interface MJConditionLockDemo ()

@property (nonatomic, strong) NSConditionLock *conditionLock;

@end

@implementation MJConditionLockDemo

- (instancetype)init {
    if (self = [super init]) {
        // 如果s初始化时不设置条件值，默认就为0
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
    }
    return self;
}

- (void)otherTest {
    [[[NSThread alloc] initWithBlock:^{[self __one];}] start];
    [[[NSThread alloc] initWithBlock:^{[self __two];}] start];
    [[[NSThread alloc] initWithBlock:^{[self __three];}] start];
}

- (void)__one {
//    [self.conditionLock lock]; // 这里没有设置条件，会忽略条件的限制，直接加锁
    // 如果condition不成立，就一直等待
    [self.conditionLock lockWhenCondition:1];
    NSLog(@"1");
    sleep(1);
    [self.conditionLock unlockWithCondition:2];
}

- (void)__two {
    [self.conditionLock lockWhenCondition:2];
    NSLog(@"2");
    [self.conditionLock unlockWithCondition:3];
}

- (void)__three {
    [self.conditionLock lockWhenCondition:3];
    NSLog(@"3");
    [self.conditionLock unlock];
}



@end
