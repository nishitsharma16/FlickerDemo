//
//  FLHomeInteratorInputProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol FLHomeInteratorInputProtocol : AnyObject {
    var presenter : FLHomeInteratorOutputProtocol? { get set }
    func fetchFlickerData(withQuery text : String?, withPageNumber page : Int)
    func cancellAllDownloads()
}
