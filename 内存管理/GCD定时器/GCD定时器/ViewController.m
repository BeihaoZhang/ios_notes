//
//  ViewController.m
//  GCD定时器
//
//  Created by 张倍浩 on 2020/3/4.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "ViewController.h"
#import "GCDTimer.h"
/*
 NSTimer是依赖于runloop的，如果当前循环中runloop任务很重，错过了执行时间，就只能在下次runloop循环中执行定时器的任务，所以NSTimer是不准时的。
 可以使用GCD的定时器，因为GCD定时器是直接跟系统内核挂钩的，而且是不依赖于runloop。即使主线程视图有滚动，也不影响GCD定时器。
 */
@interface ViewController ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) NSString *task;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.task = [GCDTimer execTask:^{
        NSLog(@"定时器");
    } start:1 interval:1 repeats:YES async:NO];
    
    self.task = [GCDTimer execTaskWithTarget:self selector:@selector(timeerTest123) start:1 interval:1 repeats:YES async:YES];
    
}

- (void)timeerTest123 {
    NSLog(@"123-%@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [GCDTimer cancelTask:self.task];
}

- (void)timerTest {
    // 定时器的回调在哪个队列中执行
    //    dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_queue_t queue = dispatch_queue_create("gcd_timer_queue", DISPATCH_QUEUE_SERIAL);
        
        // 创建定时器
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        // 设置时间（start是几秒后开始执行，interval是时间间隔，leeway是允许的误差）
    //    dispatch_source_set_timer(timer, <#dispatch_time_t start#>, <#uint64_t interval#>, <#uint64_t leeway#>)
        
        uint64_t start = 2.0; // 2秒后开始执行
        uint64_t interval = 1.0; // 每隔1秒执行
        // 传入的是纳秒
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        
        // 通过block设置回调
    //    dispatch_source_set_event_handler(self.timer, ^{
    //        NSLog(@"1111");
    //    });
        // 通过函数的方式添加回调
        dispatch_source_set_event_handler_f(self.timer, timerFire);
        
        dispatch_resume(self.timer);
}

void timerFire(void *params) {
    NSLog(@"222, %@", [NSThread currentThread]);
}

@end
