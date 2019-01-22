//
//  FLHomePresenterInputProtocol.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit

protocol FLHomePresenterInputProtocol : AnyObject {
    var view : FLHomePresenterOutputProtocol? { get set }
    var numberOfItemsPerRow : Int { get }
    var interactor : FLHomeInteratorInputProtocol? { get set }
    func getFlickerImages(withQuery text : String?, withPageNumber page : Int)
    func numberOfItems(forScreenSize size : CGSize, itemSize : CGSize)
    func itemSize(withScreenWidth width : CGFloat) -> CGSize
}
