//
//  FLImageTaskHandlerProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit

protocol FLImageTaskHandlerProtocol {
    init(downloadId identifier : String, success : @escaping (URLRequest, URLResponse?, UIImage?) -> Void, failure : @escaping (URLRequest, URLResponse?, Error?) -> Void)
}
