//
//  ViewController.swift
//  PushNotificationsSender
//
//  Created by Dan on 21/10/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Pushover

class SendNotificationViewController: UIViewController {
    
    @IBOutlet weak var keyInputTextField: UITextField!
    
    @IBOutlet weak var tokenInputTextField: UITextField!
    
    @IBOutlet weak var messageInputTextField: UITextField!
    
    @IBOutlet weak var delayInputTextField: UITextField!
    
    var storyArray = [Story]()
//    var messagesArray = [String]()
//    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("storyItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func sendNotification() {
        let pushover = Pushover(token: self.tokenInputTextField.text!)
        var notification = Notification(message: self.messageInputTextField.text!, to: self.keyInputTextField.text!)
        if delayInputTextField.text! != "" && messageInputTextField.text! != "" || tokenInputTextField.text! != "" || keyInputTextField.text! != ""{
            let time = Double(delayInputTextField.text!)! * 60
            
            let timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { (timer) in
                notification.devices(["iPhone"])
                notification.priority(.high)
                notification.sound(.intermission)
                pushover.send(notification) { result in
                    print(result)
                    // Хотел сделать, чтобы сообщения не сохранялись в случае неудачи и выводился Alert, но не знаю как сделать тут "В случае если ошибка то делай то, если успех то другое"
                    //Обычно этот complition блок выглядит {error in if error != nil {do something} else {do what you have to do}}
                }
                let storyItem = Story()
                
                storyItem.message = self.messageInputTextField.text!
                storyItem.toId = self.tokenInputTextField.text!
                
                self.storyArray.append(storyItem)
                
//                self.defaults.set(self.messagesArray, forKey: "messages")
                self.saveItems()
            }
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        } else {
            let alert = UIAlertController(title: "Error", message: "Fill all inputs", preferredStyle: .alert)
            let action = UIAlertAction(title: "cancel", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        sendNotification()
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(storyArray)
            try data.write(to: dataFilePath!)
        } catch  {
            print("encode data error \(error)")
        }
        
    }
    
}

