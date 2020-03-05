//
//  MJBaseDemo.h
//  多线程
//
//  Created by 张倍浩 on 2020/3/1.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJBaseDemo : NSObject

- (void)moneyTest;
- (void)ticketTest;

- (void)__saleTicket;
- (void)__saveMoney;
- (void)__drawMoney;

- (void)otherTest;

@end

NS_ASSUME_NONNULL_END
