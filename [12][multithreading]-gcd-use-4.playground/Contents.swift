import UIKit
import Dispatch
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*:
 dispatch_apply 在Swift 中不存在了， 可以使用如下的方法代替，但是这个有可能将任务派发到主队列，不知道会不会影响主线程的性能
 */
DispatchQueue.concurrentPerform(iterations: 20) { (index) in
    print("\(index) \(Thread.current)")
}

/*:
 disaptch_once 已经去掉了，可以使用 let 代替
 */
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}

/*:
 GCD 取消任务 DispatchWorkItem 是可以取消的
 */
let workItem = DispatchWorkItem {
    print("workItem")
}
// 可以在结束（可能是正常结束，也可能是被取消）后通知
workItem.notify(queue: DispatchQueue.main) {
    print("workItem notify \(workItem.isCancelled)")
}
DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
//workItem.cancel()

