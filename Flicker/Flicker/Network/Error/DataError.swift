//
//  DataError.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2018 Mine. All rights reserved.
//

import Foundation

/**
 This Type is used for making custom error object when any API is hit to get the data from the server.
 */

class DataError : Error {
    
    var errorMessage = Constants.defaultErrorMessage
    
    init() {
    }
    
    init(withError error : Error) {
        errorMessage = error.localizedDescription
    }
}
