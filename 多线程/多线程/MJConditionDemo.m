//
//  MJConditionDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/3.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJConditionDemo.h"

@interface MJConditionDemo ()

@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation MJConditionDemo

- (instancetype)init {
    if (self = [super init]) {
        self.data = [NSMutableArray array];
        self.condition = [[NSCondition alloc] init];
    }
    return self;
}

- (void)__rmeove {
    [self.condition lock];
    if (self.data.count == 0) {
        // 等待
        [self.condition wait];
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    [self.condition unlock];
}

- (void)__add {
    [self.condition lock];
    sleep(1);
    [self.data addObject:@"Test"];
    [self.condition signal];
//    [self.condition broadcast];
    [self.condition unlock];
}

@end
