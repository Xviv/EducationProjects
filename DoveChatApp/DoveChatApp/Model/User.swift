//
//  User.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var phoneNumber: String?
    var email: String?
    var deviceID: String?
    var profileImageUrl: String?
    var status: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.deviceID = dictionary["deviceID"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.status = dictionary["status"] as? String
    }
}
