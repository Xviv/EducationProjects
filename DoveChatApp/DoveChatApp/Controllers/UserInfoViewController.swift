//
//  UserInfoViewController.swift
//  DoveChatApp
//
//  Created by Dan on 17.05.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SimpleImageViewer

class UserInfoViewController: UIViewController {
    
    var user: User? {
        didSet {
            setupUserProfileData()
        }
    }
    let chatLogController = ChatLogController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        
        self.edgesForExtendedLayout = [UIRectEdge.bottom]
        
        var myTapGestureRecognizer = UITapGestureRecognizer()
        myTapGestureRecognizer.addTarget(self, action: #selector(showImage))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(myTapGestureRecognizer)
        
        
        setupUserProfileView()
        setupUserProfileData()
//        showImage()
        
    }
    
    func setupUserProfileData() {
        let userId = user?.id
        
        Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.userNameTitle.text = dictionary["name"] as? String
                self.phoneNumber.text = dictionary["phoneNumber"] as? String
                let userStatus = dictionary["status"] as? String
                if userStatus == "true" {
                    self.status.text = "Online"
                } else {
                    self.status.text = "Offline"
                }
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.userImage.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
            }
        }
    }
    
    @objc func sendMessage() {
        let userId = user?.id
        let ref = Database.database().reference().child("users").child(userId!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = userId
            self.showChatControllerForUser(user)
        })
    }
    
    func showChatControllerForUser(_ user: User) {
        let ChatVC = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        ChatVC.user = user
        self.navigationController?.pushViewController(ChatVC, animated: true)
    }
    
    @objc func startSecretChat() {
        let userId = user?.id
        let ref = Database.database().reference().child("users").child(userId!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = userId
            self.showChatControllerForUserSecret(user)
        })
    }
    
    func showChatControllerForUserSecret(_ user: User) {
        let secretChatVC = SecretChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        secretChatVC.user = user
        self.show(secretChatVC, sender: Any.self)
    }
    
    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }()
    
    @objc func showImage() {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = userImage
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        present(imageViewerController, animated: true)
        print("TEST")
    }
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 37.5
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "11")
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: image.image, action: #selector(showImage)))
        
        return image
    }()
    
    let userNameTitle: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 22)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "For now"
        name.textColor = .white
        
        return name
    }()
    
    let status: UILabel = {
        let status = UILabel()
        status.font = UIFont.systemFont(ofSize: 16)
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Online"
        status.textColor = UIColor(r: 190, g: 190, b: 190)
        
        return status
    }()
    
    let phoneNumberTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 14)
        title.text = "Phone number"
        title.textColor = UIColor(r: 247, g: 154, b: 27)
        
        return title
    }()
    
    let phoneNumber: UILabel = {
        let number = UILabel()
        number.translatesAutoresizingMaskIntoConstraints = false
        number.font = UIFont.systemFont(ofSize: 18)
        number.text = "+996771069555"
        number.textColor = .white
        
        return number
    }()
    
    let phoneSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 0.1)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send message", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor(r: 247, g: 154, b: 27), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(sendMessage), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let sendMessageButtonSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 0.1)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    let startSecretChatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start secret chat", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor(r: 247, g: 154, b: 27), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(startSecretChat), for: .touchUpInside)
        return button
    }()
    
    let startSecretButtonChatSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 0.1)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }()
    
    func setupUserProfileView() {
        view.addSubview(containerView)
        containerView.addSubview(userImage)
        containerView.addSubview(userNameTitle)
        containerView.addSubview(status)
        view.addSubview(phoneNumberTitle)
        view.addSubview(phoneNumber)
        view.addSubview(phoneSeparatorLine)
        view.addSubview(sendMessageButton)
        view.addSubview(sendMessageButtonSeparatorLine)
        view.addSubview(startSecretChatButton)
        view.addSubview(startSecretButtonChatSeparatorLine)
        
        //User profile data
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        userImage.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15).isActive = true
        userImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 75).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        userNameTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        userNameTitle.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 10).isActive = true
        userNameTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        userNameTitle.heightAnchor.constraint(equalTo: userNameTitle.heightAnchor).isActive = true
        
        status.topAnchor.constraint(equalTo: userNameTitle.bottomAnchor, constant: 10).isActive = true
        status.leftAnchor.constraint(equalTo: userNameTitle.leftAnchor).isActive = true
        status.widthAnchor.constraint(equalToConstant: 50).isActive = true
        status.heightAnchor.constraint(equalTo: status.heightAnchor).isActive = true
        
        //User phone number
        phoneNumberTitle.topAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 15).isActive = true
        phoneNumberTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35).isActive = true
        phoneNumberTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        phoneNumberTitle.heightAnchor.constraint(equalTo: phoneNumberTitle.heightAnchor).isActive = true
        
        phoneNumber.topAnchor.constraint(equalTo: phoneNumberTitle.bottomAnchor).isActive = true
        phoneNumber.leftAnchor.constraint(equalTo: phoneNumberTitle.leftAnchor).isActive = true
        phoneNumber.widthAnchor.constraint(equalToConstant: 150).isActive = true
        phoneNumber.heightAnchor.constraint(equalTo: phoneNumber.heightAnchor).isActive = true
        
        phoneSeparatorLine.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: 5).isActive = true
        phoneSeparatorLine.leftAnchor.constraint(equalTo: phoneNumberTitle.leftAnchor).isActive = true
        phoneSeparatorLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        phoneSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //send Message button
        sendMessageButton.topAnchor.constraint(equalTo: phoneSeparatorLine.bottomAnchor, constant: 30).isActive = true
        sendMessageButton.leftAnchor.constraint(equalTo: phoneSeparatorLine.leftAnchor).isActive = true
        sendMessageButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        sendMessageButton.heightAnchor.constraint(equalTo: sendMessageButton.heightAnchor).isActive = true
        
        sendMessageButtonSeparatorLine.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 5).isActive = true
        sendMessageButtonSeparatorLine.leftAnchor.constraint(equalTo: phoneNumberTitle.leftAnchor).isActive = true
        sendMessageButtonSeparatorLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sendMessageButtonSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //Secret Chat button
        startSecretChatButton.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 10).isActive = true
        startSecretChatButton.leftAnchor.constraint(equalTo: sendMessageButtonSeparatorLine.leftAnchor).isActive = true
        startSecretChatButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        startSecretChatButton.heightAnchor.constraint(equalTo: startSecretChatButton.heightAnchor).isActive = true
        
        startSecretButtonChatSeparatorLine.topAnchor.constraint(equalTo: startSecretChatButton.bottomAnchor, constant: 5).isActive = true
        startSecretButtonChatSeparatorLine.leftAnchor.constraint(equalTo: phoneNumberTitle.leftAnchor).isActive = true
        startSecretButtonChatSeparatorLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        startSecretButtonChatSeparatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
    }
    
}
