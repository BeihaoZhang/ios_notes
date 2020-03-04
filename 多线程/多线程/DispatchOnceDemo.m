//
//  DispatchOnceDemo.m
//  多线程
//
//  Created by 张倍浩 on 2020/3/4.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "DispatchOnceDemo.h"

@implementation ManageA

+ (ManageA *)sharedInstance
{
    static ManageA *manager = nil;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        manager = [[ManageA alloc] init];
    });

    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [ManageB sharedInstance];
    }
    return self;
}

@end

@implementation ManageB

+ (ManageB *)sharedInstance
{
    static ManageB *manager = nil;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        manager = [[ManageB alloc] init];
    });

    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [ManageA sharedInstance];
    }
    return self;
}

@end
