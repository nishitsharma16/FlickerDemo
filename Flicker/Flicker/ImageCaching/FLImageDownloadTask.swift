//
//  FLImageDownloadTask.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

class FLImageDownloadTask : FLImageDownloadTaskProtocol {
    
    let dataTask : URLSessionDataTask
    private let taskID : String
    var handlerList : [FLImageTaskHandler] = []
    
    required init(dataTask task : URLSessionDataTask, taskID identifier : String) {
        dataTask = task
        taskID = identifier
    }
    
    func addTaskHandler(handler : FLImageTaskHandler) {
        if !handlerList.contains(handler) {
            handlerList.append(handler)
        }
    }
    
    func removeHandler(handler : FLImageTaskHandler) {
        if handlerList.contains(handler) {
            handlerList = handlerList.filter{ $0 != handler }
        }
    }
}
