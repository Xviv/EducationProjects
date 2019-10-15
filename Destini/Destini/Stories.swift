//
//  Stories.swift
//  Destini
//
//  Created by Dan on 29/09/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class Stories {
    let story: String
    let currentStoryNumber: Int
    let answer1: String
    let answer2: String
    
    init(newStory:String,currentStory:Int, answ1: String, answ2: String) {
        story = newStory
        currentStoryNumber = currentStory
        answer1 = answ1
        answer2 = answ2
    }
}
