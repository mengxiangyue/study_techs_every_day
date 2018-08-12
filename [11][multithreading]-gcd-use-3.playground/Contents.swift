import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*:
 队列的挂起 系统队列无法挂起
 */

let defaultGlobalQueue = DispatchQueue.global()
//
defaultGlobalQueue.suspend()
defaultGlobalQueue.async {
    print("1 \(Thread.current)")
}

let customQueue = DispatchQueue(label: "io.yuange", attributes: .concurrent)
customQueue.suspend()
customQueue.async {
    print("2 \(Thread.current)")
}
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    customQueue.resume()
}

/*:
 dispatch_barrier_async
 */
let customQueue2 = DispatchQueue(label: "io.yuange", attributes: .concurrent)
customQueue2.async {
    print("3 \(Thread.current)")
}
customQueue2.async {
    print("4 \(Thread.current)")
}
let workItme = DispatchWorkItem(flags: .barrier) {
    print("barrier")
}
customQueue2.async(execute: workItme)
customQueue2.async {
    print("5 \(Thread.current)")
}


