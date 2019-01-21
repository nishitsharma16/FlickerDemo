//
//  FLSessionManagerTest.swift
//  FlickerTests
//
//  Created by B0095764 on 1/22/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import Flicker


class FLSessionManagerTest: XCTestCase {

    var sessionManager : FLURLSessionManager!
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sessionManager = FLURLSessionManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionManager = nil
        super.tearDown()
    }

    func testGetFirstDataTaskMethod() {
        let requestPath = "\(WebEngineConstant.flickerServicePath)?method=\(WebEngineConstant.flickerPhotoSearchMethod)&api_key=\(WebEngineConstant.flickerPhotoAPIKey)&format=\(WebEngineConstant.flickerPhotoFormat)&nojsoncallback=1&safe_search=1&text=kitten&page=1&per_page=20"
        let promise = expectation(description: "Completion handler invoked")
        var dataResponse : Any?
        
        let dataTask = sessionManager.dataTask(withURLStr: requestPath, requestType: .GET, param: nil, headers: nil, successHander: { (task, response) in
            dataResponse = response
            promise.fulfill()
        }) { (task, error) in
        }
        
        dataTask?.resume()
        
        waitForExpectations(timeout: 50, handler: nil)
        
        XCTAssertNotNil(dataTask, "Network Data Task Found nil")
        XCTAssertNotNil(dataResponse, "Network Data response Found nil")
    }
    
    func testGetFirstDataTaskWithErrorMethod() {
        let requestPath = "https://api.flickr.com/services/rest/ method=\(WebEngineConstant.flickerPhotoSearchMethod)&api_key=\(WebEngineConstant.flickerPhotoAPIKey)&format=\(WebEngineConstant.flickerPhotoFormat)&nojsoncallback=1.0&safe_search=1&text=kitten&page=1&per_page=20"
        let promise = expectation(description: "Completion handler invoked")
        var err : Error?
        
        let _ = sessionManager.dataTask(withURLStr: requestPath, requestType: .GET, param: nil, headers: nil, successHander: { (task, response) in
        }) { (task, error) in
            err = error
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 50, handler: nil)
        
        XCTAssertNotNil(err, "Network Data Error Found nil")
    }
    
    func testGetSecondDataTaskMethod() {
       let requestPath = "https://api.flickr.com/services/rest/ method=\(WebEngineConstant.flickerPhotoSearchMethod)&api_key=\(WebEngineConstant.flickerPhotoAPIKey)&format=\(WebEngineConstant.flickerPhotoFormat)&nojsoncallback=1.0&safe_search=1&text=kitten&page=1&per_page=20"
        if let url = URL(string: requestPath) {
            
            let promise = expectation(description: "Completion handler invoked")
            var dataResponse : Any?

            let request = URLRequest(url: url)
            
            let dataTask = sessionManager.dataTask(withRequest: request) { (response, data, error) in
                dataResponse = response
                promise.fulfill()
            }
            
            dataTask.resume()

            waitForExpectations(timeout: 50, handler: nil)

            XCTAssertNotNil(dataTask, "Network Data Task Found nil")
            XCTAssertNotNil(dataResponse, "Network Data response Found nil")
        }
    }
    
    func testGetSecondDataTaskErrorMethod() {
        let requestPath = "https://api.flickr.com/services/rest/ method=\(WebEngineConstant.flickerPhotoSearchMethod)&api_key=\(WebEngineConstant.flickerPhotoAPIKey)&format=\(WebEngineConstant.flickerPhotoFormat)&nojsoncallback=1.0&safe_search=1&text=kitten&page=1&per_page=20"
        if let url = URL(string: requestPath) {
            
            let promise = expectation(description: "Completion handler invoked")
            var err : Error?

            let request = URLRequest(url: url)
            
            let _ = sessionManager.dataTask(withRequest: request) { (response, data, error) in
                err = error
                promise.fulfill()
            }
            
            waitForExpectations(timeout: 50, handler: nil)
            
            XCTAssertNotNil(err, "Network Data Error Found nil")
        }
    }
}
