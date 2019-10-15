//
//  ScholarshipCell.swift
//  PolyStudents
//
//  Created by Dan on 25/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class ScholarshipCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var valueScholarshipLabel: UILabel!
    @IBOutlet weak var nameScholarshipLabel: UILabel!
    @IBOutlet weak var dateScholarshipLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
