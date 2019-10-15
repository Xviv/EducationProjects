//
//  Category.swift
//  Todoey
//
//  Created by Dan on 03/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
