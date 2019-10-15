//
//  Lessons.swift
//  PolyStudents
//
//  Created by Dan on 22/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct LessonsArray: Codable {
    var days:[Day]
}

struct Lesson: Codable {
    let subject: String?
    let time_end: String?
    let time_start: String?
    let typeObj: TypeObj?
    let teachers: [Teacher]?
    let auditories: [Auditorie]?
    
}
struct TypeObj: Codable {
    let name: String?
}
struct Day: Codable {
    let weekday: Int?
    let date: String?
    var lessons: [Lesson]?
}


