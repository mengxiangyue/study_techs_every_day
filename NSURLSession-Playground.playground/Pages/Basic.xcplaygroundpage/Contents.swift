//: Playground - noun: a place where people can play

import UIKit
//import XCPlayground
import PlaygroundSupport

// 延迟运行
PlaygroundPage.current.needsIndefiniteExecution = true

//: ## Session Config
//: * 默认会话模式（default）：工作模式类似于原来的NSURLConnection，使用的是基于磁盘缓存的持久化策略，使用用户keychain中保存的证书进行认证授权。
//: * 瞬时会话模式（ephemeral）：该模式不使用磁盘保存任何数据。所有和会话相关的caches，证书，cookies等都被保存在RAM中，因此当程序使会话无效，这些缓存的数据就会被自动清空。
//: * 后台会话模式（background）：该模式在后台完成上传和下载，在创建Configuration对象的时候需要提供一个NSString类型的ID用于标识完成工作的后台会话。

URLSessionConfiguration.default
URLSessionConfiguration.ephemeral // 暂时的 程序关闭后 相关访问记录将不会存在
URLSessionConfiguration.background(withIdentifier: "custom identifier")

//: ## 创建NSURLSession
var session = URLSession(configuration: .default)

//: ## 定义请求类型
enum RequestType: String {
    case GET, POST, PUT, DELETE
}

//: ## Data Task
//: ### GET
let get  = {
    let url = URL(string: "http://httpbin.org/get")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    let task = session.dataTask(with: request) { (data, response, error) in
        do {
            let returnedResponse = try JSONSerialization.jsonObject(with: data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
    }
get()

//: ### POST
let post = {
    let url = URL(string: "http://httpbin.org/post")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.POST.rawValue
    // 设置参数 直接设置request.httpBody 两种方式
    request.httpBody = "access_token=xxxxx&status=微博内容".data(using: String.Encoding.utf8)
    do {
        let parameters = ["user-name": "@孟祥月_iOS", "password": "password"]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
    } catch let error as NSError {
        print(error)
    }
    let task = session.dataTask(with: request) { (data, response, error) in
        do {
            let returnedResponse = try JSONSerialization.jsonObject(with: data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
    }
//post()

//: ## Set Header
let setHeader = {
    let url = URL(string: "http://httpbin.org/get")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    let task = session.dataTask(with: request) { (data, response, error) in
        do {
            let returnedResponse = try JSONSerialization.jsonObject(with: data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
    }
//setHeader()

//: ## Set Global Header
let setGlobalHeader = {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = ["testHeader": "xxx-me"]
    let session = URLSession(configuration:config)
    let url = URL(string: "http://httpbin.org/get")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    let task = session.dataTask(with: request) { (data, response, error) in
        do {
            let returnedResponse = try JSONSerialization.jsonObject(with: data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
}
//setGlobalHeader()

//: ## Set Cookie
let setCookie = {
    let cookieStore = HTTPCookieStorage.shared
    cookieStore.cookieAcceptPolicy = .always
    let cookie = HTTPCookie(properties: [HTTPCookiePropertyKey.name: "cookie-name", HTTPCookiePropertyKey.value: "cookie-value", HTTPCookiePropertyKey.path: "/cookies", HTTPCookiePropertyKey.domain: "httpbin.org"])
    if let cookie = cookie {
        cookieStore.setCookie(cookie)
    }
    let url = URL(string: "http://httpbin.org/cookies")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    let task = session.dataTask(with: request) { (data, response, error) in
        do {
            let returnedResponse = try JSONSerialization.jsonObject(with: data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
}
//setCookie()


//: ## statusCode
let statusCode = {
    let url = URL(string: "http://httpbin.org/status/500")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        if let response = response as? HTTPURLResponse {
            print(response.statusCode)
        }
    }
    task.resume()
}
//statusCode()

//: ## redirect 
//: 拦截302 必须设置delegate 实现对应的回调方法
let redirect = {
    class CustomSessionDelegate: NSObject, URLSessionTaskDelegate {
        // 必须使用@objc标注 否则没有作用
        
        func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
            print("包含302状态的Response Header字段 ： \(response.allHeaderFields)")
            completionHandler(nil) // 取消302跳转
//            completionHandler(request)
        }
    }
    
    let url = URL(string: "http://httpbin.org/redirect/1")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: CustomSessionDelegate(), delegateQueue: nil)
    let task = session.dataTask(with: request) { (data, response, error) in
        
        if let response = response as? HTTPURLResponse {
            print(response.statusCode)
            
        }
        do {
            let returnedResponse = try JSONSerialization.jsonObject(with: data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
}
redirect()

//: ## Basic Authentication
let basicAuthentication = {
    let url = URL(string: "http://httpbin.org/basic-auth/user/passwd")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    
    let credentialsString = "user:passwd"
    if let credentialsData = credentialsString.data(using: String.Encoding.utf8) {
        credentialsData.base64EncodedData()
        let base64Credentials = credentialsData.base64EncodedString()
        let authString = "Basic \(base64Credentials)"
        
        let config  = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
        session = URLSession(configuration: config)
    }
    
    let task = session.dataTask(with: request) { (data, response, error) in
        if let response = response as? HTTPURLResponse {
            print(response.statusCode)
        }
        do {
            let returnedResponse = try JSONSerialization.jsonObject(with: data!, options: [])
            print(returnedResponse)
        } catch let JSONError as NSError {
            print("error: \(JSONError)")
        }
    }
    task.resume()
}
//basicAuthentication()


//: [Upload](@next)









