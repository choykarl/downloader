//
//  ViewController.swift
//  DownLoader
//
//  Created by karl on 2017/07/21.
//  Copyright © 2017年 Karl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var beginButton: UIButton!
  var downloader: DownLoader?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func createDownloader() {
    downloader = DownLoader()
    if let url = URL(string: "http://120.25.226.186:32812/resources/videos/minion_04.mp4") {
      downloader?.download(url: url) { [weak self] (result) in
        guard let weakSelf = self else { return }
        switch result {
        case .success(let path):
          print(path)
        case .error(let error):
          print(error)
        }
        weakSelf.beginButton.setTitle("开始", for: .normal)
      }
    }
    beginButton.setTitle("暂停", for: .normal)
  }

  @IBAction func beginDownload(_ sender: UIButton) {
    if downloader == nil {
      createDownloader()
      return
    }
    
    if downloader?.status == .suspended {
      downloader?.resume()
      beginButton.setTitle("暂停", for: .normal)
    } else if downloader?.status == .resume {
      downloader?.suspend()
      beginButton.setTitle("开始", for: .normal)
    }
  }
  
  @IBAction func cancelDownload(_ sender: UIButton) {
    downloader?.cancel()
    downloader = nil
    beginButton.setTitle("开始", for: .normal)
  }
}

