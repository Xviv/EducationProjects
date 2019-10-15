//
//  OrdersViewController.swift
//  PolyStudents
//
//  Created by Dan on 25/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderTableView: UITableView!
    
    let cellId = "contractCell"
    var contracts = [Contract]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //            sideMenuManager?.instance()?.menu?.disabled = false
        orderTableView.dataSource = self
        orderTableView.delegate = self

        let nib = UINib(nibName: "ContractCell", bundle: nil)
        orderTableView.register(nib, forCellReuseIdentifier: cellId)
        
        
        makeSomeScholarships()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func makeSomeScholarships() {
        let contract1 = Contract(date: "21.02.2013", name: "2245-CK", description: "Супер длинное описание этого документа и бла бла бла и еще немного")
        let contract2 = Contract(date: "25.08.2020", name: "1111-JR", description: "Это документ :)")
        let contract3 = Contract(date: "25.08.2020", name: "1111-JR", description: "Это документ :)")
        let contract4 = Contract(date: "25.08.2020", name: "1111-JR", description: "Это документ :)")
        
        contracts.append(contract1)
        contracts.append(contract2)
        contracts.append(contract3)
        contracts.append(contract4)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContractCell
        
        cell.nameLabel.text = contracts[indexPath.row].name
        cell.dateLabel.text = contracts[indexPath.row].date
        cell.descLabel.text = contracts[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contracts.count
    }
}
