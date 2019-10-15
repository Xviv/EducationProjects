//
//  DocumentsViewController.swift
//  PolyStudents
//
//  Created by Dan on 25/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit

class ScholarshipsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var scholarshipTableView: UITableView!
    let cellId = "scholarshipCell"
    var scholarships = [Scholarship]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//            sideMenuManager?.instance()?.menu?.disabled = false
        scholarshipTableView.dataSource = self
        scholarshipTableView.delegate = self
        
        let nib = UINib(nibName: "ScholarshipCell", bundle: nil)
        scholarshipTableView.register(nib, forCellReuseIdentifier: cellId)
        
        
        makeSomeScholarships()
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func makeSomeScholarships() {
        let newScholarship = Scholarship(name: "Какая-то крутая стипендия", date: "21.01.18", value: "2000 Р")
        let moreScholarship = Scholarship(name: "Какая-то супер крутая стипендия", date: "21.01.18", value: "2500 Р")
        
        scholarships.append(newScholarship)
        scholarships.append(moreScholarship)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ScholarshipCell
        
        cell.nameScholarshipLabel.text = scholarships[indexPath.row].name
        cell.valueScholarshipLabel.text = scholarships[indexPath.row].value
        cell.dateScholarshipLabel.text = scholarships[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scholarships.count
    }
}
