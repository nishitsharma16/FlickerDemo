//
//  FLHomePresenterOutputProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol FLHomePresenterOutputProtocol : AnyObject {
    func showFlickerImages(imageList : [FLDataProtocol]?)
    func showError(errorMessage : String)
}
