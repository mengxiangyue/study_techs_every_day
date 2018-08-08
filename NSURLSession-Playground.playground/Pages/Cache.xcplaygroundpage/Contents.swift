//: [Previous](@previous)

import UIKit
import PlaygroundSupport

// 延迟运行
PlaygroundPage.current.needsIndefiniteExecution = true


//: ## 创建NSURLSession
var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

//: ## 定义请求类型
enum RequestType: String {
    case GET, POST, PUT, DELETE
}


//: ## Data Task
//: ### GET
//: * NSURLRequestUseProtocolCachePolicy // 默认的缓存策略（取决于协议）
//: * NSURLRequestReloadIgnoringLocalCacheData // 忽略缓存，重新请求
//: * NSURLRequestReloadIgnoringLocalAndRemoteCacheData // 未实现
//: * NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData // 忽略缓存，重新请求
//: * NSURLRequestReturnCacheDataElseLoad// 有缓存就用缓存，没有缓存就重新请求
//: * NSURLRequestReturnCacheDataDontLoad// 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
//: * NSURLRequestReloadRevalidatingCacheData // 未实现

let get  = {
    let myCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: NSTemporaryDirectory() + "/demo.cache")
    NSURLCache.setSharedURLCache(myCache)
    
    class CustomSessionDelegate: NSObject, NSURLSessionTaskDelegate {
        // 必须使用@objc标注 否则没有作用
        @objc func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            print("包含302状态的Response Header字段 ： \(response.allHeaderFields)")
            //            completionHandler(nil) // 取消302跳转
            completionHandler(request)
        }
    }
    
    let url = NSURL(string: "http://httpbin.org/get")
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = RequestType.GET.rawValue
    request.cachePolicy = .ReturnCacheDataElseLoad
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.URLCache = myCache
    config.requestCachePolicy = .ReturnCacheDataElseLoad
    
    
    let session = NSURLSession(configuration: config, delegate: CustomSessionDelegate(), delegateQueue: nil)
    
    let task = session.dataTaskWithRequest(request) { (data, response, error) in
        print("request")
        do {
            let returnedResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
}
get()


//: [Next](@next)
