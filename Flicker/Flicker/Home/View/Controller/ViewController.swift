//
//  ViewController.swift
//  Flicker
//
//  Created by B0095764 on 1/19/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var presenter : FLHomePresenterInputProtocol?
    var dataList : [FLDataProtocol]?
    private var pageNumber : Int = 1
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Flicker Image Search"
        self.collection.register(UINib(nibName: ViewConstant.CellConstant.cellNibName, bundle: nil), forCellWithReuseIdentifier: ViewConstant.CellConstant.cellID)
    }
}

extension ViewController : FLHomePresenterOutputProtocol {
    
    func showFlickerImages(imageList : [FLDataProtocol]?) {
        dataList = imageList
        collection.reloadData()
    }
    
    func showError(errorMessage : String) {
        print("Data Error \(errorMessage)")
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewConstant.CellConstant.cellID, for: indexPath) as! FLHomeCollectionViewCell
        
        itemCell.updateCell(withData: self.dataList?[indexPath.row])
        
        return itemCell
    }
    
    
    // MARK: Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.getFlickerImages(withQuery: searchText, withPageNumber: pageNumber)
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        if (scrollOffset + scrollViewHeight == contentHeight) {
            pageNumber += 1
            presenter?.getFlickerImages(withQuery: searchBar?.text , withPageNumber: pageNumber)
        }
    }
}

extension ViewController {
    private struct ViewConstant {
        struct CellConstant {
            static let cellID = "FLHomeCollectionCellID"
            static let cellNibName = "FLHomeCollectionViewCell"
        }
    }
}


