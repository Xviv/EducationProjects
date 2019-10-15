//
//  ContractCell.swift
//  PolyStudents
//
//  Created by Dan on 25/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class ContractCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
