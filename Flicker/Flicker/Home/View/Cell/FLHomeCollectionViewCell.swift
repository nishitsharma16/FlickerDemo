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
    
    func updateCell(withData data : FLDataProtocol?) {
        if let url = data?.flickerImageURL {
            cellImageView.setImage(withUrl: url)
        }
    }
}
