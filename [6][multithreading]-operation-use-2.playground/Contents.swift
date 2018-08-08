import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//XCPlaygroundPage.currentPage.finishExecution()

let mainQueue = OperationQueue.main

let customeQueue = OperationQueue()

// 通过设置 maxConcurrentOperationCount 来区分串行并发队列
// isSuspended 设置队列是否暂停 Alamofire 处理返回的数据是用的队列 开始队列是暂停的，等到网络请求结束后，启动队列
customeQueue.maxConcurrentOperationCount = 2
customeQueue.isSuspended = true

customeQueue.addOperation {
    print("1 \(Thread.current)")
}

customeQueue.addOperation {
    print("2 \(Thread.current)")
}

let operation = BlockOperation {
    print("3 \(Thread.current)")
}
customeQueue.addOperation(operation)

//customeQueue.cancelAllOperations()
//operation.cancel()

print("underlyingQueue \(customeQueue.underlyingQueue)")
let allOperations = customeQueue.operations
print("operationCount \(customeQueue.operationCount)")

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    customeQueue.isSuspended = false
}

