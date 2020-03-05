//
//  MJUnfairLockDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/1.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJUnfairLockDemo.h"
#import <os/lock.h>

/*
 os_unfair_lock 用于取代不安全的OSSpinLock，从iOS 10开始才支持
 从底层调用看，等待os_unfair_lock锁的线程处于休眠状态，并非忙等
 需要导入头文件 #import <os/lock.h>
 
 */

@interface MJUnfairLockDemo ()

@property (nonatomic, assign) os_unfair_lock moneyLock;
@property (nonatomic, assign) os_unfair_lock ticketLock;

@end

@implementation MJUnfairLockDemo

- (instancetype)init {
    if (self = [super init]) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__saleTicket {
//    os_unfair_lock_trylock(&_ticketLock) 跟OSSpinLock的用法一样
    os_unfair_lock_lock(&_ticketLock);
    [super __saleTicket];
    os_unfair_lock_unlock(&_ticketLock);
}

- (void)__saveMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

@end
