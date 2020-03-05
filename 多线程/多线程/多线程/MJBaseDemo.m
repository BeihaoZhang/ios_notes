//
//  MJBaseDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/1.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJBaseDemo.h"

@interface MJBaseDemo ()

@property (nonatomic, assign) int money;
@property (nonatomic, assign) int ticketsCount;

@end

@implementation MJBaseDemo

- (void)otherTest {}

- (void)ticketTest {
    self.ticketsCount = 15;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
}

- (void)__saleTicket {
        
        int oldTicketsCount = self.ticketsCount;
        sleep(.2);
        oldTicketsCount--;
        self.ticketsCount = oldTicketsCount;
        NSLog(@"还剩%d张票", oldTicketsCount);
}

- (void)moneyTest {
    self.money = 100;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __drawMoney];
        }
    });
}

// 存钱
- (void)__saveMoney {
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 10;
    self.money = oldMoney;
    NSLog(@"存10元，还剩：%d", self.money);
}

// 取钱
- (void)__drawMoney {
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 20;
    self.money = oldMoney;
    NSLog(@"取20元，还剩：%d", self.money);
}

@end
