//
//  QuestionBank.swift
//  Quizzler
//
//  Created by Dan on 9/27/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class QuestionBank {
    var listOfQuestions = [Question]()
    
    init() {
        // Creating a quiz item and appending it to the list
        let item = Question(text: "Valentine\'s day is banned in Saudi Arabia.", correctAnswer: true)
        
        // Add the Question to the list of questions
        listOfQuestions.append(item)
        
        // skipping one step and just creating the quiz item inside the append function
        listOfQuestions.append(Question(text: "A slug\'s blood is green.", correctAnswer: true))
        
        listOfQuestions.append(Question(text: "Approximately one quarter of human bones are in the feet.", correctAnswer: true))
        
        listOfQuestions.append(Question(text: "The total surface area of two human lungs is approximately 70 square metres.", correctAnswer: true))
        
        listOfQuestions.append(Question(text: "In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.", correctAnswer: true))
        
        listOfQuestions.append(Question(text: "In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.", correctAnswer: false))
        
        listOfQuestions.append(Question(text: "It is illegal to pee in the Ocean in Portugal.", correctAnswer: true))
        
        listOfQuestions.append(Question(text: "You can lead a cow down stairs but not up stairs.", correctAnswer: false))
        
        listOfQuestions.append(Question(text: "Google was originally called \"Backrub\".", correctAnswer: true))
        
        listOfQuestions.append(Question(text: "Buzz Aldrin\'s mother\'s maiden name was \"Moon\".", correctAnswer: true))
        
        listOfQuestions.append(Question(text: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", correctAnswer: false))
        
        listOfQuestions.append(Question(text: "No piece of square dry paper can be folded in half more than 7 times.", correctAnswer: false))
        
        listOfQuestions.append(Question(text: "Chocolate affects a dog\'s heart and nervous system; a few ounces are enough to kill a small dog.", correctAnswer: true))
    }
}
