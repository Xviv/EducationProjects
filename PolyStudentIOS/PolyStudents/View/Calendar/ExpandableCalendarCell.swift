//
//  ExpandableCalendarCell.swift
//  PolyStudents
//
//  Created by Dan on 20/04/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import JTAppleCalendar
import UIKit
class expandableCalendarDateCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedCellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedCellView.layer.masksToBounds = true
        selectedCellView.layer.cornerRadius = 15
    }
    
}
