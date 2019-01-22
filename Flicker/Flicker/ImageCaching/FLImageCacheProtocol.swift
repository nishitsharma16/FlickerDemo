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
    func setImage(withUrl imageURL : URL, ofSize newSize : CGSize)
    func setImage(withUrl imageURL : URL, ofSize newSize : CGSize, withPlaceHolderImage placeHolderImage : UIImage?)
    func setImage(withUrl imageURL : URL, ofSize newSize : CGSize, withPlaceHolderImage placeHolderImage : UIImage?, successCompletion successCallback : ((URLRequest, URLResponse?, UIImage?) -> Void)?, failureCompletion failureCallback : ((URLRequest, URLResponse?, Error?) -> Void)?)
}
