import UIKit
import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*:
 #### 1. NSInvocationOperation
 NSInvocation is disabled in Swift, therefore, NSInvocationOperation is disabled too.
 
 Because it's not type-safe or ARC-safe. Even in Objective-C it's very very easy to shoot yourself in the foot trying to use it, especially under ARC. Use closures/blocks instead.
 */

/*:
 #### 2. NSBlockOperation
 */
do {
    let operation = BlockOperation {
        print("\(Thread.current)")
    }
    
    // 可以后续追加 block 但是调用的线程就不一定了
    operation.addExecutionBlock {
        print("new add block \(Thread.current)")
    }
    // 可以不添加到 queue 中执行。调用 start 方法后不能再添加 block。一般第一个添加的 block 会在 start 调用线程执行，但是不是百分之百。
    // 一般情况下，如果一个 NSBlockOperation 对象封装了多个操作。NSBlockOperation 是否开启新线程，取决于操作的个数。如果添加的操作的个数多，就会自动开启新线程。当然开启的线程数是由系统来决定的
//    operation.start()
    // 可以添加执行结束 block
}

do {
    class DownloadOperation: Operation {
        override func main() {
            if isCancelled == false {
                Thread.sleep(forTimeInterval: 2)
                print("after Sleep \(Thread.current)")
            }
        }
    }
    let operation = DownloadOperation()
    // 可以添加执行结束 block
    operation.completionBlock = {
        print("completionBlock")
    }
//    operation.start()
}

/*:
 下面的属性可以kvo
 * isCancelled
 * isConcurrent
 * isExecuting
 * isFinished
 * isReady
 * dependencies
 * queuePriority
 * completionBlock
 */
do {
    class MyOperation: Operation {
        var _executing: Bool = false
        var _finished: Bool = false
        var _ready: Bool = true
        
        /* 推荐使用这种 更加 swifty
        private var _isExecuting: Bool {
            willSet { willChangeValue(forKey: "isExecuting") }
            didSet { didChangeValue(forKey: "isExecuting") }
        }
        
        private var _isFinished: Bool {
            willSet { willChangeValue(forKey: "isFinished") }
            didSet { didChangeValue(forKey: "isFinished") }
        }
        */
        
        override var isConcurrent: Bool {
            return true
        }
        override var isExecuting: Bool {
            return _executing
        }
        override var isFinished: Bool {
            return _finished
        }
        override var isReady: Bool {
            return _ready
        }
        
        override func start() {
            if isCancelled {
                willChangeValue(forKey: "isFinished")
                _finished = true
                didChangeValue(forKey: "isFinished")
                return
            }
            willChangeValue(forKey: "isExecuting")
            Thread.detachNewThreadSelector(#selector(self.main), toTarget: self, with: nil)
            _executing = true
            didChangeValue(forKey: "isExecuting")
        }
        
        override func main() {
            if isCancelled == false {
                Thread.sleep(forTimeInterval: 2)
                print("after Sleep \(Thread.current)")
                completeOperation()
            }
        }
        
        func completeOperation() {
            willChangeValue(forKey: "isFinished")
            willChangeValue(forKey: "isExecuting")
            _executing = false
            _finished = true
            didChangeValue(forKey: "isExecuting")
            didChangeValue(forKey: "isFinished")
        }
    }
    
    let operation = MyOperation()
//    operation.start()
    
    operation._ready = false
    let operation1 = MyOperation()
    operation1.addDependency(operation)
    print("operation1 dependencies: \(operation1.dependencies)")
    let queue = OperationQueue()
    queue.addOperation(operation)
    queue.addOperation(operation1)
}

/*:
 参考文章：
 * [https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html](https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html)
 */
 
