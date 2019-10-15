//
//  Extensions.swift
//  PolyStudents
//
//  Created by Dan on 27/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit

//MARK: - UIViewController Extension
extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UITextField extension
extension UITextField {    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setTextFieldAttributes(textField: UITextField, placeholder: String, cornerRadius: CGFloat) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        
        textField.layer.cornerRadius = cornerRadius
        textField.layer.masksToBounds = true
        textField.clipsToBounds = true
    }
}


//MARK: - UILabel extension

extension UILabel {
    func adjustTextSizeToFitLabel() {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
    }
}

//MARK: - Date extension

extension Date {
    func formatDateToString() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dMMM")
        let result = formatter.string(from: self)
        return result
    }
}


//MARK: - UIImageView extension
extension UIImageView {
    func setCornerRadiusAndBorderWidthAndColor(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        
        self.layer.masksToBounds = true
    }
}

//MARK: UIColor extension

extension UIColor {
    convenience init(r: Double, g: Double , b: Double , alpha: Double) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(alpha))
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3
        
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadowWithParams(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

//MARK: - String extension

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//MARK: - Notification.name extension

extension Notification.Name {
    static let saveSelectedDate = Notification.Name(rawValue: "saveSelectedDate")
    
    static let saveSelectedSegment = Notification.Name(rawValue: "saveSelectedSegment")
}
