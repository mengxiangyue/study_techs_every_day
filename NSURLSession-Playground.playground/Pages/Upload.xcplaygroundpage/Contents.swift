//: [Previous](@previous)

import UIKit

import PlaygroundSupport

// 延迟运行
PlaygroundPage.current.needsIndefiniteExecution = true

//: ## 创建NSURLSession
var session = URLSession(configuration: URLSessionConfiguration.default)

//: ## 定义请求类型
enum RequestType: String {
    case GET, POST, PUT, DELETE
}

let image = UIImage(named: "1111.jpg")

let uploadImage = {
    
    class CustomeSessionDelegate: NSObject, URLSessionTaskDelegate {
        func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            // 获取上传进度
            print("bytesSent: \(bytesSent) totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            print("finish \(String(describing: error))")
        }
    }
    
    // 不清楚后台怎么接收该类数据
    let url = URL(string: "http://httpbin.org/post")
//    let url = NSURL(string: "http://localhost:3000/uploadFormData")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.POST.rawValue
    request.addValue("image/jped", forHTTPHeaderField: "Content-Type")
    request.addValue("text/html", forHTTPHeaderField: "Accept")
    request.cachePolicy = .reloadIgnoringLocalCacheData
    
    let imageData = image?.jpegData(compressionQuality: 1)!
    
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: CustomeSessionDelegate(), delegateQueue: nil)
    let task = session.uploadTask(with: request, from: imageData, completionHandler: { (data, response, error) in
        print(error)
        if let data = data {
            let responseString = String(data: data, encoding: String.Encoding.utf8)
            print(responseString)
        }
    })
    /*
    let task = session.uploadTaskWithRequest(request, fromData: imageData, completionHandler: { (data, response, error) in
        print(error)
        if let data = data {
            let responseString = String(data: data, encoding: NSUTF8StringEncoding)
            print(responseString)
        }
//        do {
//            let returnedResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
//            print(returnedResponse)
//        } catch let JSONError as NSError {
//            print("error: \(JSONError)")
//        }
    })
 */
    task.resume()
    
}
//uploadImage()


extension String {
    var data: Data {
        return self.data(using: .utf8)!
    }
}
let uploadImageWithParams = {
    
    class CustomeSessionDelegate: NSObject, URLSessionTaskDelegate {
        func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            // 获取上传进度
            print("bytesSent: \(bytesSent) totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            print("finish \(error)")
        }
    }
    
    let boundary = "----mxy---------"
    let url = URL(string: "http://httpbin.org/post")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.POST.rawValue
    request.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
    request.cachePolicy = .reloadIgnoringLocalCacheData
    
    var data = Data()
    let params = ["username": "@孟祥月_iOS", "password": "password"]
    for (key, value) in params {
        data.append("--\(boundary)\r\n".data)
        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data)
        data.append("\(value)\r\n".data)
    }
    
    for file in ["1111.jpg"] {
        data.append("--\(boundary)\r\n".data)
        // sampleFile 与后台一致
        data.append("Content-Disposition: form-data; name=\"sampleFile\"; filename=\"\(file)\"\r\n\r\n".data)
//        if let a = NSData(contentsOfURL: file.url) {
//            data.appendData(a)
//            data.appendData("\r\n".nsdata)
//        }
        // 这里可以根据上面的内容 替换成file文件
        let image = UIImage(named: file)
        let imageData = image?.jpegData(compressionQuality: 1)!
        data.append(imageData!)
        data.append("\r\n".data)
    }
    
    // 表示数据结尾
    data.append("--\(boundary)--\r\n".data)
    
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: CustomeSessionDelegate(), delegateQueue: nil)
    let task = session.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
        print(error)
        if let data = data {
            let responseString = String(data: data, encoding: String.Encoding.utf8)
            print(responseString)
        }
    })
    /*
    let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler: { (data, response, error) in
        print(error)
        if let data = data {
            let responseString = String(data: data, encoding: NSUTF8StringEncoding)
            print(responseString)
        }
    })
    */
    task.resume()
    
}
uploadImageWithParams()


//: [Next](@next)
