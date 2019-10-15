//
//  StoriesDB.swift
//  Destini
//
//  Created by Dan on 29/09/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class StoriesDB {
    var listOfStories = [Stories]()
    
    let story1 = "Your car has blown a tire on a winding road in the middle of nowhere with no cell phone reception. You decide to hitchhike. A rusty pickup truck rumbles to a stop next to you. A man with a wide brimmed hat with soulless eyes opens the passenger door for you and asks: \"Need a ride, boy?\"."
    let answ1a = "I\'ll hop in. Thanks for the help!"
    let answ1b = "Better ask him if he\'s a murderer first."
    
    let story2 = "He nods slowly, unphased by the question."
    let answ2a = "At least he\'s honest. I\'ll climb in."
    let answ2b = "Wait, I know how to change a tire."
    
    let story3 = "As you begin to drive, the stranger starts talking about his relationship with his mother. He gets angrier and angrier by the minute. He asks you to open the glovebox. Inside you find a bloody knife, two severed fingers, and a cassette tape of Elton John. He reaches for the glove box."
    let answ3a = "I love Elton John! Hand him the cassette tape."
    let answ3b = "It\'s him or me! You take the knife and stab him."
    
    let story4 = "What? Such a cop out! Did you know traffic accidents are the second leading cause of accidental death for most adult age groups?"
    let story5 = "As you smash through the guardrail and careen towards the jagged rocks below you reflect on the dubious wisdom of stabbing someone while they are driving a car you are in."
    let story6 = "You bond with the murderer while crooning verses of \"Can you feel the love tonight\". He drops you off at the next town. Before you go he asks you if you know any good places to dump bodies. You reply: \"Try the pier.\""
    
    init() {
        listOfStories.append(Stories(newStory: story1, currentStory: 1, answ1: answ1a, answ2: answ1b))
        listOfStories.append(Stories(newStory: story2, currentStory: 2, answ1: answ2a, answ2: answ2b))
        listOfStories.append(Stories(newStory: story3, currentStory: 3, answ1: answ3a, answ2: answ3b))
        listOfStories.append(Stories(newStory: story4, currentStory: 4, answ1: "", answ2: ""))
        listOfStories.append(Stories(newStory: story5, currentStory: 5, answ1: "", answ2: ""))
        listOfStories.append(Stories(newStory: story6, currentStory: 6, answ1: "", answ2: ""))
    }
}
