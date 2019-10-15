//
//  RecordBookLessonCell.swift
//  PolyStudents
//
//  Created by Dan on 26/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class RecordBookLessonCell: UITableViewCell {

    @IBOutlet weak var typeObj: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var markBGView: UIView!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var lessonMarkLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        boxView.layer.masksToBounds = true
        boxView.dropShadow()
        boxView.layer.cornerRadius = 5
        markBGView.layer.masksToBounds = true
        markBGView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
