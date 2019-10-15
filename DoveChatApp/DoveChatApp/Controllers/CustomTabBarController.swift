//
//  CustomTabBarController.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Firebase

class CustomTabBarController:UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor(r: 74, g: 74, b: 74)
        
        let usersController = MessagesController()
        let contactsController = ContactsViewController()
        let secretChatUsersController = SecretChatController()
        
        contactsController.tabBarItem.image = UIImage(named: "phoneGrey")?.withRenderingMode(.alwaysOriginal)
        contactsController.tabBarItem.title = "Contacts"
        contactsController.tabBarItem.selectedImage = UIImage(named: "phone")?.withRenderingMode(.alwaysOriginal)
        contactsController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(r: 177, g: 177, b: 177)], for: .normal)
        contactsController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(r: 255, g: 255, b: 255)], for: .selected)
        
        usersController.tabBarItem.image = UIImage(named: "chatGrey")?.withRenderingMode(.alwaysOriginal)
        usersController.tabBarItem.title = "Chats"
        usersController.tabBarItem.selectedImage = UIImage(named: "chatWhite")?.withRenderingMode(.alwaysOriginal)
        usersController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(r: 177, g: 177, b: 177)], for: .normal)
        usersController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(r: 255, g: 255, b: 255)], for: .selected)
        
        secretChatUsersController.tabBarItem.image = UIImage(named: "secretChatGrey")?.withRenderingMode(.alwaysOriginal)
        secretChatUsersController.tabBarItem.title = "Secret Chats"
        secretChatUsersController.tabBarItem.selectedImage = UIImage(named: "secretChatWhite")?.withRenderingMode(.alwaysOriginal)
        secretChatUsersController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(r: 177, g: 177, b: 177)], for: .normal)
        secretChatUsersController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(r: 255, g: 255, b: 255)], for: .selected)
        
        let recentMessagesNavController = UINavigationController(rootViewController: usersController)
        let contactsNavcontroller = UINavigationController(rootViewController: contactsController)
        let secretChatsNavController = UINavigationController(rootViewController: secretChatUsersController)
        
        checkIfUserIsLoggedIn()
        
        viewControllers = [recentMessagesNavController,secretChatsNavController,contactsNavcontroller]
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    
    @objc func handleLogout() {
        present(PhoneNumberLoginController(), animated: true, completion: nil)
    }
    
}

