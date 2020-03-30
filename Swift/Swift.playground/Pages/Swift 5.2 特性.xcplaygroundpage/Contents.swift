import Foundation

/* SE-0249：将 Key Path 表达式作为函数 */
struct User {
    let name: String
    let age: Int
    let bestFriend: String?
    
    var canVote: Bool {
        age >= 18
    }
}

let eric = User(name: "Eric Effiong", age: 18, bestFriend: "Otis Milburn")
let maeve = User(name: "Maeve Wiley", age: 19, bestFriend: nil)
let otis = User(name: "Otis Milburn", age: 17, bestFriend: "Eric Effiong")
let users = [eric, maeve, otis]
// 新写法：获取所有用户的name值
let userNames = users.map(\.name)
// 旧写法：通过闭包手动获取 name 值
//let userNames = users.map {$0.name}

print(userNames)
// 返回所有可以投票的用户
let votes = users.filter(\.canVote)
// 返回 bestFriend 不为空的用户的好友
let bestFriends = users.compactMap(\.bestFriend)

/* SE-0253：可调用类型
如果值的类型实现了一个名为 callAsFunction() 的方法，则现在可以直接以函数的方式来调用该类型的值
 callAsFunction() 可以定义多个，类似常规的重载一样
 */

struct Dice {
    var lowerBound: Int
    var upperBound: Int
    
    func callAsFunction() -> Int {
        (lowerBound...upperBound).randomElement()!
    }
}

let d6 = Dice(lowerBound: 1, upperBound: 6)
let roll1 = d6()
print(roll1)


struct StepCounter {
    var steps = 0
    mutating func callAsFunction(count: Int) -> Bool {
        steps += count
        print(steps)
        return steps > 10_000
    }
}

var steps = StepCounter()
let targetReached = steps(count: 10)



/* 下标可以声明默认参数值
比如在数组越界时，返回一个默认值
 */
struct PoliceForce {
    var officers: [String]
    // 需要注意的是，如果要让参数可用，则需要重复两次标签，因为下标是不使用参数标签的。
    subscript(index: Int, default default: String = "Unknow") -> String {
        if index >= 0 && index < officers.count {
            return officers[index]
        } else {
            return `default`
        }
    }
}

let force = PoliceForce(officers: ["Amy", "Jack", "Rosa", "Terry"])
print(force[0]) // Amy
print(force[5]) // Unknow
// 由于我在下标中使用了 default default ，所以可以使用如下自定义值
print(force[-1, default: "The Vulture"]) // The Vulture



/* lazy 序列的多个 filter 的顺序现在颠倒了
 如果您使用诸如数组之类的惰性序列，并对其应用多个过滤器，则这些过滤器现在将以相反的顺序运行。
 
 在Swift 5.2和更高版本中，上述代码将打印“ Samwell”和“ Stannis”，因为在第一个过滤器运行之后，这两个字符串是剩下的进入第二个过滤器的唯一名称。但是在Swift 5.2之前，则会打印所有四个名称，因为第二个过滤器将在第一个过滤器之前运行。这会令人困惑，因为如果删除 lazy，那么无论Swift 是哪个版本，代码始终只会返回Samwell和Stannis。

 这很有问题，因为其行为取决于代码的运行位置：如果您在iOS 13.3或更早版本或macOS 10.15.3或更早版本上运行Swift 5.2代码，则以原始的方式执行，但是在较新的操作系统上运行的相同代码将提供新的正确行为。
 */
let people = ["Arya", "Cersei", "Samwell", "Stannis"]
    .lazy
    .filter { $0.hasPrefix("S") }
    .filter { print($0); return true }
_ = people.count // Samwell Stannis

// 改进的错误诊断功能

