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
    private var dataListVal = [FLDataProtocol]()
    private var searchtext : String?
    
    func getFlickerImages(withQuery text : String?, withPageNumber page : Int) {
        if let previouslySearchTest = searchtext, let currentText = text, previouslySearchTest != currentText {
            showEmptyData(withPageNumber: page)
        }
        
        searchtext = text
        
        if let str = text {
            if str.count > 0 {
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
            if dataList.count > 0 {
                dataListVal.append(contentsOf: dataList)
            }
            view?.showFlickerImages(imageList: dataListVal)
        case .noData(let error):
            dataListVal.removeAll()
            view?.showError(errorMessage: error.errorMessage)
        case .error(let error):
            dataListVal.removeAll()
            view?.showError(errorMessage: error.errorMessage)
        }
    }
    
    private func showEmptyData(withPageNumber page : Int) {
        dataListVal.removeAll()
        interactor?.cancellAllDownloads()
        view?.showError(errorMessage: Constants.noResultsErrorMessage)
        view?.showFlickerImages(imageList: nil)
    }
}
