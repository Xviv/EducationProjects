//
//  SemesterCollectionCell.swift
//  PolyStudents
//
//  Created by Dan on 06/07/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

class SemesterCollectionCell: UICollectionViewCell {
    @IBOutlet weak var semesterNumber: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleView.backgroundColor = .clear
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.circleView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6235294118, blue: 0.168627451, alpha: 1)
                    self.semesterNumber.textColor = .white
                }
                
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.circleView.backgroundColor = .clear
                    self.semesterNumber.textColor = .black
                }
            }
        }
    }
}
