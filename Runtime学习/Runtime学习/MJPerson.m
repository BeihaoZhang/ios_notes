//
//  MJPerson.m
//  Runtime学习
//
//  Created by 张倍浩 on 2020/3/17.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "MJPerson.h"

typedef NS_OPTIONS(NSUInteger, MJOption) {
    MJOptionOne = 1 << 0,
    MJOptionTwo = 1 << 1,
    MJOptionThree = 1 << 2,
    MJOptionFour = 1 << 3
};

void setOption(MJOption option) {
    if (option & MJOptionOne) {
        NSLog(@"包含MJOptionOne");
    }
    if (option & MJOptionTwo) {
        NSLog(@"包含MJOptionTwo");
    }
    if (option & MJOptionThree) {
        NSLog(@"包含MJOptionThree");
    }
    if (option & MJOptionFour) {
        NSLog(@"包含MJOptionFour");
    }
}

@implementation MJPerson

- (void)test {
    setOption(MJOptionOne | MJOptionThree);
    NSProxy;
}

@end
