//
//  ExpandableView.swift
//  PolyStudents
//
//  Created by Dan on 20/04/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

class ExpandableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}


