//
//  LessonCell.swift
//  PolyStudents
//
//  Created by Dan on 26/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {
    
    @IBOutlet weak var semester: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var exam: UILabel!
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var fileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.masksToBounds = true
        container.dropShadow()
        container.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
