//
//  DownLoader.swift
//  DownLoader
//
//  Created by karl on 2017/07/21.
//  Copyright © 2017年 Karl. All rights reserved.
//

import UIKit

let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/"
let tempPath = NSTemporaryDirectory()

enum DownloadStatus {
  case none
  case resume
  case suspended
  case inactivity
}

enum Result {
  case success(path: String)
  case error(Error)
}


class DownLoader: NSObject {
  
  fileprivate(set) var status = DownloadStatus.none
  fileprivate var downLoadedPath = ""
  fileprivate var downLoadingPath = ""
  fileprivate var session: URLSession?
  fileprivate var outputStream: OutputStream?
  fileprivate var task: URLSessionTask?
  fileprivate var tempSize: UInt64 = 0
  fileprivate var totalSize: UInt64 = 0
  fileprivate var completionHandle: ((Result) -> ())?
  fileprivate var progressHandle: ((CGFloat) -> ())?
  fileprivate var progressSize: UInt64 = 0

  func download(url: URL, fileName saveFileName: String = "", progressHandle: ((CGFloat) -> ())? = nil, completionHandle: ((Result) -> ())? = nil) {
    if task?.currentRequest?.url == url {
      print("重复任务")
      return
    }
    self.progressHandle = progressHandle
    self.completionHandle = completionHandle
    let fileName = saveFileName == "" ? url.lastPathComponent : saveFileName
    downLoadedPath = cachePath + fileName
    downLoadingPath = tempPath + fileName
    
    if FileManagerTool.fileExists(downLoadedPath) {
      DispatchQueue.global().async {
        completionHandle?(Result.success(path: self.downLoadedPath))
      }
      return
    }
    
    // 文件不存在,直接从0下载
    if !FileManagerTool.fileExists(downLoadingPath) {
      download(url: url, offset: 0)
      return
    }
    
    // 文件存在
    if FileManagerTool.fileExists(downLoadingPath) {
      
      // 获取已存在文件大小
      tempSize = FileManagerTool.fileSize(downLoadingPath)
      // 接着之前的文件重新下载
      download(url: url, offset: tempSize)
    }
    
  }
  
  func resume() {
    if status != .resume {
      task?.resume()
      status = .resume
    }
  }
  
  func suspend() {
    if status != .suspended {
      task?.suspend()
      status = .suspended
    }
  }
  
  func cancel() {
    task?.cancel()
    status = .inactivity
  }
  
  private func download(url: URL, offset: UInt64) {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0)
    self.session = session
    
    request.setValue("bytes=\(offset)-", forHTTPHeaderField: "Range")
    task = session.dataTask(with: request)
    resume()
  }
}

extension DownLoader: URLSessionDataDelegate {
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    guard let res = response as? HTTPURLResponse else {
      completionHandler(.cancel)
      status = .inactivity
      return
    }
    
    // 获取下载文件大小
    guard let fileTotalLengthStr = res.allHeaderFields["Content-Length"] as? String, let fileTotalLength = UInt64(fileTotalLengthStr) else {
      completionHandler(.cancel)
      status = .inactivity
      return
    }
    totalSize = fileTotalLength
    if let contentRangeString = res.allHeaderFields["Content-Range"] as? String {
      if let lengthStr = contentRangeString.components(separatedBy: "/").last, let length = UInt64(lengthStr) {
        totalSize = length
      }
    }

    // 临时文件比要下载的还大,就删除,重新下载
    if tempSize > totalSize {
      FileManagerTool.removeFile(downLoadingPath)
      completionHandler(.cancel)
      if let url = response.url {
        download(url: url, progressHandle: progressHandle, completionHandle: completionHandle)
      }
      return
    }
    
    // 临时文件和下载的一样,就移动文件到存放目录
    if tempSize == totalSize {
      FileManagerTool.moveFile(downLoadingPath, toPath: downLoadedPath)
      completionHandler(.cancel)
      return
    }
    
    outputStream = OutputStream(toFileAtPath: downLoadingPath, append: true)
    outputStream?.open()
    completionHandler(.allow)
    progressSize = tempSize
  }
  
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    let dataSize = data.count
    _ = data.withUnsafeBytes({self.outputStream?.write($0, maxLength: dataSize)})
    progressSize += UInt64(dataSize)
    progressHandle?(CGFloat(progressSize) / CGFloat(totalSize))
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    outputStream?.close()
    status = .inactivity
    if error != nil {
      completionHandle?(Result.error(error!))
    } else if error == nil && FileManagerTool.fileSize(downLoadingPath) == totalSize {
      FileManagerTool.moveFile(downLoadingPath, toPath: downLoadedPath)
      completionHandle?(Result.success(path: downLoadedPath))
    }
  }
}
