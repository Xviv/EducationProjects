//
//  RecordBook.swift
//  PolyStudents
//
//  Created by Dan on 26/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct RecordBook: Codable {
    let data: RBData
}

struct RBData: Codable {
    //TODO: - Сделать опциональнм
    let marks: [Marks]
}

struct Marks: Codable, Equatable {
    let semester: Int?
    let year: Int?
    let hours: String?
    let control_type: String?
    let subject: String?
    let lecturers: String?
    let mark_value: MarkValue?
    
    static func == (lhs: Marks, rhs: Marks) -> Bool {
        return lhs.semester == rhs.semester
    }
}

struct MarkValue: Codable {
    let title: String?
    let value: Int?
}
