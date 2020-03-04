//
//  ViewController.m
//  Timer循环引用
//
//  Created by 张倍浩 on 2020/3/4.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "ViewController.h"
#import "MJProxy1.h"
#import "MJProxy2.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    MJProxy2 *proxy = [MJProxy2 proxyWithTarget:self];
    /* NSProxy对象的isKindOfClass，isMemberOfClass等方法实际上对target进行的消息转发。
     通过重写的methodSignatureForSelector 和 forwardInvocation 内部方法进行的转发。
     */
    NSLog(@"%d", [proxy isKindOfClass:[ViewController class]]); // 返回 1
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[MJProxy2 proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
}

- (void)timerTest {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.timer invalidate];
}

@end
