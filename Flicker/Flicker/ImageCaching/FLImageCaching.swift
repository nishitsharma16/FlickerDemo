//
//  FLImageCaching.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC.runtime

extension UIImageView : FLImageCacheProtocol {
    
    private struct AssociatedKeys {
        static var downloaderName = "img_dwnld_name"
        static var downloadStatus = "img_dwnld_status"
    }
    
    var imageDownloader: FLImageDownloader {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.downloaderName) as? FLImageDownloader else {
                    return FLImageDownloader.sharedDownloader
                }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.downloaderName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var imageDownloadStatus: FLImageDownloadStatus? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.downloadStatus) as? FLImageDownloadStatus else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.downloadStatus, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(withUrl imageURL : URL) {
        setImage(withUrl: imageURL, withPlaceHolderImage: nil)
    }
    
    func setImage(withUrl imageURL : URL, withPlaceHolderImage placeHolderImage : UIImage?) {
        setImage(withUrl: imageURL, withPlaceHolderImage: placeHolderImage, successCompletion: nil, failureCompletion: nil)
    }
    
    func setImage(withUrl imageURL : URL, withPlaceHolderImage placeHolderImage : UIImage?, successCompletion successCallback : ((URLRequest, URLResponse?, UIImage?) -> Void)?, failureCompletion failureCallback : ((URLRequest, URLResponse?, Error?) -> Void)?)  {
        
        if checkDownloadInProgress(forPath: imageURL.absoluteString) {
            return
        }
        
        cancelDownload()
        
        var request = URLRequest(url: imageURL)
        request.addValue("image/*", forHTTPHeaderField: "Accept")
        
        if let cachedImage = imageDownloader.getImage(forIdentifier: imageURL.absoluteString) {
            if let success = successCallback {
                success(request, nil, cachedImage)
            }
            else {
                self.image = cachedImage
            }
        }
        else {
            if let imageVal = placeHolderImage {
                self.image = imageVal
            }

            let downloadId = UUID().uuidString
            
            let downloadStatus = imageDownloader.downLoadImage(withURLRequest: request, downloadID: downloadId, successCompletion: { [weak self] (request, response, image) in
                if self?.imageDownloadStatus?.downloadID == downloadId {
                    if let success = successCallback {
                        success(request, response, image)
                    }
                    else if let imageVal = image {
                        self?.image = imageVal
                    }
                    self?.clearDownloadStatus()
                }
            }) { [weak self] (request, response, error) in
                if self?.imageDownloadStatus?.downloadID == downloadId {
                    if let failure = failureCallback {
                        failure(request, nil, error)
                    }
                    else if let imageVal = placeHolderImage {
                        self?.image = imageVal
                    }
                    self?.clearDownloadStatus()
                }
            }
            
            imageDownloadStatus = downloadStatus
        }
    }
    
    private func checkDownloadInProgress(forPath path : String) -> Bool {
        if let originalUrlStr = self.imageDownloadStatus?.dataTask.originalRequest?.url?.absoluteString, originalUrlStr == path {
            return true
        }
        return false
    }
    
    private func cancelDownload() {
        if let status = imageDownloadStatus {
            imageDownloader.cancelDownload(forStatus: status)
            clearDownloadStatus()
        }
    }
    
    func clearDownloadStatus() {
        if let _ = imageDownloadStatus {
            imageDownloadStatus = nil
        }
    }
}

