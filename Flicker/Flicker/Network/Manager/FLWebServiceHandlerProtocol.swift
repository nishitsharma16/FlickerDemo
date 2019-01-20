//
//  FLWebServiceHandlerProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

protocol FLWebServiceHandlerProtocol {
     init(withCompletion completion : @escaping (Any?, DataError?) -> Void)
}
