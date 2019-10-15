//
//  scholarship.swift
//  PolyStudents
//
//  Created by Dan on 25/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct Scholarship {
    var name: String?
    var date: String?
    var value: String?
    
    init(name: String, date: String, value: String) {
        self.name = name
        self.date = date
        self.value = value
    }
}
