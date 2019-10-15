//
//  ChatInputContainerView.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Firebase

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    var timer: Timer? = nil
    
    weak var chatLogController: ChatLogController? {
        didSet {
            sendButton.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleSend)))
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap)))
        }
    }
    
    weak var secretChatLogController: SecretChatLogController? {
        didSet {
            sendButton.addGestureRecognizer(UITapGestureRecognizer(target: secretChatLogController, action: #selector(SecretChatLogController.handleSend)))
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: secretChatLogController, action: #selector(SecretChatLogController.handleUploadTap)))
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter message...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        textField.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 17
        textField.delegate = self
        textField.textColor = UIColor.white
        textField.keyboardAppearance = .dark
        textField.setLeftPaddingPoints(15)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        return textField
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if Auth.auth().currentUser?.uid != nil {
            
            let userId = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference().child("users").child(userId!).child("status")
            ref.setValue("typing") // NO
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(setStatusValueTyping), userInfo: ["textField": textField], repeats: false)
            
        }
        return true
    }
    
    @objc func setStatusValueTyping() {
        if Auth.auth().currentUser?.uid != nil {

            let userId = Auth.auth().currentUser?.uid

            let ref = Database.database().reference().child("users").child(userId!).child("status")
            ref.setValue("true") // NO

        }
    }
    
    @objc func setStatusValueNotTyping() {
        if Auth.auth().currentUser?.uid != nil {
            
            let userId = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference().child("users").child(userId!).child("status")
            ref.setValue("true") // NO
            
        }
    }
    
   @objc func textFieldDidEndEditing(_ textField: UITextField) {
    
    print("EDITING END")
        if Auth.auth().currentUser?.uid != nil {
            
            let userId = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference().child("users").child(userId!).child("status")
            ref.setValue("true") // NO
            
        }
    }
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "paperClip")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    let sendButton: UIImageView = {
        let sendButton = UIImageView()
        sendButton.isUserInteractionEnabled = true
        sendButton.image = UIImage(named: "SendButton")
        sendButton.layer.cornerRadius = 20
        sendButton.layer.masksToBounds = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(uploadImageView)
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -15).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 65, g: 65, b: 65)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        secretChatLogController?.handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

