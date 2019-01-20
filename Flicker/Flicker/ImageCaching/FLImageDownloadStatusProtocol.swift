//
//  FLImageDownloadStatusProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol FLImageDownloadStatusProtocol {
    init(dataTask task : URLSessionDataTask, downloadID identifier : String)
}
