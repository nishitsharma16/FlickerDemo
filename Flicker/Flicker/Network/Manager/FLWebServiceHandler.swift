//
//  FLWebServiceHandler.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

class FLWebServiceHandler : NSObject, FLWebServiceHandlerProtocol {
    private(set) var completionBlock : (Any?, DataError?) -> Void
    
    required init(withCompletion completion : @escaping (Any?, DataError?) -> Void) {
        completionBlock = completion
    }
}
