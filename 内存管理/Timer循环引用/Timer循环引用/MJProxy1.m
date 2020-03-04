//
//  MJProxy1.m
//  Timer循环引用
//
//  Created by 张倍浩 on 2020/3/4.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJProxy1.h"

@implementation MJProxy1

+ (instancetype)proxyWithTarget:(id)target {
    MJProxy1 *proxy = [[MJProxy1 alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

@end
