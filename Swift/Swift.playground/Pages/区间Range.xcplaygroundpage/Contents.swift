let names = ["Anna", "Alex", "Brian", "Jack"]
for i in 0...3 {
    print(names[i])
}
let range = 1...3
for i in range {
    print(names[i])
}
// 区间运算符用在数组上
for name in names[0...3] {
    print(name)
}
// 单侧区间：让区间朝一个方向尽可能的远
for name in names[2...] {
    print(name)
} // Brian Jack

for name in names[...2] {
    print(name)
} // Anna Alex Brian

for name in names[..<2] {
    print(name)
} // Anna Alex

let range0 = ...5
range0.contains(7) // false
range0.contains(4) // true
range0.contains(-3) // true

// 区间类型
let range1: ClosedRange<Int> = 1...3
let range2: Range<Int> = 1..<3
let range3: PartialRangeThrough<Int> = ...5

// 字符、字符串也能使用区间运算符，但默认不能用在for-ins中
let stringRange1 = "cc"..."ff" // ClosedRange<String>
stringRange1.contains("cb") // false
stringRange1.contains("dz") // true
stringRange1.contains("fg") // false

let stringRange2 = "a"..."f"
stringRange2.contains("d") // true
stringRange2.contains("h") // false

// "\0" 到 "~" 囊括了所有可能要用到的ASCII字符
let characterRange: ClosedRange<Character> = "\0"..."~"
characterRange.contains("G") // true

// 带间隔的区间值
let hours = 11
let hourInterval = 2
// tickMark的取值：从4开始，累加到2，不超过11
for tickMark in stride(from: 4, through: hours /* through是闭区间 */, by: hourInterval) {
    print(tickMark)
} // 4 6 8 10
for tickMark in stride(from: 4, to: hours /* to是开区间 */, by: hourInterval) {
    print(tickMark)
} // 4 6 8 10













