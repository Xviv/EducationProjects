//
//  File.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Firebase
import PhoneNumberKit


class PhoneNumberLoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        
        
        view.addSubview(phoneInputField)
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
        let alert = UIAlertController(title: "Phone number ", message: "Is this your phone number? \n \(phoneInputField.text!)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneInputField.text!, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                    
                } else {
                    let defaults = UserDefaults.standard
                    defaults.set(verificationID, forKey: "authVID")
                    let verificationID = UserDefaults.standard
                    verificationID.string(forKey: "authVID")
                    let codeVerificationController = CodeVerificationController()
                    self.navigationController?.pushViewController(codeVerificationController, animated: true)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setupAuthView() {
        
        viewNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        viewNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        phoneInputField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneInputField.topAnchor.constraint(equalTo: viewNameLabel.bottomAnchor, constant: 20).isActive = true
        phoneInputField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        phoneInputField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        helpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpLabel.topAnchor.constraint(equalTo: labelBottomLine.bottomAnchor, constant: 30).isActive = true
        helpLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        helpLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        labelBottomLine.topAnchor.constraint(equalTo: phoneInputField.bottomAnchor).isActive = true
        labelBottomLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelBottomLine.widthAnchor.constraint(equalTo: phoneInputField.widthAnchor).isActive = true
        labelBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func textFieldTouchDown(_ textField: UITextField) {
        phoneInputField.text = "+"
        phoneInputField.textAlignment = .left
        phoneInputField.textColor = UIColor.white
        labelBottomLine.backgroundColor = UIColor.white
    }
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        if phoneInputField.text == "+" {
            phoneInputField.text = ""
        }
        phoneInputField.textAlignment = .center
        phoneInputField.textColor = UIColor(r: 150, g: 150, b: 150)
        labelBottomLine.backgroundColor = UIColor.lightGray
    }
    
    let phoneInputField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Phone number",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor(r: 150, g: 150, b: 150)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.thin)
        textField.textColor = UIColor.white
        textField.keyboardAppearance = .dark
        textField.addTarget(self, action: #selector(textFieldTouchDown(_:)), for: .touchDown)
        textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        textField.textAlignment = .center
        
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
        helpLabel.text = "Please enter your phone number."
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.textAlignment = .center
        helpLabel.textColor = UIColor(r: 140, g: 140, b: 140)
        
        return helpLabel
    }()
    
    let viewNameLabel: UILabel = {
        let viewName = UILabel()
        viewName.text = "Your Phone"
        viewName.textColor = UIColor.white
        viewName.translatesAutoresizingMaskIntoConstraints = false
        viewName.textAlignment = .center
        viewName.backgroundColor = UIColor(r: 74, g: 74, b: 74)
        viewName.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.thin)
        
        return viewName
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }       
}

