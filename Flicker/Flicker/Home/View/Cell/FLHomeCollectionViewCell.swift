//
//  FLHomeCollectionViewCell.swift
//  Flicker
//
//  Created by B0095764 on 1/20/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import UIKit

class FLHomeCollectionViewCell: UICollectionViewCell, CellUpdateProtocol {

    @IBOutlet weak var cellImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(withData data : FLDataProtocol?, withStatus status : Bool) {
        if let iconImage = data?.iconImage {
            cellImageView.image = iconImage
        }
        else {
            if status {
                let placeHolderImage = UIImage(named: "placeholder")
                cellImageView.image = placeHolderImage
                if let url = data?.flickerImageURL {
                    let size = cellImageView.bounds.size
                    cellImageView.setImage(withUrl: url, ofSize : size, withPlaceHolderImage: placeHolderImage, successCompletion: { [weak self, weak data] (request, response, image) in
                        data?.iconImage = image
                        self?.cellImageView.image = image
                    }) { (request, response, error) in
                        
                    }
                }
            }
        }
    }
}
