//
//  MJPthreadMutexDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/1.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJPthreadMutexDemo.h"
#import <pthread.h>
// 递归锁：允许同一个线程对一把锁进行重复加锁
/*
 mutex叫做“互斥锁”，等待锁的线程处于休眠状态
 导入头文件 #import <pthread.h>
 // 初始化锁的属性
 pthread_mutexattr_t attr;
 pthread_mutexattr_init(&attr);
 // PTHREAD_MUTEX_RECURSIVE（递归锁）, PTHREAD_MUTEX_NORMAL ...
 pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
 // 初始化锁
 pthread_mutex_t mutex;
 pthread_mutex_init(&mutex, &attr);
 // 尝试加锁
 pthread_mutex_trylock(&mutex);
 // 加锁
 pthread_mutex_lock(&mutex);
 // 解锁
 pthread_mutex_unlock(&mutex);
 // 销毁相关资源
 pthread_mutexattr_destroy(&attr);
 pthread_mutex_destroy(&mutex); // 在锁用完之后，销毁掉
 */

@interface MJPthreadMutexDemo ()

// pthread_mutex_t 是一个结构体类型
@property (nonatomic, assign) pthread_mutex_t ticketMutex;
@property (nonatomic, assign) pthread_mutex_t moneyMutex;
@property (nonatomic, assign) pthread_mutex_t recursiveMutex; // 可以实现递归

@property (nonatomic, assign) pthread_mutex_t condMutex; // 条件锁
@property (nonatomic, assign) pthread_cond_t cond;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation MJPthreadMutexDemo

- (void)__initMutex:(pthread_mutex_t *)mutex attrtype:(int)attrtype {
    /**
     // 静态初始化
     pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
     self.ticketLock = mutex;
     // 结构体类型，必须在定义变量的同时进行赋值，这是语法规定的。
     self.moneyMutex = PTHREAD_MUTEX_INITIALIZER; // 错误
     */
    
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, attrtype);
    // 初始化锁
//    pthread_mutex_init(mutex, &attr); // 第二个参数可以传空NULL，表示default
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init {
    if (self = [super init]) {
        self.data = [NSMutableArray array];
        
        [self __initMutex:&_ticketMutex attrtype:PTHREAD_MUTEX_DEFAULT];
        [self __initMutex:&_moneyMutex attrtype:PTHREAD_MUTEX_DEFAULT];
        [self __initMutex:&_recursiveMutex attrtype:PTHREAD_MUTEX_RECURSIVE];
        [self __initMutex:&_condMutex attrtype:PTHREAD_MUTEX_DEFAULT];
        
        // 初始化条件
        pthread_cond_init(&_cond, NULL);
    }
    return self;
}

- (void)otherTest {
//    [self recursiveTest];
    [self condTest];
    
}

- (void)condTest {
    // 先执行哪条线程的任务是不确定的
    [[[NSThread alloc] initWithBlock:^{
        [self __remove];
    }] start];
    sleep(1);
    [[[NSThread alloc] initWithBlock:^{
        [self __add];
    }] start];
}

- (void)__remove {
    NSLog(@"---remove begin---");
    pthread_mutex_lock(&_condMutex);
    NSLog(@"remove加锁");
    if (self.data.count == 0) {
        // 带有条件的等待。在条件没被唤醒前，这里会有一次解锁。当条件唤醒后，这里又会进行一次加锁，if里面执行完毕后，会接着往下走。
        pthread_cond_wait(&_cond, &_condMutex);
        NSLog(@"wait cond");
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    pthread_mutex_unlock(&_condMutex);
}

- (void)__add {
    NSLog(@"---add begin---");
    pthread_mutex_lock(&_condMutex);
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    // 1. 信号，通知等待的cond继续执行只能唤醒一个线程。
    /* 2. 唤醒线程时，pthread_cond_wait开始对所在线程进行加锁，__add方法所在线程目前还没解锁，所以要等该线程解锁后，才能在 pthread_cond_wait 中重新加锁。综上：必须等__add方法走完后，才能走 __remove方法的pthread_cond_wait后面的代码
     如果先pthread_mutex_unlock，再pthread_cond_signal，就能先执行pthread_cond_wait后面的代码了。不在锁范围内的代码是不受锁约束的
     3. 如果没有要唤醒的线程，这个方法相当于啥也没干
     */
    pthread_cond_signal(&_cond);
    // 广播，如果有多个cond在等待，通过广播告知所有cond的线程继续执行任务。即一次唤醒多个线程。
//    pthread_cond_broadcast(&_cond);
    sleep(1);
    NSLog(@"哈哈哈");
    pthread_mutex_unlock(&_condMutex);
}

- (void)recursiveTest {// 通过递归锁，进行递归调用
    pthread_mutex_lock(&_recursiveMutex);
    NSLog(@"%s", __func__);
    static int count = 0;
    count++;
    if (count < 5) {
        [self otherTest];
    }
    
    pthread_mutex_unlock(&_recursiveMutex);
}

-(void)__saleTicket {
    pthread_mutex_lock(&_ticketMutex);
    [super __saleTicket];
    pthread_mutex_unlock(&_ticketMutex);
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)dealloc {
    pthread_mutex_destroy(&_ticketMutex);
    pthread_mutex_destroy(&_moneyMutex);
    
    pthread_mutex_destroy(&_recursiveMutex);
    
    pthread_mutex_destroy(&_condMutex);
    pthread_cond_destroy(&_cond);
}

@end
