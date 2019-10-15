//
//  ContactsViewController.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Contacts

var contactsPhoneNumbers = [PhoneContacts]()

class ContactsViewController: UITableViewController {

    let store = CNContactStore()
    
    var contacts = [PhoneContacts]()
    var contactsCell = ContactCell()
    
    
    let cellId = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        self.tableView.separatorColor = UIColor(r: 29, g: 29, b: 29)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddContact))
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController?.searchBar.tintColor = UIColor.white
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.barTintColor = UIColor(r: 74, g: 74, b: 74)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.title = "Contacts"
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("failed to request contacts", err)
                return
            }
            if granted {
                print("Access granted")
                
            }
            else {
                print("Access denied")
            }
        }
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        fetchContacts()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        let contactName = self.contacts[indexPath.row]
        
        cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        (cell as! ContactCell).configure(name: contactName.name!)
        
        cell?.textLabel?.text = contactName.name
        
        cell?.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        cell?.textLabel?.textColor = UIColor.white
        
        return cell!
    }
    
    private func fetchContacts() {
        
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey,CNContactFamilyNameKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try  store.enumerateContacts(with: request) { (contact, stoppingPointer) in
                let name = contact.givenName
                let familyName = contact.familyName
                let number = contact.phoneNumbers
                
                let contactToAppend = PhoneContacts(name: name + " " + familyName)
                self.contacts.append(contactToAppend)
            }
        } catch let err {
            print("Cant fetch contacts")
        }
        tableView.reloadData()
        
    }
    
    func addContact() {
        
    }
    
    @objc func handleAddContact() {
        
    }
    
    
    
}

