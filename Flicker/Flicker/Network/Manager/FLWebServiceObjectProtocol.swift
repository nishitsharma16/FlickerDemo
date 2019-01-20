//
//  FLWebServiceObjectProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol FLWebServiceObjectProtocol {
    init(dataTask task : URLSessionDataTask, taskID identifier : String)
    func addTaskHandler(handler : FLWebServiceHandler)
    func removeHander(handler : FLWebServiceHandler)
    func removeAllHandler()
}

