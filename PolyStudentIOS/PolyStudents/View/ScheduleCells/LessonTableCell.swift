//
//  LessonTableCell.swift
//  PolyStudents
//
//  Created by Dan on 22/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class LessonTableCell: UITableViewCell {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teacherFullName: UILabel!
    @IBOutlet weak var typeObject: UILabel!
    @IBOutlet weak var auditorie: UILabel!
    @IBOutlet weak var typeObjView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var noLessonsLabel: UILabel!
    @IBOutlet weak var toggleSearchButton: UIButton!
    
    var buttonTappedAction : (() -> Void)? = nil
    
    let scheduleController = ScheduleTableViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        subjectLabel.adjustTextSizeToFitLabel()
        auditorie.adjustTextSizeToFitLabel()
        teacherFullName.adjustTextSizeToFitLabel()
        typeObject.adjustTextSizeToFitLabel()
        
        cellView.layer.cornerRadius = 8
        cellView.layer.masksToBounds = true
        cellView.dropShadow()
        
    }

    @IBAction func toggleSearch(_ sender: Any) {
        buttonTappedAction?()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
