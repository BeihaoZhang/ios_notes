import Foundation

/*
在所有的结构体中，编译器会自动生成初始化器（initializer，初始化方法、构造器、构造方法）
编译器会根据具体情况，可能会为结构体生成多个初始化器，宗旨是：保证所有成员都有初始化值
结构体中的成员，在Swift中叫做存储属性
*/
struct Date {
    var year: Int
    var month: Int
    var day: Int
}
var date = Date(year: 2020, month: 3, day: 28)

struct Point {
    var x: Int = 0
    var y: Int
}
var p1 = Point(x: 10, y: 20)
var p2 = Point(y: 20)

// 可选项都有个默认值nil，因此可以编译通过
struct Point2 {
    var x: Int?
    var y: Int?
}
var p3 = Point2()
var p4 = Point2(x: 10, y: 10)
var p5 = Point2(x: 10)
var p6 = Point2(y: 10)

// 一旦在定义结构体时自定义了初始化器，编译器就不会再帮它自动生成其他初始化器
// 初始化方法不用写 func、return
struct Point3 {
    var x: Int // 或者设置默认值，var x: Int = 0
    var y: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    init() { // 如果没有传x,y，则self.y = 0 等价于 y = 0
        x = 0
        y = 0
    }
}
var p7 = Point3(x: 10, y: 10)
var p8 = Point3()



// 类的定义和结构体类似，但编译器并没有为类自动生成可以传入成员值的初始化器
/*
 如果类的所有成员都在定义的时候指定了初始化值，编译器会为类生成无参的初始化器
 。成员的初始化是在这个初始化器中完成的 
 */
class Point_Class {
    var x = 10
    var y = 20
}
let p_class = Point_Class()

/*
 汇编小技巧
 PS：前面的0x4bdc这些地址只是举例
 
 内存地址格式为：0x4bdc(%rip)，一般是全局变量，全局区（数据段）
 
 内存地址格式为：-0x78(%rbp)，一般是局部变量，栈空间
 
 内存地址格式为：0x10(%rax)，一般是堆空间
 */
