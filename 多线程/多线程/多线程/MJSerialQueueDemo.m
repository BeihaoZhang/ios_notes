//
//  MJSerialQueueDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/3.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJSerialQueueDemo.h"

@interface MJSerialQueueDemo ()

@property (nonatomic, strong) dispatch_queue_t ticketQueue;
@property (nonatomic, strong) dispatch_queue_t moneyQueue;

@end

@implementation MJSerialQueueDemo

- (instancetype)init {
    if (self = [super init]) {
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
        self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

/// 串行队列，存钱和取钱，同一时间只能执行一个
- (void)__drawMoney {
    // 因为基本的该方法本身就在子线程，所以这里用sync就好了，没必用async再去创建线程
    dispatch_sync(self.moneyQueue, ^{
        [super __drawMoney];
    });
    
}

- (void)__saveMoney {
        
    dispatch_sync(self.moneyQueue, ^{
        [super __saveMoney];
    });
    
}

- (void)__saleTicket {
    
    dispatch_sync(self.ticketQueue, ^{
        [super __saleTicket];
    });
    
}

@end
