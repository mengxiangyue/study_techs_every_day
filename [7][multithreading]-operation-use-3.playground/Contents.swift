import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*:
 ### Operation 优先级
 
 queuePriority 属性决定了进入准备就绪状态下的操作之间的开始执行顺序。并且，优先级不能取代依赖关系
 
 ```
 public enum QueuePriority : Int {
    case veryLow
    case low
    case normal
    case high
    case veryHigh
 }
 ```
 */

let operation1 = BlockOperation {
    print("1 \(Thread.current)")
}

let operation2 = BlockOperation {
    print("2 \(Thread.current)")
}

operation2.queuePriority = .high

let customeQueue = OperationQueue()
customeQueue.maxConcurrentOperationCount = 2
customeQueue.isSuspended = true
customeQueue.addOperation(operation1)
customeQueue.addOperation(operation2)
//for index in 10...20 {
//    let operation = BlockOperation {
//        print("\(index) \(Thread.current)")
//    }
//    operation.queuePriority = .veryHigh
//    customeQueue.addOperation(operation)
//}

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    customeQueue.isSuspended = false
}

/*:
 ### 线程间的通信
 */

customeQueue.addOperation {
    print("running in custome queue")
    let text = "this is data in custome queue"
    OperationQueue.main.addOperation({
        print("running in main queue")
        print("get from custome queue: \(text)")
    })
}

/*:
 ### Tips for Implementing Operation Objects
 * Managing Memory in Operation Objects
 * Avoid Per-Thread Storage
 * Keep References to Your Operation Object As Needed
 * Handling Errors and Exceptions
 */


/*:
 参考文章：
 [https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html](https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html)
 */
