//
//  MJSynchronizedDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/3.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJSynchronizedDemo.h"

@implementation MJSynchronizedDemo

- (void)__drawMoney {
    // @synchronized里面传的参数可以把它看成一把锁。
    /*
     内部实现：以传入的参数作为key，获取到value值SyncData，再从syncData中获取到 pthread_mutex进行实现。从源码中可以知道synchronized可以用来做递归锁
     */
    @synchronized ([self class]) {
        [super __drawMoney];
    }
}

- (void)__saveMoney {
    @synchronized ([self class]) {
        [super __saveMoney];
    }
}

- (void)__saleTicket {
    static dispatch_once_t onceToken;
    static NSObject *lock;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    
    @synchronized (lock) {
        [super __saleTicket];
    }
}

@end
