//
//  PageCell.swift
//  DoveChatApp
//
//  Created by Dan on 13.05.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit

class PageCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
            guard  let page = page else {
                return
            }
            imageView.image = UIImage(named: page.imageName)
            
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium),.foregroundColor: UIColor.white])
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium),.foregroundColor: UIColor.white]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let length = attributedText.string.characters.count
            attributedText.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "11")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        
        return iv
        
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample text"
        tv.isEditable = false
        tv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    func setupViews() {
        backgroundColor = UIColor(r: 35, g: 35, b: 35)
        
        addSubview(imageView)
        addSubview(textView)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(equalTo:self.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
