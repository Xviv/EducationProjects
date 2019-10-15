//
//  LoginCell.swift
//  PolyStudents
//
//  Created by Dan on 17/03/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

class LoginCell: UITableViewCell {

    @IBOutlet weak var loginButton: UIButton!
    
    var buttonTappedAction : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        buttonTappedAction?()
    }
}
