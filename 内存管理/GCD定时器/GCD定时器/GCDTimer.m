//
//  GCDTimer.m
//  GCD定时器
//
//  Created by 张倍浩 on 2020/3/4.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "GCDTimer.h"

@implementation GCDTimer

static NSMutableDictionary *timers_;
// 多线程访问字典需要加锁
static dispatch_semaphore_t semaphore_;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)execTask:(void(^)(void))task
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async
{
    if(!task || start < 0 || (interval <= 0 && repeats)) return nil;
            
    // 定时器的回调在哪个队列中执行
    dispatch_queue_t queue = async ?
      dispatch_get_global_queue(0, 0)
    : dispatch_get_main_queue();
            
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    // 定时器的唯一标识
    NSString *ID = [NSString stringWithFormat:@"%zd", timers_.count];
    timers_[ID] = timer;
    dispatch_semaphore_signal(semaphore_);
         
         // 通过block设置回调
    dispatch_source_set_event_handler(timer, ^ {
        task();
        if (!repeats) {
            [self cancelTask:ID];
        }
    });
         
    dispatch_resume(timer);
    
    return ID;
}

+ (NSString *)execTaskWithTarget:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async
{
    if (!target || !selector) return nil;
    return [self execTask:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    } start:start interval:interval repeats:repeats async:async];
}

+ (void)cancelTask:(NSString *)name
{
    if (name.length == 0) return;
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore_);
}

@end
