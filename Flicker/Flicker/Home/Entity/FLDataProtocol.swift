//
//  FLDataProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit

protocol FLDataProtocol : AnyObject {
    var flickerImageURL : URL? { get }
    var iconImage : UIImage? { get set }
}
