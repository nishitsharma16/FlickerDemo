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
        
        let status = !collectionView.isDragging && !collectionView.isDecelerating
        itemCell.updateCell(withData: self.dataList?[indexPath.row], withStatus: status)
        
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForVisibleRows()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForVisibleRows()
    }
}

extension ViewController {
    private func loadImagesForVisibleRows() {
        if let list = self.dataList, list.count > 0 {
            let visibleItems = collection.indexPathsForVisibleItems
            for indexPath in visibleItems {
                let iconObj = dataList?[indexPath.row]
                if let _ = iconObj?.iconImage {
                    
                }
                else {
                    if let itemCell = collection.cellForItem(at: indexPath) as? FLHomeCollectionViewCell {
                        itemCell.updateCell(withData: iconObj, withStatus: true)
                    }
                }
            }
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


