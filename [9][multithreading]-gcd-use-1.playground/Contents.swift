import UIKit

import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

// 获取队列
let mainQueue = DispatchQueue.main

/*
 DispatchQoS.QoSClass
 userInteractive  //最高优先级,用于UI更新等与用户交互的操作.
 userInitiated    //初始化优先级，用于初始化等，
 default          //默认优先级
 utility          //低优先级
 background       //后台级,用户用户无法感知的一些数据处理

 > 异步执行，GCD就可能会去创建线程(如果是 mainQueue 不会)，但是如果是串行队列，虽然是可能在不同线程上执行，但是还是会等到前一个完成后执行下一个。
 */
let backgroundQueue = DispatchQueue.global(qos: .background)
let defaultQueue = DispatchQueue.global()

// 创建一个串行队列
let customSerialQueue = DispatchQueue(label: "io.yuange")
customSerialQueue.async {
    print("1 \(Thread.current)")
    Thread.sleep(forTimeInterval: 2)
    print("1- \(Thread.current)")
}

customSerialQueue.async {
    print("2 \(Thread.current)")
}


// 并行队列
let customeConcurrentQueue = DispatchQueue(label: "io.yuange.concurrent", attributes: .concurrent)
customeConcurrentQueue.async {
    print("3 \(Thread.current)")
    Thread.sleep(forTimeInterval: 2)
    print("3- \(Thread.current)")
}

customeConcurrentQueue.async {
    print("4 \(Thread.current)")
}

// 并发队列串行添加 将没有并发功能
customeConcurrentQueue.sync {
    print("5 \(Thread.current)")
    Thread.sleep(forTimeInterval: 2)
    print("5- \(Thread.current)")
}

customeConcurrentQueue.sync {
    print("6 \(Thread.current)")
}

/*:
![image](gcd_thread_pool.jpg)
 */




