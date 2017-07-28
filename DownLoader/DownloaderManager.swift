//
//  DownloaderManager.swift
//  DownLoader
//
//  Created by karl on 2017/07/28.
//  Copyright © 2017年 Karl. All rights reserved.
//

import UIKit

class DownloaderManager: NSObject {
  
  static let shared = DownloaderManager()
  private var downloadQueue = [String: DownLoader]()
  
  private override init() {}
  
  func download(url: URL, fileName saveFileName: String = "", progressHandle: ((CGFloat) -> ())? = nil, completionHandle: ((Result) -> ())? = nil) {
    if let downloader = downloadQueue[url.absoluteString] {
      downloader.resume()
    } else {
      let downloader = DownLoader()
      downloader.download(url: url, fileName: saveFileName, progressHandle: progressHandle, completionHandle: { [weak self] result in
        completionHandle?(result)
        guard let weakSelf = self else { return }
        weakSelf.downloadQueue.removeValue(forKey: url.absoluteString)
      })
      downloadQueue[url.absoluteString] = downloader
    }
  }
  
  func suspend(_ url: URL) {
    if let downloader = downloadQueue[url.absoluteString] {
      downloader.suspend()
    }
  }
  
  func resume(_ url: URL) {
    if let downloader = downloadQueue[url.absoluteString] {
      downloader.resume()
    }
  }
  
  func cancel(_ url: URL){
    if let downloader = downloadQueue[url.absoluteString] {
      downloader.cancel()
      downloadQueue.removeValue(forKey: url.absoluteString)
    }
  }
  
}
