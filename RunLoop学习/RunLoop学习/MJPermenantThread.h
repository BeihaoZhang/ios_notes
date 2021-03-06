//
//  MJPermenantThread.h
//  RunLoop学习
//
//  Created by 张倍浩 on 2020/2/29.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TaskBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MJPermenantThread : NSObject

//- (void)run;
- (void)stop;

- (void)executeTask:(TaskBlock)task;

@end

NS_ASSUME_NONNULL_END
