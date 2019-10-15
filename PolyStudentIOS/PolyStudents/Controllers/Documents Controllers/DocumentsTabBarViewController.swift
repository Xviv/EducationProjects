//
//  DocumentsTabBarViewController.swift
//  PolyStudents
//
//  Created by Dan on 25/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class DocumentsTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btnMenu = UIButton(type: .custom)
        btnMenu.addTarget(self, action: #selector(dismissController(sender:)), for: .touchUpInside)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnMenu.setImage(UIImage(named: "arrow-left"), for: .normal)
        
        let barMenuItem = UIBarButtonItem(customView: btnMenu)
        navigationItem.leftBarButtonItem = barMenuItem
        
        UITabBar.appearance().tintColor = UIColor(red: 125/255, green: 197/255, blue: 117/255, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func dismissController(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
