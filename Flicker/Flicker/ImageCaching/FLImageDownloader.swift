//
//  FLImageDownloader.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit

final class FLImageDownloader {
    
    static let sharedDownloader = FLImageDownloader()
    var sessionManager : FLURLSessionManagerProtocol
    private var imageDownloadInfo : [AnyHashable : FLImageDownloadTask] = [:]
    private var imageInMemoryCache : [AnyHashable : UIImage] = [:]
    let serialQueue = DispatchQueue(label: "com.flicker.demo.app.serialQueue")
    let concurrentQueue = DispatchQueue(label: "com.flicker.demo.app.concurrentQueue", attributes: .concurrent)

    private init() {
        sessionManager = FLURLSessionManager()
    }
}

extension FLImageDownloader : FLImageDownloaderProtocol {
    
    func clearAllCachedData() {
        imageDownloadInfo.removeAll()
        imageInMemoryCache.removeAll()
    }
    
    func downLoadImage(withURLRequest request : URLRequest, downloadID identifier : String, successCompletion : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failureCompletion : @escaping (URLRequest, URLResponse?, Error?) -> Void) -> FLImageDownloadStatus? {
        
        guard let urlID = request.url?.absoluteString else {
            let err = DataError()
            DispatchQueue.main.async {
                failureCompletion(request, nil, err)
            }
            return nil
        }
        
        var dataTask : URLSessionDataTask?
        
        serialQueue.sync {
            if let downloadTask = imageDownloadInfo[urlID] {
                let handler = FLImageTaskHandler(downloadId : identifier, success: successCompletion, failure: failureCompletion)
                downloadTask.addTaskHandler(handler: handler)
                dataTask = downloadTask.dataTask
            }
            else {
                let task = sessionManager.dataTask(withRequest: request) { [weak self] (response, data, error) in
                    self?.concurrentQueue.async {
                        if let imageDwnldTask = self?.imageDownloadInfo[urlID] {
                            if let err = error {
                                for handler in imageDwnldTask.handlerList {
                                    DispatchQueue.main.async {
                                        handler.failureCallBack(request, response, err)
                                    }
                                }
                                self?.serialyRemoveInMemoryCachedImage(withIdentifier: urlID)
                                self?.serialyRemoveTask(withIdentifier: urlID)
                            }
                            else {
                                for handler in imageDwnldTask.handlerList {
                                    guard let dataVal = data as? Data, let image = UIImage(data: dataVal) else {
                                        DispatchQueue.main.async {
                                            handler.successCallBack(request, response, nil)
                                        }
                                        return
                                    }
                                    self?.serialyAddInMemoryCachedImage(withIdentifier: urlID, image: image)
                                    DispatchQueue.main.async {
                                        handler.successCallBack(request, response, image)
                                    }
                                }
                                self?.serialyRemoveTask(withIdentifier: urlID)
                            }
                        }
                    }
                }
                
                let handler = FLImageTaskHandler(downloadId : identifier, success: successCompletion, failure: failureCompletion)
                let downloadTask = FLImageDownloadTask(dataTask: task, taskID: urlID)
                downloadTask.addTaskHandler(handler: handler)
                addTask(dataTask: downloadTask, identifier: urlID)
                dataTask = task
            }
        }
        
        if let taskVal = dataTask {
            taskVal.resume()
            return FLImageDownloadStatus(dataTask: taskVal, downloadID: identifier)
        }
        else {
            return nil
        }
    }
    
    func cancelDownload(forStatus downloadStatus : FLImageDownloadStatus) {
        serialQueue.sync {
            if let urlId = downloadStatus.dataTask.originalRequest?.url?.absoluteString {
                if let downloadTask = imageDownloadInfo[urlId] {
                    var handlerVal : FLImageTaskHandler?
                    for handler in downloadTask.handlerList {
                        if handler.dwnldID == downloadStatus.downloadID, let urlReq = downloadTask.dataTask.originalRequest {
                            DispatchQueue.main.async {
                                handler.failureCallBack(urlReq, nil, DataError())
                            }
                            handlerVal = handler
                        }
                    }
                    if let val = handlerVal {
                        downloadTask.removeHandler(handler: val)
                        if downloadTask.handlerList.count == 0 {
                            downloadTask.dataTask.cancel()
                            removeTask(withIdentifier: urlId)
                        }
                    }
                }
            }
        }
    }
    
    func getImage(forIdentifier identifier : String) -> UIImage? {
        return imageInMemoryCache[identifier]
    }
}

// Private Method Extension

extension FLImageDownloader {
    
    private func serialyRemoveInMemoryCachedImage(withIdentifier identifier : String) {
        serialQueue.sync {
            removeImage(withIdentifier: identifier)
        }
    }
    
    private func serialyRemoveTask(withIdentifier identifier : String) {
        serialQueue.sync {
            removeTask(withIdentifier: identifier)
        }
    }
    
    private func serialyAddInMemoryCachedImage(withIdentifier identifier : String, image : UIImage) {
        serialQueue.sync {
            if let _ = imageInMemoryCache[identifier] {
                
            }
            else {
                imageInMemoryCache[identifier] = image
            }
        }
    }
    
    private func removeImage(withIdentifier identifier : String) {
        imageInMemoryCache.removeValue(forKey: identifier)
    }
    
    private func addTask(dataTask : FLImageDownloadTask, identifier : String) {
        if let _ = imageDownloadInfo[identifier] {
        }
        else {
            imageDownloadInfo[identifier] = dataTask
        }
    }
    
    private func removeTask(withIdentifier identifier : String) {
        if let _ = imageDownloadInfo[identifier] {
            imageDownloadInfo.removeValue(forKey: identifier)
        }
    }
}
