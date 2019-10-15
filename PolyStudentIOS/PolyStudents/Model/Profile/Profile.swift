//
//  Profile.swift
//  PolyStudents
//
//  Created by Dan on 17/03/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import Foundation

// Structs to get access token
struct ProfilesArray: Codable {
    let data: UserData
}

struct UserData: Codable {
    let profiles: [ProfilesId]
    let access_token: String?
}

struct ProfilesId: Codable {
    let id: Int?
}

// Structs for user profile data
struct ProfileDataArray: Codable {
    let data: ProfileData?
}
struct ProfileData: Codable {
    let profile: Profile?
    let user: User?
}
struct Profile: Codable {
    let id: Int?
    let edu_level: String?
    let edu_specialization: Specialization?
    let faculty: Faculty?
    let edu_direction: Direction?
    let edu_group: EduGroup?
    let edu_semester: Int?
    let edu_course: Int?
    let edu_form: String?
    let edu_mark_book_num: String?
    let edu_qualification: Qualification?
    let cathedra: String?
    let edu_status: String?
    let edu_year: Int?
}

struct User: Codable {
    let fullname: String?
    let id: Int?
}

struct Qualification: Codable {
    let title: String?
}

struct Specialization: Codable {
    let title: String?
}

struct Faculty: Codable {
    let title: String?
    let short_title: String?
}

struct Direction: Codable {
    let title: String?
    let short_title: String?
}

struct EduGroup: Codable {
    let title: String?
}
