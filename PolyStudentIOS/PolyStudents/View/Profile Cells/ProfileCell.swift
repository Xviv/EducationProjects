//
//  ProfileCell.swift
//  PolyStudents
//
//  Created by Dan on 16/03/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    @IBOutlet weak var shadowProfileView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowProfileView.dropShadow()
        
        let cornerRadius = avatarImage.bounds.width / 2
        let color = UIColor.black.cgColor
        avatarImage.setCornerRadiusAndBorderWidthAndColor(cornerRadius: cornerRadius, borderWidth: 0, borderColor: color)
        let font = UIFont.systemFont(ofSize: 16)
        segmentedControll.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        
        nameLabel.text = ""
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        postSelectedSegment()
    }
    
    func postSelectedSegment() {
        NotificationCenter.default.post(name: .saveSelectedSegment, object: self)
    }
}
