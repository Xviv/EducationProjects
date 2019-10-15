//
//  calendarCell.swift
//  PolyStudents
//
//  Created by Dan on 20/04/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import JTAppleCalendar
import UIKit
class DateCell: JTAppleCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var selectedDateView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedDateView.layer.masksToBounds = true
        selectedDateView.layer.cornerRadius = 20
    }
}
