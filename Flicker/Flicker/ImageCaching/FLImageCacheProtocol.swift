//
//  FLImageCacheProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit

protocol FLImageCacheProtocol {
    func setImage(withUrl imageURL : URL)
    func setImage(withUrl imageURL : URL, withPlaceHolderImage placeHolderImage : UIImage?)
    func setImage(withUrl imageURL : URL, withPlaceHolderImage placeHolderImage : UIImage?, successCompletion successCallback : ((URLRequest, URLResponse?, UIImage?) -> Void)?, failureCompletion failureCallback : ((URLRequest, URLResponse?, Error?) -> Void)?)
}
