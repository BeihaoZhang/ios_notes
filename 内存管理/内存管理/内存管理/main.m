//
//  main.m
//  内存管理
//
//  Created by 张倍浩 on 2020/3/5.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        [appDelegateClassName retain];
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
