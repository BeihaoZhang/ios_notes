//
//  MJReadWriteSecurityDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/4.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJReadWriteSecurityDemo.h"
#import <pthread.h>

/* 多读单写
 
（一）多读单写需要满足以下条件：
1）同一时间，只能有1条线程进行写的操作
2）同一时间，允许有多条线程进行读的操作
3）同一时间，不允许既有写的操作，又有读的操作
 
 （二）实现方案
 1. pthread_rwlock：读写锁，等待锁的线程会进入休眠
 // 初始化
 pthread_rwlock_t lock
 pthread_rwlock_init(&lock, NULL);
 // 读-加锁
 pthread_rwlock_rdlock(&lock);
 // 读-尝试加锁
 pthread_rwlock_tryrdlock(&lock);
 // 写-加锁
 pthread_rwlock_wrlock(&lock);
 // 写-尝试加锁
 pthread_rwlock_trywrlock(&lock);
 // 解锁
 pthread_rwlock_unlock(&lock);
 // 销毁
 pthread_rwlock_destroy(&lock);
 
 
 
 2. dispatch_barrier_async：异步栅栏调用
 这个函数传入的并发队列必须是自己通过dispatch_queue_create创建的
 如果传入的是一个串行队列或是一个全局的并发队列，那这个函数就等同于dispatch_async函数的效果
 dispatch_queue_t queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
 // 读
 dispatch_async(queue, ^{
 
 });
 // 写（一旦进入这个函数，队列中的其他任务都会排队，等待写的任务的执行完毕）
 dispatch_barrier_async(queue, ^{
 
 });
 
 */

@interface MJReadWriteSecurityDemo ()

@property (nonatomic, assign) pthread_rwlock_t lock;

@end

@implementation MJReadWriteSecurityDemo

- (instancetype)init {
    if (self = [super init]) {
        pthread_rwlock_init(&_lock, NULL);
        
    }
    return self;
}

- (void)test {
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self __read];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self __write];
        });
    }
}

- (void)__read {
    pthread_rwlock_rdlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)__write {
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)dealloc {
    pthread_rwlock_destroy(&_lock);
}

@end
