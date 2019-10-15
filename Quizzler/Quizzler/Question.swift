//
//  Question.swift
//  Quizzler
//
//  Created by Dan on 9/26/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class Question: NSObject {
    
    let questionText:String
    let answer:Bool
    
    init(text:String, correctAnswer:Bool) {
        questionText = text
        answer = correctAnswer
    }
    
}
