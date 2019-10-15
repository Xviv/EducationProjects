//
//  ViewController.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // UI Elements linked to the storyboard
    @IBOutlet weak var topButton: UIButton!         // Has TAG = 1
    @IBOutlet weak var bottomButton: UIButton!      // Has TAG = 2
    @IBOutlet weak var storyTextView: UILabel!
    
    // TODO Step 5: Initialise instance variables here
    
    let allStories = StoriesDB()
    var storyNum:Int = 0
    var end = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextStory()
        // TODO Step 3: Set the text for the storyTextView, topButton, bottomButton, and to T1_Story, T1_Ans1, and T1_Ans2
        
    }
    func viewUpdate(numberOfStory:Int) {
        storyTextView.text = allStories.listOfStories[numberOfStory].story
        topButton.setTitle(allStories.listOfStories[numberOfStory].answer1, for: .normal)
        bottomButton.setTitle(allStories.listOfStories[numberOfStory].answer2, for: .normal)
        end = false
    }
    
    // User presses one of the buttons
    @IBAction func buttonPressed(_ sender: UIButton) {
        var myStoryIndex = allStories.listOfStories[storyNum].currentStoryNumber
        //storyNum == 0
        
        if sender.tag == 1 {
            if end == true {
                myStoryIndex = 0
                nextStory()
            }
            if myStoryIndex == 1 {
                viewUpdate(numberOfStory: 2)
                //0 + 2
                storyNum = 2
            }
            else if myStoryIndex == 3 {
                storyTextView.text = allStories.listOfStories[5].story
                topButton.setTitle("Start new story?", for: .normal)
                bottomButton.isHidden = true
                //end
                end = true
            }
            else if myStoryIndex == 2 {
                viewUpdate(numberOfStory: 2)
                //1 + 1
                storyNum = 2
            }
        }
        
        else if sender.tag == 2 {
            if myStoryIndex == 1 {
                viewUpdate(numberOfStory: 1)
                // 0 + 1
                storyNum = 1
            }
            else if myStoryIndex == 2 {
                storyTextView.text = allStories.listOfStories[3].story
                topButton.setTitle("Start new story?", for: .normal)
                bottomButton.isHidden = true
                //end
                end = true
            }
            else if myStoryIndex == 3 && end == false {
                storyTextView.text = allStories.listOfStories[4].story
                topButton.setTitle("Start new story?", for: .normal)
                bottomButton.isHidden = true
                //end
                end = true                
            }
        }
    }
    
    func nextStory() {
        end = false
        storyNum = 0
        bottomButton.isHidden = false
        storyTextView.text = allStories.listOfStories[0].story
        topButton.setTitle(allStories.listOfStories[0].answer1, for: .normal)
        bottomButton.setTitle(allStories.listOfStories[0].answer2, for: .normal)
        
    }
}

