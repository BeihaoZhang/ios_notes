//
//  ViewController.m
//  内存管理
//
//  Created by 张倍浩 on 2020/3/5.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "ViewController.h"
#import "MJPerson.h"


// 如果是iOS平台，指针的最高有效位是1，就是taggerPointer
#if TARGET_OS_IPHONE
#define _OBJC_TAG_MASK (1ul<<63)
#elif TARGET_OS_MAC
// 如果是Mac平台，指针的最低有效位是1，就是taggerPointer
#define _OBJC_TAG_MASK (1UL)
#endif

BOOL isTaggedPointer(id pointer) {
    return ((uintptr_t)pointer & _OBJC_TAG_MASK) == _OBJC_TAG_MASK;
}

@interface ViewController ()

@property (nonatomic, strong) MJPerson *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [[MJPerson alloc] init];
    // count=2 必须插入nil，否则会崩溃 EXC_BAD_ACCESS
    NSArray *array = [NSArray arrayWithObjects:@"1", @"2", nil, nil];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
