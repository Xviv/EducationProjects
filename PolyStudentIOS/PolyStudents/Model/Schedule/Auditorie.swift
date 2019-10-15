//
//  Auditorie.swift
//  PolyStudents
//
//  Created by Dan on 23/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct RoomsArray: Codable {
    let rooms: [Auditorie]
}

struct Auditorie: Codable {
    let id: Int?
    let name: String?
    let building: Building?
}

struct Building: Codable {
    let id: Int?
    let name: String?
    let abbr: String?
}
