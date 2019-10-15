//
//  Groups.swift
//  PolyStudents
//
//  Created by Dan on 22/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct GroupsArray: Codable {
    var groups: [Group]
}

struct Group: Codable {
    let id: Int?
    let name: String?
}
