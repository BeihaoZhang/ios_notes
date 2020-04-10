//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

var arr: Array = [Any]()
for i in 0 ..< 5 {
    arr.append([i])
}
print(arr)
var arr2 = arr[0] as! Array<Int>
print(arr2)
arr2.append(contentsOf: [1, 2, 3])
print(arr2)
print(arr[0])
arr[0] = arr2
print(arr[0])
print(arr)

