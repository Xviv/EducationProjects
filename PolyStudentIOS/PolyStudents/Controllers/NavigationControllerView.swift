//
//  ExtensionUINavigationController.swift
//  PolyStudents
//
//  Created by Dan on 26/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerView: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    @objc func dismissController(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
