//
//  Plan.swift
//  PolyStudents
//
//  Created by Dan on 26/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation

struct WorkPlan: Codable {
    let data: WorkData
}

struct StudyPlan: Codable {
    let data: StudyData?
}

struct WorkData: Codable {
    let rup: [Bup]?
}

struct StudyData: Codable {
    let bup: [Bup]?
}
struct Bup : Codable {
    let sections: [Section]?
}

struct Section: Codable {
    let id: Int?
    let parent_id: Int?
    let title: String?
    let num: String?
    let sem: String?
    let exam: Int?
    let hours: Int?
    let labs: Int?
    let lections: Int?
    let practice: Int?
    let links: [Link]?
}

struct Link: Codable {
    let title: String?
    let url: String?
}
