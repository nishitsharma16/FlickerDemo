//
//  FLHomeInteractor.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

class FLHomeInteractor : FLHomeInteratorInputProtocol {
    
    weak var presenter : FLHomeInteratorOutputProtocol?

    func cancellAllDownloads() {
        FLWebServiceManager.sharedInstance.cancelAllTasks()
    }
    
    func clearAllCachedData() {
        FLImageDownloader.sharedDownloader.clearAllCachedData()
    }
    
    func fetchFlickerData(withQuery text : String?, withPageNumber page : Int) {
        
        guard let query = text else {
            cancellAllDownloads()
            return
        }
        
        if query.count == 0 {
            cancellAllDownloads()
        }
        else {
            let requestPath = "\(WebEngineConstant.flickerServicePath)?method=\(WebEngineConstant.flickerPhotoSearchMethod)&api_key=\(WebEngineConstant.flickerPhotoAPIKey)&format=\(WebEngineConstant.flickerPhotoFormat)&nojsoncallback=1&safe_search=1&text=\(query)&page=\(page)&per_page=20"
            
            FLWebServiceManager.sharedInstance.createDataRequest(withPath: requestPath, withParam: nil, withCustomHeader: nil, withRequestType: .GET) { [weak self] (data, error) in
                if let dataVal = data {
                    DispatchQueue.global().async {
                        
                        var list : [FLDataProtocol]?
                        
                        if let dataObjectInfo = dataVal as? [AnyHashable : Any], let photosInfo = dataObjectInfo["photos"] as? [AnyHashable : Any], let dataList = photosInfo["photo"] as? [Any] {
                            let builder = DataBuilder<FLModel>()
                            list = builder.getParsedDataList(withData: dataList)
                        }
                        
                        DispatchQueue.main.async {
                            if let dataList = list {
                                self?.presenter?.flickerDataFetched(flickerData: .success(dataList))
                            }
                            else {
                                let noDataError = DataError()
                                noDataError.errorMessage = Constants.noResultsErrorMessage
                                self?.presenter?.flickerDataFetched(flickerData: .noData(noDataError))
                            }
                        }
                    }
                }
                else {
                    let err = error ?? DataError()
                    self?.presenter?.flickerDataFetched(flickerData: .error(err))
                }
            }
        }
    }
}
