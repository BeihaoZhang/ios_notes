//
//  MJSemaphoreDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/3.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJSemaphoreDemo.h"

#define SemaphoreBegin \
static dispatch_semaphore_t semaphore; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    semaphore = dispatch_semaphore_create(1); \
}); \
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

#define SemaphoreEnd \
dispatch_semaphore_signal(semaphore);


@interface MJSemaphoreDemo ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation MJSemaphoreDemo

- (instancetype)init {
    if (self = [super init]) {
        // 信号量的初始值，可以用来控制线程并发访问的最大数量。要实现线程同步，传1
        self.semaphore = dispatch_semaphore_create(5);
    }
    return self;
}

- (void)otherTest {
    for (int i = 0; i < 20; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

- (void)test {
    // 如果信号量的值<=0，当前线程就会进入休眠等待（直到信号量的值>0）
    // 如果信号量的值>0，就减1，然后往下执行后面的代码
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    // 保证这个任务同一时刻最多有5个线程在执行
    NSLog(@"test - %@", [NSThread currentThread]);
    // 让信号量的值加1
    dispatch_semaphore_signal(self.semaphore);
}

// 使用技巧：test1, test2, test3 这样写的话就能保证每个方法的锁都是不一样的
- (void)test1 {
    /*
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        semaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    // ...
    
    dispatch_semaphore_signal(semaphore);
     */
    
    // 后面的封号写不写都行
    SemaphoreBegin
    // ...
    SemaphoreEnd
    
}

- (void)test2 {
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        semaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    // ...
    
    dispatch_semaphore_signal(semaphore);
}

- (void)test3 {
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        semaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    // ...
    
    dispatch_semaphore_signal(semaphore);
}

@end
