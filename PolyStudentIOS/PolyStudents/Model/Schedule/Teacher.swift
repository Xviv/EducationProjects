//
//  Teacher.swift
//  PolyStudents
//
//  Created by Dan on 23/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct TeachersArray: Codable {
    let teachers: [Teacher]
}

struct Teacher: Codable {
    let id: Int?
    let full_name: String?
    let chair: String?
}
