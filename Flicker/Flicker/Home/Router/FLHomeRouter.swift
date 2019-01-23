//
//  FLHomeRouter.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation
import UIKit

class FLHomeRouter : FLHomeRouterProtocol {
    
    static func initializeHomeController() -> ViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        let presenter: FLHomePresenterInputProtocol & FLHomeInteratorOutputProtocol = FLHomePresenter()
        let interactor: FLHomeInteratorInputProtocol = FLHomeInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    
}

// Private Method Extension

extension FLHomeRouter {
    
    private static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}


