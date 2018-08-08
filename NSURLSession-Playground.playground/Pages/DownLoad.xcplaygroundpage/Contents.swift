//: [Previous](@previous)

import UIKit
import PlaygroundSupport

// 延迟运行
PlaygroundPage.current.needsIndefiniteExecution = true

// https://httpbin.org/stream/2
// https://httpbin.org/bytes/1024


//: ## 创建NSURLSession
var session = URLSession(configuration: URLSessionConfiguration.default)

//: ## 定义请求类型
enum RequestType: String {
    case GET, POST, PUT, DELETE
}

let downloadImage = {
    let url = URL(string: "http://img0.bdstatic.com/img/image/shouye/xiaoxiao/%E5%88%98%E8%AF%97%E8%AF%97.jpg")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    let task = session.downloadTask(with: request, completionHandler: { (url, response, error) in
        if let data = try? Data(contentsOf: url!) {
            let image = UIImage(data: data)
        }
    })
    task.resume()
    
    
}
//downloadImage()

let downloadImageDelegate = {
    class CustomSessionDelegate: NSObject, URLSessionDownloadDelegate {
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            print("=======didFinishDownloadingToURL: \(location)")
            if let data = try? Data(contentsOf: location) {
                let image = UIImage(data: data)
            }
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            // 处理下载进度
            print("=======bytesWritten: \(bytesWritten) totalBytesWritten:\(totalBytesWritten) totalBytesExpectedToWrite: \(totalBytesExpectedToWrite)")
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
            print("=======fileOffset: \(fileOffset) expectedTotalBytes: \(expectedTotalBytes)")
        }
    }
    
    let url = URL(string: "http://img0.bdstatic.com/img/image/shouye/xiaoxiao/%E5%88%98%E8%AF%97%E8%AF%97.jpg")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: CustomSessionDelegate(), delegateQueue: nil)
    // 使用session.downloadTaskWithRequest(request, completionHandler:) 不会调用设置的Delegate
    let task = session.downloadTask(with: request)
    task.resume()
    
    
}
//downloadImageDelegate()


let resumeDataDownload = {
    var resumeData: Data?
    let url = URL(string: "http://img0.bdstatic.com/img/image/shouye/xiaoxiao/%E5%88%98%E8%AF%97%E8%AF%97.jpg")
    var request = URLRequest(url: url!)
    request.httpMethod = RequestType.GET.rawValue
    var task: URLSessionDownloadTask? = session.downloadTask(with: request, completionHandler: { (url, response, error) in
//        print("finish end \(error)")
//        if let data = try? Data(contentsOf: url!) {
//            let image = UIImage(data: data)
//        }
    })
    task!.resume()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        task!.cancel(byProducingResumeData: { (data) in
            // 这里resumeData 经常为空
            resumeData = data
//            task = nil
            print("data-------- \(data)")
            if let resumeData = resumeData {
                print("resumeData--------")
                let resumeTask = session.downloadTask(withResumeData: resumeData, completionHandler: { (url, response, error) in
                    print("resume finish \(error)")
                    DispatchQueue.main.async {
//                        if let data = try? Data(contentsOf: url!) {
//                            let image = UIImage(data: data)
//                        }
                    }
                    
                })
                resumeTask.resume()
            }
        })
    })
    
    
}
resumeDataDownload()

Thread.current.isMainThread
//: [Next](@next)
