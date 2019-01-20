//
//  FLHomePresenter.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import Foundation

class FLHomePresenter : FLHomePresenterInputProtocol, FLHomeInteratorOutputProtocol {
    
    weak var view : FLHomePresenterOutputProtocol?
    var interactor : FLHomeInteratorInputProtocol?
    
    func getFlickerImages(withQuery text : String?, withPageNumber page : Int) {
        if let str = text {
            if str.count == 0 {
                showEmptyData(withPageNumber: page)
            }
            else {
                interactor?.fetchFlickerData(withQuery: str, withPageNumber: page)
            }
        }
        else {
            showEmptyData(withPageNumber: page)
        }
    }
    
    func flickerDataFetched(flickerData : FlickerDataFetchStatus) {
        switch flickerData {
        case .success(let dataList):
            view?.showFlickerImages(imageList: dataList)
        case .noData(let error):
            view?.showError(errorMessage: error.errorMessage)
        case .error(let error):
            view?.showError(errorMessage: error.errorMessage)
        }
    }
    
    private func showEmptyData(withPageNumber page : Int) {
        interactor?.fetchFlickerData(withQuery: nil, withPageNumber: page)
        view?.showError(errorMessage: Constants.noResultsErrorMessage)
        view?.showFlickerImages(imageList: nil)
    }
}
