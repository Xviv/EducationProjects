//
//  Contract.swift
//  PolyStudents
//
//  Created by Dan on 25/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct Contract {
    var date: String?
    var name: String?
    var description: String?
    
    init(date: String, name: String, description: String) {
        self.date = date
        self.name = name
        self.description = description
    }
}
