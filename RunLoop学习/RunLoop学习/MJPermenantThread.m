//
//  MJPermenantThread.m
//  RunLoop学习
//
//  Created by 张倍浩 on 2020/2/29.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJPermenantThread.h"

@interface MJPermenantThread ()

@property (nonatomic, strong) NSThread *innerThread;

@end

@implementation MJPermenantThread

- (instancetype)init {
    if (self = [super init]) {
        self.innerThread = [[NSThread alloc] initWithBlock:^{
            NSLog(@"---begian---");
            // 创建上下文（要初始化一下结构体，否则里面会有一些垃圾值）
            CFRunLoopSourceContext context = {0};
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            CFRelease(source);
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
//            while (weakSelf && !weakSelf.isStopped) {
//                // 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
//                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
//            }
            NSLog(@"---end---");
        }];
        [self.innerThread start];
    }
    return self;
}

- (void)executeTask:(TaskBlock)task {
    if (!self.innerThread || !task) return;
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)__executeTask:(TaskBlock)task {
    task();
}

- (void)stop {
    if (!self.innerThread) return;
    [self performSelector:@selector(stopThread) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)stopThread {
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)dealloc {
    [self stop];
}

@end
