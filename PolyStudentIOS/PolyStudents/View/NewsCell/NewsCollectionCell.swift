//
//  NewsCollectionCell.swift
//  PolyStudents
//
//  Created by Dan on 24/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class NewsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageNews.image = nil
        titleLabel.text = ""
        titleLabel.adjustTextSizeToFitLabel()
    }

}
