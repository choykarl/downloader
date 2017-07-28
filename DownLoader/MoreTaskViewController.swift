//
//  MoreTaskViewController.swift
//  DownLoader
//
//  Created by karl on 2017/07/28.
//  Copyright © 2017年 Karl. All rights reserved.
//

import UIKit

class MoreTaskViewController: UIViewController {
  
  @IBOutlet weak var task1Label: UILabel!
  @IBOutlet weak var task2Label: UILabel!
  @IBOutlet weak var task3Label: UILabel!
  @IBOutlet weak var task4Label: UILabel!
  @IBOutlet weak var task1Button: DownloaderButton!
  @IBOutlet weak var task2Button: DownloaderButton!
  @IBOutlet weak var task3Button: DownloaderButton!
  @IBOutlet weak var task4Button: DownloaderButton!

  @IBAction func task1BtnClick(_ sender: DownloaderButton) {
    if let url = URL(string: "http://120.25.226.186:32812/resources/videos/minion_01.mp4") {
      if sender.isSelected == true {
        DownloaderManager.shared.resume(url)
      } else {
        if sender.url == nil {
          sender.url = url
          DownloaderManager.shared.download(url: url, progressHandle: {[weak self] (progress) in
            DispatchQueue.main.async {
              self?.task1Label.text = String(format: "%.4f", progress)
            }
          }) { (result) in
            switch result {
            case let .success(path):
              print("任务1: \(path)")
            case let .error(error):
              print("任务1: \(error)")
            }
          }
          return
        } else {
          DownloaderManager.shared.suspend(url)
        }
      }
      sender.isSelected = !sender.isSelected
    }
  }
  
  @IBAction func task2BtnClick(_ sender: DownloaderButton) {
    if let url = URL(string: "http://120.25.226.186:32812/resources/videos/minion_02.mp4") {
      if sender.isSelected {
        DownloaderManager.shared.resume(url)
      } else {
        if sender.url == nil {
          sender.url = url
          DownloaderManager.shared.download(url: url, progressHandle: {[weak self] (progress) in
            DispatchQueue.main.async {
              self?.task2Label.text = String(format: "%.4f", progress)
            }
          }) { (result) in
            switch result {
            case let .success(path):
              print("任务2: \(path)")
            case let .error(error):
              print("任务2: \(error)")
            }
          }
          return
        } else {
          DownloaderManager.shared.suspend(url)
        }
      }
      sender.isSelected = !sender.isSelected
    }
  }
  
  @IBAction func task3BtnClick(_ sender: DownloaderButton) {
    if let url = URL(string: "http://120.25.226.186:32812/resources/videos/minion_03.mp4") {
      if sender.isSelected {
        DownloaderManager.shared.resume(url)
      } else {
        if sender.url == nil {
          sender.url = url
          DownloaderManager.shared.download(url: url, progressHandle: {[weak self] (progress) in
            DispatchQueue.main.async {
              self?.task3Label.text = String(format: "%.4f", progress)
            }
          }) { (result) in
            switch result {
            case let .success(path):
              print("任务3: \(path)")
            case let .error(error):
              print("任务3: \(error)")
            }
          }
          return
        } else {
          DownloaderManager.shared.suspend(url)
        }
      }
      sender.isSelected = !sender.isSelected
    }
  }
  
  @IBAction func task4BtnClick(_ sender: DownloaderButton) {
    if let url = URL(string: "http://120.25.226.186:32812/resources/videos/minion_04.mp4") {
      if sender.isSelected {
        DownloaderManager.shared.resume(url)
      } else {
        if sender.url == nil {
          sender.url = url
          DownloaderManager.shared.download(url: url, progressHandle: {[weak self] (progress) in
            DispatchQueue.main.async {
              self?.task4Label.text = String(format: "%.4f", progress)
            }
          }) { (result) in
            switch result {
            case let .success(path):
              print("任务4: \(path)")
            case let .error(error):
              print("任务4: \(error)")
            }
          }
          return
        } else {
          DownloaderManager.shared.suspend(url)
        }
      }
      sender.isSelected = !sender.isSelected
    }
  }
  
  
  @IBAction func cancelTask1(_ sender: UIButton) {
    if let url = task1Button.url {
      DownloaderManager.shared.cancel(url)
      task1Button.url = nil
      task1Button.isSelected = false
      task1Label.text = "0"
    }
  }
  
  @IBAction func cancelTask2(_ sender: UIButton) {
    if let url = task2Button.url {
      DownloaderManager.shared.cancel(url)
      task2Button.url = nil
      task2Button.isSelected = false
      task2Label.text = "0"
    }
  }
  
  @IBAction func cancelTask3(_ sender: UIButton) {
    if let url = task3Button.url {
      DownloaderManager.shared.cancel(url)
      task3Button.url = nil
      task3Button.isSelected = false
      task3Label.text = "0"
    }
  }
  
  @IBAction func cancelTask4(_ sender: UIButton) {
    if let url = task4Button.url {
      DownloaderManager.shared.cancel(url)
      task4Button.url = nil
      task4Button.isSelected = false
      task4Label.text = "0"
    }
  }
  
  
}

class DownloaderButton: UIButton {
  var url: URL!
}
