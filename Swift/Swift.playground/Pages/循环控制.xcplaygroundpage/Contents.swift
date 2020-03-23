import Foundation


var number = 1
switch number {
/*
 case、default后面不能写大括号{}。
 默认可以不写break，并不会贯穿到后面的条件
 case 后面至少要有1条语句
     错误
     case 1:
     case 2:
--------------
     正确
     case 1:
        fallthrough
     case 2:
        ...
--------------
     正确
     case 1, 2:
        ...
 */
case 1:
    /*
    {
        print("number is 1")
    }
 */
    print("number is 1")
    fallthrough // 可以贯穿
//    break
case 2:
    print("number is 2")
default:
    print("number is other")
//    break
}

// 如果能保证已处理所有情况，也可以不必使用default
enum Answer {case right, wrong}
let answer = Answer.right
switch answer {
case .right:
    print("right")
case .wrong:
    print("wrong")
}

/*
 switch复合条件
 switch也支持Character、String类型
 */
var age = 10
switch age {
case 1:
    fallthrough
case 2:
    print("1 2")
default:
    print("other")
}

// 区间匹配
let count = 62
switch count {
case 0:
    print("none")
case 1..<5:
    print("a few")
case 5..<12:
    print("several")
case 12..<100:
    print("dozens of")
case 100..<1000:
    print("hundreds of")
default:
    print("many")
}

// 元组匹配
let point = (1, 1)
switch point {
case (0, 0):
    print("the origin")
case (_, 0):
    print("on the x-axis")
case (0, _):
    print("on the y-axis")
case (-2...2, -2...2):
    print("inside the box")
default:
    print("outside of the box")
} // inside the box

// 值绑定：必要时，let也可以改为var
let point2 = (2, 0)
switch point2 {
case (let x, 0):
    print("on the x-asis with an x value of \(x)")
case (0, let y):
    print("on the y axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}

// where可以用在switch中，也可以用在for循环中
switch point {
case let (x, y) where x == y:
    print("on the line x == y")
case let (x, y) where x == -y:
    print("on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
} // on the line x == -y

// 将所有正数加起来
var numbers = [10, 20, -10, -20, 30, -30]
var sum = 0
for num in numbers where num > 0 { // 使用where来过滤num
    sum += num
}
print(sum) // 60


// 标签语句。原本这里的continue和break控制的是内部发for循环，通过标签可以控制外部的for循环
outer: for i in 1...4 {
    for k in 1...4 {
        if k == 3 {
            continue outer
        }
        if i == 3 {
            break outer
        }
        print("i == \(i), k == \(k)")
    }
}
