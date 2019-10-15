//
//  BaseViewController.swift
//  MenuSlideController
//
//  Created by Sahi Joshi on 8/21/18.
//  Copyright © 2018 Sahi Joshi. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor.white
//            UIColor(red: 125/255, green: 197/255, blue: 117/255, alpha: 1.0)
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.1921568627, green: 0.6078431373, blue: 0.2392156863, alpha: 1)
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        let tabBarItems = tabBar.items! as [UITabBarItem]
        
        tabBarItems[0].imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        tabBarItems[1].imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        tabBarItems[2].imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
