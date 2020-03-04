//
//  ViewController.m
//  多线程
//
//  Created by 张倍浩 on 2020/2/29.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "ViewController.h"
#import "MJSpinLockDemo.h"
#import "MJUnfairLockDemo.h"
#import "MJPthreadMutexDemo.h"
#import "MJConditionLockDemo.h"
#import "MJSerialQueueDemo.h"
#import "MJSemaphoreDemo.h"
#import "MJReadWriteSecurityDemo.h"

/*
 （一）断点调试技巧：
 si：执行每行汇编代码，如果碰到函数，进到函数内部，继续每行执行
 nexti：执行每行汇编代码，碰到函数，不会进到函数内部
 c：进到下个断点
 bt：打印调用栈
 */

// 哈希表原理：通过一个key取出一个索引，然后从数组里面找到value


/*
 （二）线程同步、异步、串行、并发
 
 异步：具备开启新线程的能力
 同步：不具备开启新线程的能力
 串行：任务一个一个执行
 并发：任务在一段时间内同时执行
 
 注意：主队列的异步不会开启新线程
 死锁的条件：使用sync函数往 "当前" "串行" 队列中添加任务，会卡住当前的串行队列，产生死锁
 */

/*
 不要认为一想到线程同步就是加锁，这是错误的。线程同步的本质就是不能让多条线程占用同一份资源。就是让它按顺序来
 */

/*
 （三）iOS 中的线程同步方案
 自旋锁：加锁后，等待锁的线程忙等，就叫自旋锁。
 互斥锁：加锁后，等待锁的线程休眠了，就叫互斥锁。
 
 相关用法与讲解看各自的demo
 
 自旋锁：OSSpinLock
 互斥锁：os_unfair_lock、pthread_mutex、dispatch_semaphore
 线程同步方案
 OSSpinLock 自旋锁，加锁后，等待锁的线程忙等
 os_unfair_lock 互斥锁，加锁后，等待锁的线程休眠
 pthread_mutex 互斥锁，加锁后，等待锁的线程休眠
 dispatch_semaphore：信号量，信号量的初始值，可以用来控制线程并发访问的最大数量
 dispatch_queue(DISPATCH_QUEUE_SERIAL)：串行队列（它不是加锁，但也能实现线程同步）
 NSLock：对 pthread_mutex 普通锁的封装
 NSRecursiveLock：对 pthread_mutex 递归锁的封装
 NSCondition：是对 pthread_mutex 和 pthread_cond_t(条件) 的封装，即有锁，又有条件。
 NSConditionLock：是对 NSCondition 的进一步封装，可以设置具体的条件值，可以通过 lockWhenCondition: 方法实现线程间的l依赖
 @synchronized：是对 pthread_mutex 递归锁的封装。苹果不推荐使用，因为性能比较差。
 */
/*
 OSSpinLock：
 叫做“自旋锁”，等待锁的线程会处于忙等（busy-wait）状态，一直占用着CPU资源
 目前已经不再安全。可能会出现优先级反转问题
 如果等待锁的线程优先级高，它会一直占用着CPU资源，优先级低的线程就无法继续执行，也就无法释放锁。会造成一种类似死锁的现象
 
 NSLock：是对mutex普通锁的封装
 // 在这个时间之前，如果这把锁能放开的话，就给n这把锁加锁，相当于这个时间还没到，会一直等，代码卡住。在规定的时间内能等到这把锁，就加锁成功，返回YES，代码继续执行。
 - (BOOL)lockBeforeDate:(NSDate *)limit;
 */

/*
 性能从高到低排序
 os_unfair_lock（iOS10 开始）
 OSSpinLock（有bug，不推荐使用）
 dispatch_semaphore（更推荐使用这个）
 pthread_mutex（推荐使用）
 dispatch_queue(DISPATCH_QUEUE_SERIAL)
 NSLock
 NSCondition
 pthread_mutex(recursive)
 NSRecursiveLock
 NSConditionLock
 @synchronized
 
 */

/*
 自旋锁、互斥锁比较
 Q：什么情况下使用自旋锁比较划算？
 A：
 首先，OSSpinLock是个自选锁，但会出现优先级反转，所以不推荐使用。而它的替代方案os_unfair_lock从调试过程来看，是个互斥锁。所以在iOS中不用纠结这个问题。
 因为自旋锁是指加锁后，等待的线程忙等，所以，以下情况，用自旋锁比较划算：
 1）预计线程等待锁的时间很短
 2）加锁的代码（临界区）经常被调用，并且线程竞争情况很少发生时
 3）CPU资源不紧张时（因为自旋锁会一直占用CPU资源）
 4）多核处理器
 
 Q：什么情况使用互斥锁比较划算？
 A：
 1）预计线程等待锁的时间较长
 2）单核处理器
 3）临界区有IO操作（如文件读取与写入，因为IO操作比较占用CPU资源，如果用自旋锁，它在自旋的过程中也要占用CPU资源，会导致CPUi资源更加紧张）
 4）临界区代码复杂或者循环量大
 5）临界区竞争非常激烈
 
 */


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    MJBaseDemo *demo = [[MJSemaphoreDemo alloc] init];
//    [demo moneyTest];
//    [demo ticketTest];
//    [demo otherTest];
    
    // 多读单写
    MJReadWriteSecurityDemo *demo = [[MJReadWriteSecurityDemo alloc] init];
    [demo test];
    
}






@end
