//
//  FLImageDownloadStatusProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol FLImageDownloadStatusProtocol {
    var dataTask : URLSessionDataTask { get }
    var downloadID : String { get }
    init(dataTask task : URLSessionDataTask, downloadID identifier : String)
}
