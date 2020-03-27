import Foundation

func pi() -> Double {
    return 3.14
}

// 形参默认是let，也只能是let
func sum(v1: Int, v2: Int) -> Int {
    return v1 + v2
}
sum(v1: 10, v2: 20)

// 无返回值的3种写法
// 按照Swift定义，Void就是空元组
func sayHello1() -> Void {
    print("Hello")
}
func sayHello2() -> () {
    print("Hello")
}
func sayHello3() {
    print("Hello")
}

// 隐式返回
// 如果整个函数体是一个单一表达式，那么函数会隐式返回这个表达式
func sum2(v1: Int, v2: Int) -> Int {
    v1 + v2
}
sum2(v1: 10, v2: 20)

// 返回元组：实现多返回值。
func calculate(v1: Int, v2: Int) -> (sum: Int, difference: Int, average: Int) {
    let sum = v1 + v2
    return (sum, v1 - v2, sum >> 1 /*右移就是除 2^1*/)
}

let result = calculate(v1: 20, v2: 10)
result.sum // 30
result.difference // 10
result.average // 15

//函数的文档注释
/// 求和【概述】
///
/// 将2个整数相加【更详细的描述】
///
/// - Parameter v1: 第1个整数
/// - Parameter v2: 第2个整数
/// - Returns: 2个整数的和
///
/// - Note: 传入2个整数即可【批注】
///
func sum3(v1: Int, v2: Int) -> Int {v1 + v2}

// 修改标签
func goToWork(at time: String) {
    print("this time is \(time)")
}

// 使用下划线_省略参数标签
func sum4(_ v1: Int, _ v2: Int) -> Int {
    v1 + v2
}
sum4(10, 20)

// 默认参数值
func check(name: String = "nobody", age: Int, job: String = "none") {
    print("name=\(name), age=\(age), job=\(job)")
}
check(name: "Jack", age: 20, job: "Doctor")
check(name: "Rose", age: 18)
check(age:10, job: "Batman")
check(age: 15)

// 在省略参数标签时，需要特别注意，避免出错
// 这里的middle不可以省略参数标签
func test(_ first: Int = 10, middle: Int, _ last: Int = 30) {
    print("first:\(first), middle:\(middle), last:\(last)")
}
test(middle: 20)

// 可变参数（可变参数不能标记为inout）
func sum5(_ numbers: Int...) ->Int {
    var total = 0
    for number in numbers {
        total += number
    }
    return total
}
sum5(10, 20, 30, 40) // 100
// 一个函数最多只能有1个可变参数
// 紧跟在可变参数后面的参数不能省略参数标签
func test2(_ numbers: Int..., string: String, _ other: String) { }
test2(10, 20, 30, string: "Jack", "Rose")

// 输入输出参数：inout，可以在函数内部修改外部实参的值
// inout 参数不能有默认值
// 通过汇编可知，inout的本质是地址传递（引用传递），它是在函数里面修改变量的值，所以它不能是let常量
var number = 10
func add(_ num: inout Int) {
    num += 1;
}
add(&number) // number = 11

var numbers = [10, 20, 30]
numbers[0] = 20
numbers[0] = 30
func test3(_ num: inout Int) {
    
}
// 从这里可以看出，不只是变量，凡是能被多次赋值的，都可以传进去
test3(&numbers[0])

/* 函数重载 （Function Overload）
 规则：
 1. 函数名相同
 2. 参数个数不同 || 参数类型不同 || 参数标签不同
*/
func sumA(v1: Int, v2: Int) -> Int {
    v1 + v2
}
func sumA(v1: Int, v2: Int, v3: Int) -> Int {
    v1 + v2 + v3
} // 参数个数不同

/*
 内联函数 （Inline Function）
 如果编译器开启了优化（Release模式默认会开启优化），编译器会自动将某些函数变成内联函数
 . 将函数调用展开成函数体
 哪些函数不会内联：
 1. 函数体比较长（会增加代码量，最后增加包体积）
 2. 包含递归调用
 3. 包含动态派发
 
 在Release模式下，编译器已经开启优化，会自动决定哪些函数需要内联，因此没必要使用@inline
 */

// 永远不会被内联（即使开启了编译优化）
@inline(never) func test() {
    print("test")
}
// 开启编译优化后，即使代码很长，也会被内联（递归调用函数，动态派发函数除外）
@inline(__always) func test2() {
    print("test")
}

/*
 函数类型
 每一个函数都是具有类型的，函数类型由形式参数、返回值类型组成
 */
func testA() {} // () -> Void 或者 () -> ()
func sumB(a: Int, b: Int) -> Int {
    a + b
} // (Int, Int) -> Int
var fn: (Int, Int) -> Int = sumB
fn(2, 3) // 5. 调用时不需要参数标签

// 函数类型作为函数参数
func difference(v1: Int, v2: Int) -> Int {
    v1 - v2
}
func printResult(_ mathFn: (Int, Int) -> Int, a: Int, b: Int) {
    print("result is \(mathFn(a, b))")
}
printResult(sumB, a: 2, b: 3)
printResult(difference, a: 10, b: 6)

// 函数类型作为函数返回值（返回值是函数类型的函数，叫做高阶函数）
func next(_ input: Int) -> Int {
    input + 1
}
func previous(_ input: Int) -> Int {
    input - 1
}

func forward(_ forward: Bool) -> (Int) -> Int {
    forward ? next : previous
}
forward(true)(3) // 4
forward(false)(3) // 2

// typealias（给类型起别名）
typealias Date = (year: Int, month: Int, day: Int)
func testC(_ date: Date) {
    print(date.0)
    print(date.year)
}
testC((2011, 9, 10))

typealias IntFn = (Int, Int) -> Int

// 嵌套函数：将函数定义在函数内部。如果不希望某些函数让外部调用，可以这么做
func forward2(_ forward: Bool) -> (Int) -> Int {
    func next(_ input: Int) -> Int {
        input + 1
    }
    func previous(_ input: Int) -> Int {
        input - 1
    }
        
    return forward ? next : previous
}
forward2(true)(3) // 4
forward2(false)(3) // 2

