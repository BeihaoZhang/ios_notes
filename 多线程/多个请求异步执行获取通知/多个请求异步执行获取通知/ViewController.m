//
//  ViewController.m
//  多个请求异步执行获取通知
//
//  Created by 张倍浩 on 2019/10/24.
//  Copyright © 2019 张倍浩. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self gcd_group_enter_leave];
    [self gcd_semaphore_wait_signal];
}

- (void)gcd_semaphore_wait_signal {
    dispatch_semaphore_t semphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"1 start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"1 end");
            dispatch_semaphore_signal(semphore);
        });
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"2 start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"2 end");
            dispatch_semaphore_signal(semphore);
        });
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"3 start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"3 end");
            dispatch_semaphore_signal(semphore);
        });
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
    });
    
}

- (void)gcd_group_enter_leave {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSLog(@"1 start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"1 end");
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSLog(@"2 start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"2 end");
            dispatch_group_leave(group);
        });
    });
        
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSLog(@"3 start");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"3 end");
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
    });
}


@end
