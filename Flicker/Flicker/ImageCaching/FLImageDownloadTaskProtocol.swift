//
//  FLImageDownloadTaskProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol FLImageDownloadTaskProtocol {
    init(dataTask task : URLSessionDataTask, taskID identifier : String)
    func addTaskHandler(handler : FLImageTaskHandler)
    func removeHandler(handler : FLImageTaskHandler)
}
