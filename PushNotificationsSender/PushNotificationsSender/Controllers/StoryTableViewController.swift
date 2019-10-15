//
//  StoryTableViewController.swift
//  PushNotificationsSender
//
//  Created by Dan on 21/10/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit

class StoryTableViewController: UITableViewController {
    
//    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("storyItems.plist")
    var storyArray = [Story]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
//        if let messages = defaults.array(forKey: "messages") as? [String] {
//            messagesArray = messages
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = storyArray[indexPath.row].message
        cell.detailTextLabel?.text = storyArray[indexPath.row].toId
        
        return cell
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                storyArray = try decoder.decode([Story].self, from: data)
            } catch {
                print("Decode error \(error)")
            }
        }
    }
    
}
