//
//  ViewController.m
//  RunLoop学习
//
//  Created by 张倍浩 on 2020/2/28.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "ViewController.h"
#import "MJThread.h"

@interface ViewController ()

@property (nonatomic, strong) MJThread *thread;
@property (nonatomic, assign) BOOL stopped;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.stopped = NO;
    self.thread = [[MJThread alloc] initWithBlock:^{
        // 开启runloop
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
        while (weakSelf && !weakSelf.stopped) {
            [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"---end---");
    }];
    [self.thread start];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:<#(nonnull NSNotificationName)#> object:<#(nullable id)#>];
    [[NSNotificationCenter defaultCenter] addObserver:<#(nonnull id)#> selector:<#(nonnull SEL)#> name:<#(nullable NSNotificationName)#> object:<#(nullable id)#>];
    
}

- (void)doThings {
    if (!self.thread) return;
    [self performSelector:@selector(eat) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)eat {
    NSLog(@"吃东西");
}

- (void)stopThread {
    if (!self.thread) return;
    
    // 在子线程调用stopThread（waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走）
    [self performSelector:@selector(stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stop {
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 清空线程
    self.thread = nil;
}


- (void)runloop {
    /*
    thread
    modes
    currentmodel
    modelitems
    commonModes
    ...
    */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observerCallback, NULL);
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
        NSLog(@"%@", [NSRunLoop currentRunLoop]);
        CFRelease(observer);
        
    //    CFRunLoopPerformBlock(<#CFRunLoopRef rl#>, <#CFTypeRef mode#>, <#^(void)block#>);
}


void (observerCallback)(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
        {
            NSLog(@"kCFRunLoopEntry");
        }
            break;
        case kCFRunLoopBeforeTimers:
        {
            NSLog(@"kCFRunLoopBeforeTimers");
        }
            break;
            
        case kCFRunLoopBeforeSources:
        {
            NSLog(@"kCFRunLoopBeforeSources");
        }
            break;
            
        case kCFRunLoopBeforeWaiting:
        {
            NSLog(@"kCFRunLoopBeforeWaiting");
        }
            break;
            
        case kCFRunLoopAfterWaiting:
        {
            NSLog(@"kCFRunLoopAfterWaiting");
        }
            break;
            
        case kCFRunLoopExit:
        {
            NSLog(@"kCFRunLoopExit");
        }
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"----touch began");
    [self doThings];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopThread];
    });
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
