import UIKit
import Dispatch

import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*:
 ### 队列间的通信
 */

DispatchQueue.global().async {
    print("执行耗时任务 在后台")
    Thread.sleep(forTimeInterval: 2)
    let result = 2
    DispatchQueue.main.async {
        print("在主线程更新 \(result)\(Thread.current)")
    }
}

/*:
 ### 延迟执行
 */
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    print("已经延迟两秒后执行了")
}

//DispatchWallTime 用于计算绝对时间。
print("\(Date())")
let delaytimeInterval = Date().timeIntervalSince1970 + 2.0
let nowTimespec = timespec(tv_sec: __darwin_time_t(delaytimeInterval), tv_nsec: 0)
let delayWalltime = DispatchWallTime(timespec: nowTimespec)

DispatchQueue.main.asyncAfter(wallDeadline: delayWalltime) {
    print("使用绝对时间延迟两秒后执行\(Date())")
}

DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
    print("使用绝对时间延迟两秒后执行\(Date())")
}


/*:
 ### Group
 */

let group = DispatchGroup()
for index in 0...3 {
    DispatchQueue.global().async(group: group) {
        Thread.sleep(forTimeInterval: 1)
        print("任务 \(index) 执行完毕")
    }
}
group.notify(queue: DispatchQueue.main) {
    print("所有的任务结束了")
}

let manualGroup = DispatchGroup()
for index in 0...3 {
    manualGroup.enter()
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: 1)
        print("manualGroup 任务 \(index) 执行完毕")
        manualGroup.leave()
    }
}
manualGroup.notify(queue: DispatchQueue.main) {
    print("manualGroup 所有的任务结束了")
}
