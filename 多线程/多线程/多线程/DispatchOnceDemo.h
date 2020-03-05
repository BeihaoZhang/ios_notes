//
//  DispatchOnceDemo.h
//  多线程
//
//  Created by 张倍浩 on 2020/3/4.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManageA: NSObject

+ (instancetype)sharedInstance;

@end

@interface ManageB: NSObject

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
