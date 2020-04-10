//
//  TimeWheel.swift
//  SwiftTest-CommandLine
//
//  Created by 张倍浩 on 2020/4/10.
//  Copyright © 2020 Lincoln. All rights reserved.
//
//  摘录自知识小集：基于时间轮片方式处理超时任务 https://mp.weixin.qq.com/s/DjAfM5uopCSAA6dHUPUvZQ
//

import Foundation

protocol TimeWheelDelegate: class {
    func timeoutItems(_ items: [Any]?, _ timeWhell: TimeWheel)
}

// MARK: 时间轮片定义
class TimeWheel {
    private var capacity: Int
    private var interval: TimeInterval
    private var timeWheel: [[Any]]
    var index: Int
    private var timer: Timer?
    weak var delegate: TimeWheelDelegate?
    
    init(_ capacity: Int, _ interval: TimeInterval) {
        self.capacity = capacity
        self.interval = interval
        self.index = 0
        timeWheel = []
        for _ in 0 ..< capacity { // 先填充数组，创建若干个“空槽”
            self.timeWheel.append(contentsOf: [])
        }
    }
    
    func addObject(_ task: Any) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(detectTimeoutItem(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
        
        if index < timeWheel.count {
            var arr = timeWheel[index]
            arr.append(task)
            timeWheel[index] = arr
        }
    }
    
    func currentObject() -> [Any]? {
        if index < timeWheel.count {
            return timeWheel[index]
        }
        return nil
    }
    
    func cleanup() {
        self.timeWheel.removeAll()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func removeExpiredObjects() {
        if index < timeWheel.count {
            var arr = timeWheel[index]
            arr.removeAll()
        }
    }
    
    private func moveToNextTimeSlot() {
        index = (index + 1) % timeWheel.count
    }
    
    @objc
    private func detectTimeoutItem(_ timer: Timer) {
        moveToNextTimeSlot()
        delegate?.timeoutItems(self.currentObject(), self)
        removeExpiredObjects()
    }
}

// MARK: - 任务
protocol Task {
    associatedtype T
    func taskKey() -> String // 任务对应的唯一key，用于区分任务
    func doTask() -> T // 实现任务行为
    var completion: ((_ result: T?, _ timeout: Bool) -> Void)? {get set} // 返回的异步结果
}

class NetworkTask: Task {
    typealias T = String
    var completion: ((String?, Bool) -> Void)?
    
    var hostName: String
    
    init(_ name: String) {
        hostName = name
    }
    
    func taskKey() -> String {
        return hostName
    }
    
    func doTask() -> String {
        // 模拟耗时任务
        Thread.sleep(forTimeInterval: Double.random(in: 1 ... 20))
        return "\(hostName)'s result"
    }
}

// MARK: - 任务管理
/*
 为了保证任务的独立允许，需要创建一个并发队列，且使用字典存储已添加的任务，以便确认任务是按时完成回调的，还是超时导致回调的。
 */
class TaskManager<T: Task> : TimeWheelDelegate {
    
    private var timeWheel: TimeWheel?
    private var timeInterval: TimeInterval
    private var timeoutSeconds: Int
    private var queue: DispatchQueue
    private var callbackDict: Dictionary<String, T>
    
    init(_ timeout: Int, _ timeInterval: TimeInterval) {
        timeoutSeconds = timeout
        self.timeInterval = timeInterval
        queue = DispatchQueue(label: "com.task.queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        callbackDict = [:]
    }
    
    func appendTask(_ task: T, _ completion:@escaping (_ result: T.T?, _ timeout: Bool) -> (Void)) {
        if timeWheel == nil {
            timeWheel = TimeWheel(timeoutSeconds, timeInterval)
            timeWheel?.delegate = self
        }
        
        var task = task
        task.completion = completion
        self.callbackDict[task.taskKey()] = task
        // 将任务添加到时间轮槽位中
        self.timeWheel?.addObject(task)
        
        self.queue.async {
            let result = task.doTask()
            DispatchQueue.main.async { // 保证数据的一致性
                let key = task.taskKey()
                if let item = self.callbackDict[key] {
                    // 返回按时完成任务的结果
                    item.completion?(result, false)
                    self.callbackDict.removeValue(forKey: key)
                }
            }
        }
    }
    
    func timeoutItems(_ items: [Any]?, _ timeWhell: TimeWheel) {
        if let callbacks = items {
            for callback in callbacks {
                if let item = callback as? T,
                   let task = self.callbackDict[item.taskKey()]
                {
                    task.completion?(nil, true)
                    self.callbackDict.removeValue(forKey: task.taskKey())
                }
            }
        }
    }
}

// MARK: - 使用示例
func sample() {
    let manager = TaskManager<NetworkTask>(10, 1)
    for i in 0 ..< 5 {
        let task = NetworkTask("host-\(i)")
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...20.0)) {
            print("task:\(task.hostName) do task in \(Date.init())")
            manager.appendTask(task) { (result, timeout) -> (Void) in
                print("task:\(task.hostName), result:\(result ?? "null"), timeout:\(timeout), time:\(Date.init())")
            }
        }
    }
}
