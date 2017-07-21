//
//  FileMangerTool.swift
//  DownLoader
//
//  Created by karl on 2017/07/21.
//  Copyright © 2017年 Karl. All rights reserved.
//

import UIKit

class FileManagerTool: NSObject {

  class func fileExists(_ filePath: String) -> Bool {
    return FileManager.default.fileExists(atPath: filePath)
  }
  
  class func fileSize(_ filePath: String) -> UInt64 {
    guard fileExists(filePath) else { return 0 }
    
    // 下面两种方式都能获取大小
    // 1:
    if let att = try? FileManager.default.attributesOfItem(atPath: filePath) {
      if let size = att[FileAttributeKey.size] as? UInt64 {
        return size
      }
    }
    // 2:
//    if let att = try? FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary {
//      return att.fileSize()
//    }
    return 0
  }
  
  class func moveFile(_ fromPath: String, toPath: String) {
    guard fileExists(fromPath) else { return }
    do {
      try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
    } catch {
      print("move error: \(error)")
    }
  }
  
  class func removeFile(_ filePath: String) {
    if FileManager.default.isDeletableFile(atPath: filePath) {
      try? FileManager.default.removeItem(atPath: filePath)
    }
  }
}
