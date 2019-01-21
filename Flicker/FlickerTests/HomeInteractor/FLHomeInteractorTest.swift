//
//  FLHomeInteractorTest.swift
//  FlickerTests
//
//  Created by B0095764 on 1/22/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import Flicker

class FLHomeInteractorTest: XCTestCase {

    var homeInteractor : FLHomeInteractor!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        homeInteractor = FLHomeInteractor()
        homeInteractor.webServiceManager = MockWebserviceManager()
        homeInteractor.imageDownloader = MockImageDwonloader()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homeInteractor = nil
        super.tearDown()
    }
    
    func testcCancelAllDownloads() {
        homeInteractor.webServiceManager.cancelAllTasks()
    }
    
    func testClearAllCachedData() {
        homeInteractor.imageDownloader.clearAllCachedData()
    }
    
    func testFetchFlickerData(withQuery text : String?, withPageNumber page : Int) {
        
        guard let query = text else {
           homeInteractor.webServiceManager.cancelAllTasks()
            return
        }
        
        if query.count == 0 {
            homeInteractor.webServiceManager.cancelAllTasks()
        }
        else {
            let requestPath = "\(WebEngineConstant.flickerServicePath)?method=\(WebEngineConstant.flickerPhotoSearchMethod)&api_key=\(WebEngineConstant.flickerPhotoAPIKey)&format=\(WebEngineConstant.flickerPhotoFormat)&nojsoncallback=1&safe_search=1&text=\(query)&page=\(page)&per_page=20"
            
            let mockPresenter = MockPresenter()

            homeInteractor.webServiceManager.createDataRequest(withPath: requestPath, withParam: nil, withCustomHeader: nil, withRequestType: .GET) { (data, error) in
                if let dataVal = data {
                    DispatchQueue.global().async {
                        
                        var list : [FLDataProtocol]?
                        
                        if let dataObjectInfo = dataVal as? [AnyHashable : Any], let photosInfo = dataObjectInfo["photos"] as? [AnyHashable : Any], let dataList = photosInfo["photo"] as? [Any] {
                            let builder = DataBuilder<FLModel>()
                            list = builder.getParsedDataList(withData: dataList)
                        }
                        
                        DispatchQueue.main.async {
                            if let dataList = list {
                                mockPresenter.flickerDataFetched(flickerData: .success(dataList))
                            }
                            else {
                                let noDataError = DataError()
                                noDataError.errorMessage = Constants.noResultsErrorMessage
                                mockPresenter.flickerDataFetched(flickerData: .noData(noDataError))
                            }
                        }
                    }
                }
                else {
                    let err = error ?? DataError()
                    mockPresenter.flickerDataFetched(flickerData: .error(err))
                }
            }
        }
    }

}
