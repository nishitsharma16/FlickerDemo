//
//  FLImageDownloaderTest.swift
//  FlickerTests
//
//  Created by B0095764 on 1/22/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import Flicker

class FLImageDownloaderTest: XCTestCase {

    var imageDownloader : FLImageDownloader!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        imageDownloader = FLImageDownloader.sharedDownloader
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        imageDownloader = nil
        super.tearDown()
    }

    func testImageDownlad() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if let imageUrl = URL(string: "http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg") {
            
            var request = URLRequest(url: imageUrl)
            request.addValue("image/*", forHTTPHeaderField: "Accept")
            let downloadId = UUID().uuidString
            let size = CGSize(width: 80, height: 80)
            
            let promise = expectation(description: "Completion handler invoked")
            var imageVal : UIImage?
            
            let _ = imageDownloader.downLoadImage(withURLRequest: request, downloadID: downloadId, ofSize: size, successCompletion: { (request, response, image) in
                imageVal = image
                promise.fulfill()
            }) { (request, response, error) in
                
            }
            
            waitForExpectations(timeout: 50, handler: nil)
            
            XCTAssertNotNil(imageVal, "Image Data response Found nil")
        }
    }
    
    func testClearAllCachedData() {
        imageDownloader.clearAllCachedData()
    }

}
