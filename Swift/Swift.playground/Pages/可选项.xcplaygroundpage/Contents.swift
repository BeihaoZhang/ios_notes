// 可选项绑定
// 如果包含就自动解包，把值赋给一个临时的常量(let)或者变量(var)，并返回true，否则返回false
if let number = Int("123") { // number作用域仅限于if这个大括号
    print("字符串转换整数成功：\(number)")
} else {
    print("字符串转换整数失败")
}

enum Season : Int {
    case spring = 1, summer, autumn, winter
}

if let season = Season(rawValue: 6) {
    switch season {
    case .spring:
        print("the season is spring")
    default:
        print("the season is other")
    }
} else {
    print("no such season")
}

// while循环中使用可选绑定
var strs = ["10", "20", "abc", "-20", "30"]
var index = 0
var sum = 0
while let num = Int(strs[index]), num > 0 {
    sum += num
    index += 1
}
print(sum)

// 空合并运算符 ??
/*
 a ?? b
 a 是可选项
 b 是可选项 或者 不是可选项
 b 跟 a 的存储类型必须相同
 如果 a 不为nil，就返回 a，但是如果 b 不是可选项，返回 a 时会自动解包
 如果 a 为nil，就返回b
// 如果b不是可选项，返回 a 时会自动解包
 
 可以看出，?? 返回的类型取决于 b
 */
let a1: Int? = 1
let b1: Int? = 2
let c1 = a1 ?? b1 // c1是Int?，Optional(1)

let a2: Int? = nil
let b2: Int? = 2
let c2 = a2 ?? b2 //c2是Int?，Optional(2)

let a3: Int? = nil
let b3: Int? = nil
let c3 = a3 ?? b3 // c是Int?，nil

let a4: Int? = 1
let b4: Int = 2
let c4 = a4 ?? b4 // c是Int，1

let a5: Int? = nil
let b5: Int = 2
let c5 = a5 ?? b5 // c是Int，2

print(c1, c2, c3, c4, c5) // Optional(1) Optional(2) nil 1 2

// ?? 跟 if-let 配合使用
let a: Int? = nil
let b: Int? = 2
if let c = a ?? b { // 类似于 if a!= nil || b != nil
    print(c)
}

if let c = a, let d = b { // 类似于 if a != nil && b!= nil
    print(c, d)
}

// guard语句
/*
 guard 条件 else {
 // do something......
 退出当前作用域
 // return、break、continue、throw error
 }
 */
// 当使用guard语句进行可选项绑定时，绑定的常量(let)、变量(var)也能在外层作用域中使用
func login(_ info: [String : String]) {
    guard let username = info["username"] else {  return }
    guard let password = info["password"] else { return }
    print("用户名：\(username)，密码：\(password)")
}
login(["username": "John", "password": "marry"])



/* 隐式解包（开发中尽量少用）
 在某些情况下，可选项一旦被设定值之后，就会一直拥有值
 在这种情况下，可以去掉检查，也不必每次访问的时候都进行解包，因为它能确定每次访问的时候都有值
 可以在类型后面加个感叹号!，定义一个隐式解包的可选项
 */
let num1: Int! = 10 // Int!会隐式解包，但一定要确保是有值的
let num2 = num1
if num1 != nil {
    print(num1 + 6) // 16
}
if let num3 = num1 {
    print(num3)
}


/* 多重可选项
 var num1: Int? = 10
 var num2: Int?? = num1
 var num3: Int?? = 10
 print(num2 == num3) // true
 
 ----------------------------------
 
 var num1: Int? = nil
 var num2: Int?? = num1
 var num3: Int?? = nil
 print(num2 == num3) // false
 
 ----------------------------------
 
 var num1: Int? = nil
 var num2: Int?? = num1
 var num3: Int?? = nil
 print(num1 == num3) // false
 
 (lldb) fr v -R num1
 (Swift.Optional<Swift.Int>) num1 = none {
   some = {
     _value = 0
   }
 }
 (lldb) fr v -R num3
 (Swift.Optional<Swift.Optional<Swift.Int>>) num3 = none {
   some = some {
     some = {
       _value = 0
     }
   }
 }
 
 */







