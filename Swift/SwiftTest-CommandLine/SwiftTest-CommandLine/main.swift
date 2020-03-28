//
//  main.swift
//  SwiftTest-CommandLine
//
//  Created by 张倍浩 on 2020/3/27.
//  Copyright © 2020 Lincoln. All rights reserved.
//

import Foundation

// frame variable -R，简写成 fr v -R
var num3: Int? = nil // frame variable -R num3
var num4: Int?? = num3
var num5: Int?? = nil
print(num5 == num3) // false



func testEnum() {
    enum TestEnum {
        case test1, test2, test3
    } // size: 1, stride: 1
    let e = TestEnum.test1
    print(e)

    enum TestEnum0 {
        case test1
    } // size: 0, stride: 1

    enum TestEnum0_1 {
        case test1, test2
    } // size: 1, stride: 1

    print(MemoryLayout<TestEnum>.size, MemoryLayout<TestEnum>.stride)
}

testEnum()
