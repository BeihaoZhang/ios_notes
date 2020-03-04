//
//  MJSpinLockDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/1.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJSpinLockDemo.h"
#import <libkern/OSAtomic.h>

/*
OSSpinLock：
叫做“自旋锁”，等待锁的线程会处于忙等（busy-wait）状态，一直占用着CPU资源
目前已经不再安全。可能会出现优先级反转问题
如果等待锁的线程优先级高，它会一直占用着CPU资源，优先级低的线程就无法继续执行，也就无法释放锁。会造成一种类似死锁的现象
是一种性能很高的锁。因为线程处于忙等，不让线程睡眠。因为线程一旦睡眠，再唤醒它，中间也是要耗性能的。
 需要导入头文件 #import <libkern/OSAtomic.h>
*/

@interface MJSpinLockDemo ()

@property (nonatomic, assign) OSSpinLock lock;
@property (nonatomic, assign) OSSpinLock lock1;

@end


@implementation MJSpinLockDemo

- (instancetype)init {
    if (self = [super init]) {
        self.lock = OS_SPINLOCK_INIT;
        self.lock1 = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__saleTicket {
    //    if (OSSpinLockTry(&_lock1)) { // 如果发现其他线程已经加过锁了，就没办法加锁了，所以加锁失败，返回NO，就不会阻塞线程。如果没被其他线程加锁，就进行加锁，返回YES
    //        int oldTicketsCount = self.ticketsCount;
    //        sleep(.2);
    //        oldTicketsCount--;
    //        self.ticketsCount = oldTicketsCount;
    //        NSLog(@"还剩%d张票", oldTicketsCount);
    //        OSSpinLockUnlock(&_lock1);
    //    }
    
    OSSpinLockLock(&_lock1);
    [super __saleTicket];
    OSSpinLockUnlock(&_lock1);
}

- (void)__saveMoney {
    OSSpinLockLock(&_lock);
    [super __saveMoney];
    OSSpinLockUnlock(&_lock);
}

- (void)__drawMoney {
    OSSpinLockLock(&_lock);
    [super __drawMoney];
    OSSpinLockUnlock(&_lock);
}

@end
