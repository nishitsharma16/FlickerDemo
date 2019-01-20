//
//  FLHomeInteratorOutputProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

enum FlickerDataFetchStatus {
    case success([FLDataProtocol])
    case noData(DataError)
    case error(DataError)
}

protocol FLHomeInteratorOutputProtocol : AnyObject {
    func flickerDataFetched(flickerData : FlickerDataFetchStatus)
}
