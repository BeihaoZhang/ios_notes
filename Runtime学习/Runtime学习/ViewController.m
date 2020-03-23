//
//  ViewController.m
//  Runtime学习
//
//  Created by 张倍浩 on 2020/3/10.
//  Copyright © 2020 Lincoln. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

/*
 instance实例对象
 NSObject *object = [NSObject new];
 Q：object实例对象在内存中占用几个字节？
 A：object实例对象就是一个结构体，里面有个isa指针，所以占用的字节数是一个指针变量的占用大小，在64位下是8个字节。
 注意内存对齐的问题
 
 注意：实例对象可以存储成员变量的值，但是成员变量的类型和名字、类的实例方法、属性、协议等等不是在实例对象中存储的，是在类对象中存储
 
 Q：类里面存放了哪些信息？
 A：如下
 Class类对象
 每个类在内存中有且只有一个class对象
 class类对象在内存中存储的信息主要包括：
 1. isa指针
 2. superclass指针
 3. 类的属性信息（@property）、类的对象方法信息（instance method）
 4. 类的协议信息（protocol）、类的成员变量信息（ivar）
 ...
 
 meta-class元类对象
 每个类在在内存中有且只有一个meta-class对象
 meta-class对象和class对象的内存结构是一样的（因为类型都是Class），但是用途不一样
 meta-class在内存中存储的信息主要包括：(虽然和class的内存结构一样，但是它里面的属性信息可能是空的)
 1. isa指针
 2. superclass指针
 3. 类的类方法信息（class method）
 ...
 
 <objc/runtime>中，object_getClass(id obj)方法：传入实例对象，返回类对象；传入类对象，返回元类对象。
 通过 [xxx class]方法返回的只能是class类对象，不是元类对象
 
 Q：isa的作用是什么？
 A：
 instance的isa指向Class。
当调用对象方法时（[p test];），通过instance的isa找到Class，最后找到对象方法的实现调用
 class的isa指向meta-class
当调用类方法时（[Person test2]），通过class的isa找到meta-class，最后找到类方法的实现进行调用
 
 Q：superclass指针的作用？
 A：当Student的instance对象要调用Person的对象方法时，会先通过isa指针找到Student的class，然后通过Student的superclass找到Person的class，最后找到对象方法的实现进行调用
 
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    object_getClass(<#id  _Nullable obj#>)
//    class_getSuperclass(<#Class  _Nullable __unsafe_unretained cls#>)
    
//    object_setClass(<#id  _Nullable obj#>, <#Class  _Nonnull __unsafe_unretained cls#>)
    NSObject *obj;
    Ivar;

}


@end
