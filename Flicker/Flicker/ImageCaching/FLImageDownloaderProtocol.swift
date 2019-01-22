//
//  FLImageDownloaderProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit

protocol FLImageDownloaderProtocol {
    func downLoadImage(withURLRequest request : URLRequest, downloadID identifier : String, ofSize newSize : CGSize, successCompletion : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failureCompletion : @escaping (URLRequest, URLResponse?, Error?) -> Void) -> FLImageDownloadStatus?
    func cancelDownload(forStatus downloadStatus : FLImageDownloadStatus)
    func getImage(forIdentifier identifier : String) -> UIImage?
    func clearAllCachedData()
}
