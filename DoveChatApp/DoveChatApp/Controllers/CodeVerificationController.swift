//
//  CodeVerificationController.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Firebase

class CodeVerificationController: UIViewController {
    
    let phoneNumberController = PhoneNumberLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        
        
        view.addSubview(codeInputField)
        view.addSubview(helpLabel)
        view.addSubview(viewNameLabel)
        view.addSubview(labelBottomLine)
        
        navigationController?.navigationBar.barTintColor = UIColor(r: 74, g: 74, b: 74)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleVerifyPhoneNumber))
        edgesForExtendedLayout = []
        
        self.hideKeyboardWhenTappedAround()
        
        setupAuthView()
        
    }
    
    @objc func  handleVerifyPhoneNumber() {
        let defaults = UserDefaults.standard

        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: self.codeInputField.text!)

        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
                
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error?.localizedDescription))", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID \(String(describing: userInfo?.providerID))")
                if #available(iOS 10.0, *) {
                    let userProfileView = UserProfileViewController()
                    self.show(userProfileView, sender: Any?.self)
                } else {
                    // Fallback on earlier versions
                    let userProfileView = UserProfileViewController()
                    self.show(userProfileView, sender: Any?.self)
                }
                

            }
        }
    }
    
    func setupAuthView() {
        
        viewNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        viewNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        codeInputField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeInputField.topAnchor.constraint(equalTo: viewNameLabel.bottomAnchor, constant: 20).isActive = true
        codeInputField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -72).isActive = true
        codeInputField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        labelBottomLine.topAnchor.constraint(equalTo: codeInputField.bottomAnchor).isActive = true
        labelBottomLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelBottomLine.widthAnchor.constraint(equalTo: codeInputField.widthAnchor).isActive = true
        labelBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        helpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpLabel.topAnchor.constraint(equalTo: labelBottomLine.bottomAnchor, constant: 30).isActive = true
        helpLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        helpLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let attributedString = NSMutableAttributedString(string: codeInputField.text!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 5, range: NSMakeRange(0, (codeInputField.text?.count)!))
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.thin), range: NSMakeRange(0, (codeInputField.text?.count)!))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, (codeInputField.text?.count)!))
        
        codeInputField.attributedText = attributedString
        codeInputField.textColor = UIColor.white
        
    }
    
    @objc func textFieldTouchDown(_ textField: UITextField) {
        labelBottomLine.backgroundColor = UIColor.white
        codeInputField.textColor = UIColor.white
    }
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        codeInputField.textColor = UIColor(r: 150, g: 150, b: 150)
        labelBottomLine.backgroundColor = UIColor.lightGray
    }
    
    let codeInputField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Code",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor(r: 150, g: 150, b: 150)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.thin)
        textField.textColor = UIColor.white
        textField.keyboardAppearance = .dark
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldTouchDown(_:)), for: .touchDown)
        textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        
        return textField
    }()
    
    let labelBottomLine: UILabel = {
        let bottomLine = UILabel()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.text = " "
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        return bottomLine
    }()
    
    let helpLabel: UILabel = {
        let helpLabel = UILabel()
        helpLabel.text = "We have sent you an SMS with the code."
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.textAlignment = .center
        helpLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        helpLabel.textColor = UIColor(r: 140, g: 140, b: 140)
        
        return helpLabel
    }()
    
    let viewNameLabel: UILabel = {
        let viewName = UILabel()
        viewName.textColor = UIColor.white
        viewName.text = "Verification Code"
        viewName.translatesAutoresizingMaskIntoConstraints = false
        viewName.textAlignment = .center
        viewName.backgroundColor = UIColor(r: 74, g: 74, b: 74)
        viewName.font = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.thin)
        
        return viewName
    }()
    
    
    
}

