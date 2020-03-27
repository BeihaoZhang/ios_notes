enum Direction {
    case north
    case south
    case east
    case west
}

// 关联值
// 有时会将枚举的成员值跟其他类型的关联存储在一起
enum Score {
    case points(Int)
    case grade(Character)
}
var score = Score.points(96)
score = .grade("A")
switch score {
case let .points(i):
    print(i, "points")
case let .grade(i):
    print("grade", i)
} // grade A
 
// 原始值
// 枚举成员可以用相同类型的默认值预先关联，这默认值叫做：原始值
enum Grade: String {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}
print(Grade.perfect.rawValue) // A
print(Grade.great.rawValue) // B
print(Grade.good.rawValue) // C
print(Grade.bad.rawValue) // D

/*
 不允许这么写
enum GG {
    case aa: Int = 20
    case bb: String = "aaa"
}
*/

// 隐式原始值
// 如果枚举值的原始值类型是Int、String，Swift会自动分配原始值
enum Direction2: String {
    case notrh = "north"
    case south = "south"
    case east = "east"
    case west = "west"
}
// 等价于
enum Direction3: String {
    case north, south, east, west
}
print(Direction3.north) // north
print(Direction3.north.rawValue) // north

enum Season: Int {
    case spring, summer, autumn, winter
}
print(Season.spring.rawValue) // 0
print(Season.summer.rawValue) // 1
print(Season.autumn.rawValue) // 2
print(Season.winter.rawValue) // 3

// 递归枚举
// 要加上 indirect
indirect enum ArithExpr {
    case number(Int)
    case sum(ArithExpr, ArithExpr)
    case difference(ArithExpr, ArithExpr)
}
// 或者
enum ArithExpr2 {
    case number(Int)
    indirect case sum(ArithExpr, ArithExpr)
}

// 使用MemoryLayout获取数据类型占用的内存大小
var age = 10
MemoryLayout<Int>.size
MemoryLayout<Int>.stride
MemoryLayout<Int>.alignment
// 和上面的效果一样的
MemoryLayout.size(ofValue: age)
MemoryLayout.stride(ofValue: age)
MemoryLayout.alignment(ofValue: age)

// 关联值
enum Password {
    case value(Int, Int, Int, Int) // 32
    case other // 1
}
// stride：总共分配的内存大小，size：实际占用的内存大小，aligment：内存对齐的最小倍数
MemoryLayout<Password>.size // 33
MemoryLayout<Password>.stride // 40
MemoryLayout<Password>.alignment // 8

// 原始值
enum Season2: Int {
    case spring, summer, autumn, winter
}
MemoryLayout<Season2>.size // 1
MemoryLayout<Season2>.stride // 1
MemoryLayout<Season2>.alignment // 1

var ps = Password.value(2, 8, 9, 1)

/*
 枚举中原始值和关联值的存储问题
 关联值，传入的每个值，是存储到枚举变量里的，ps枚举变量中的(2, 8, 9, 1)每个int占4个字节，
 other单独占一个字节。因为通过关联值创建的枚举变量，它每个值都是不一样的
 
 原始值是跟每个成员固定绑在一起的，但是不会占用枚举变量内存的，就是说原始值不是存储在枚举变量内存中的
 */
