//
//  UserProfileViewController.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Firebase
import BigInt


class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var messagesController: MessagesController?
    var keyGeneration = MessagesController()
    let pubKey: String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6E3JnMFjxquwGfn09DzuqJLBUEGUX0esWVdqER0g94W02AR4CeAqQs5wTWSsZavn8XSgP/b+b6uLqWOHJl7VnwHpdwYM/AE4B45XVhCmCUoMOzTWx4D/gbnIMvCC/BUxdAIbJfqc7HTL6IILwBTNll6JB8vZXx/awOIJefDik2wIDAQAB"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        
        
        view.addSubview(nameInputField)
        view.addSubview(helpLabel)
        view.addSubview(viewNameLabel)
        view.addSubview(familyNameInputField)
        view.addSubview(labelBottomLine)
        view.addSubview(secondLabelBottomLine)
        view.addSubview(circleView)
        
        navigationController?.navigationBar.barTintColor = UIColor(r: 74, g: 74, b: 74)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleAddUserInfo))
        edgesForExtendedLayout = []
        
        self.hideKeyboardWhenTappedAround()
        
        setupAuthView()
        
    }
    
    func configure(name: String) {
        circleView.setImage(string: name, color: UIColor.colorHash(name: name), circular: true)
    }
    
    func setupAuthView() {
        
        viewNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        viewNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameInputField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameInputField.topAnchor.constraint(equalTo: viewNameLabel.bottomAnchor).isActive = true
        nameInputField.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 10).isActive = true
        nameInputField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        labelBottomLine.topAnchor.constraint(equalTo: nameInputField.bottomAnchor).isActive = true
        labelBottomLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        labelBottomLine.widthAnchor.constraint(equalTo: nameInputField.widthAnchor).isActive = true
        labelBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        helpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpLabel.topAnchor.constraint(equalTo: secondLabelBottomLine.bottomAnchor, constant: 20).isActive = true
        helpLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        helpLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        familyNameInputField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        familyNameInputField.topAnchor.constraint(equalTo: labelBottomLine.bottomAnchor).isActive = true
        familyNameInputField.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 10).isActive = true
        familyNameInputField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        secondLabelBottomLine.topAnchor.constraint(equalTo: familyNameInputField.bottomAnchor).isActive = true
        secondLabelBottomLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        secondLabelBottomLine.widthAnchor.constraint(equalTo: familyNameInputField.widthAnchor).isActive = true
        secondLabelBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        circleView.topAnchor.constraint(equalTo: viewNameLabel.bottomAnchor, constant: 10).isActive = true
        circleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 112).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 112).isActive = true
        
        circleView.addSubview(addImageLabel)

        addImageLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
        addImageLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
        addImageLabel.widthAnchor.constraint(equalTo: circleView.widthAnchor, constant: -40).isActive = true
        addImageLabel.heightAnchor.constraint(equalTo: circleView.widthAnchor, constant: -40).isActive = true
        
    }
    let textAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 50), NSAttributedStringKey.foregroundColor: UIColor.white]
    
    func imageConfigure(name: String) {
        circleView.setImage(string: name, color: UIColor.colorHash(name: name), circular: true, textAttributes: textAttributes )
    }
    
    
    @objc func  handleAddUserInfo() {
        
        if nameInputField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Enter your name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
            guard let name = nameInputField.text, let secondName = familyNameInputField.text else {
                print("Form is not valid")
                return
            }
            print("кнопка работает")
            
            let uid = Auth.auth().currentUser?.uid
            
            let phoneNumber = Auth.auth().currentUser?.phoneNumber
            
            addImageLabel.text = ""
            if circleView.image == nil {
                imageConfigure(name: name + " " + secondName)
            }
            
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.circleView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        (print("и тут Все работает"))
                        
                        let token = AppDelegate.DEVICEID
                        let status = "true"
                        
                        print("Here is TOKEN\n\(token)")
                        if self.nameInputField.text == "Даниил" {
                            let values = ["name": name + " " + secondName,"phoneNumber": phoneNumber!, "profileImageUrl": profileImageUrl,"deviceID": token, "status": status, "openKey": PUBLIC_KEY]
                            
                            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                            
                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                            loadingIndicator.startAnimating();
                            
                            alert.view.addSubview(loadingIndicator)
                            self.present(alert, animated: true, completion: nil)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                self.registerUserIntoDatabaseWithUID(uid!, values: values as [String : AnyObject])
                            })
                        } else {
                            let values = ["name": name + " " + secondName,"phoneNumber": phoneNumber!, "profileImageUrl": profileImageUrl,"deviceID": token, "status": status, "openKey": self.pubKey]
                            
                            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                            
                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                            loadingIndicator.startAnimating();
                            
                            alert.view.addSubview(loadingIndicator)
                            self.present(alert, animated: true, completion: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                self.registerUserIntoDatabaseWithUID(uid!, values: values as [String : AnyObject])
                            })
                            
                        }
                    }
                })
            }
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        dismiss(animated: false, completion: nil)
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            (print("Все работает"))
            let user = User(dictionary: values)
            self.messagesController?.setupNavBarWithUser(user)
            
            self.present(CustomTabBarController(), animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
           
            circleView.image = selectedImage
            addImageLabel.text = ""
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    let nameInputField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "First name",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor(r: 150, g: 150, b: 150)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        textField.textColor = UIColor.white
        textField.keyboardAppearance = .dark
        
        
        return textField
    }()
    
    let familyNameInputField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Second name",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor(r: 150, g: 150, b: 150)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        textField.textColor = UIColor.white
        textField.keyboardAppearance = .dark
        
        
        return textField
    }()
    
    let labelBottomLine: UILabel = {
        let bottomLine = UILabel()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.text = " "
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        return bottomLine
    }()
    
    let secondLabelBottomLine: UILabel = {
        let bottomLine = UILabel()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.text = " "
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        return bottomLine
    }()
    
    let helpLabel: UILabel = {
        let helpLabel = UILabel()
        helpLabel.text = "Enter your name and add profile picture."
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.textAlignment = .center
        helpLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        helpLabel.textColor = UIColor(r: 140, g: 140, b: 140)
        helpLabel.numberOfLines = 2
        
        
        return helpLabel
    }()
    
    let viewNameLabel: UILabel = {
        let viewName = UILabel()
        viewName.textColor = UIColor.white
        viewName.text = "Your Info"
        viewName.translatesAutoresizingMaskIntoConstraints = false
        viewName.textAlignment = .center
        viewName.backgroundColor = UIColor(r: 74, g: 74, b: 74)
        viewName.font = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.thin)
        
        return viewName
    }()
    
    lazy var addImageLabel: UILabel = {
        let addImageLabel = UILabel()
        addImageLabel.text = "add photo"
        addImageLabel.translatesAutoresizingMaskIntoConstraints = false
        addImageLabel.numberOfLines = 2
        addImageLabel.textAlignment = .center
        addImageLabel.textColor = UIColor.lightGray
        addImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        addImageLabel.isUserInteractionEnabled = true

        return addImageLabel
    }()
    
    lazy var circleView: UIImageView = {
        let circle = UIImageView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = UIColor.red.withAlphaComponent(0.0)
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = 56
        circle.layer.borderWidth = 1
        circle.layer.borderColor = UIColor.lightGray.cgColor
        circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        circle.isUserInteractionEnabled = true
        
        return circle
    }()
}
