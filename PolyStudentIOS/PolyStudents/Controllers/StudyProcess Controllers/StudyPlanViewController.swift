//
//  StudyPlanViewController.swift
//  PolyStudents
//
//  Created by Dan on 26/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import SafariServices

class StudyPlanViewController: UITableViewController, SFSafariViewControllerDelegate {

    var studyPlan: StudyPlan?
    var filteredArray: [Section] = []
    let defultUrl = "***"
    
    let searchbar = UISearchBar()
    private var leftConstraint: NSLayoutConstraint!
    let expandableView = ExpandableView()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
        tableView.register(UINib(nibName: "LessonCell", bundle: nil), forCellReuseIdentifier: "lessonCell")
        filterArray(studyPlan)
        searchbar.delegate = self
        searchBarSetup()
    }
    
    func filterArray(_ array: StudyPlan?) {
        if let array = array?.data?.bup {
            if !array.isEmpty {
                if let section = array[0].sections {
                    filteredArray = section.filter{$0.sem != nil}
                }
            }
            
        }
    }

    
    
    //MARK: - TableView Datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath) as! LessonCell
        if !filteredArray.isEmpty {
            cell.lessonNameLabel.text = filteredArray[indexPath.row].title
            cell.semester.text = "Семестр: " + filteredArray[indexPath.row].sem!
            cell.noDataLabel.text = ""
            if let hours = filteredArray[indexPath.row].hours {
                cell.hours.text = String(hours) + " ч."
            } else {
                cell.hours.text = ""
            }
            if let exam = filteredArray[indexPath.row].exam {
                switch exam {
                case 0:
                    cell.exam.text = "Зачет"
                case 1:
                    cell.exam.text = "Экзамен"
                default:
                    cell.exam.text = ""
                }
            } else {
                cell.exam.text = ""
            }
            cell.fileButton.isHidden = false
        } else {
            cell.selectionStyle = .none
            cell.lessonNameLabel.text = ""
            cell.semester.text = ""
            cell.hours.text = ""
            cell.exam.text = ""
            cell.noDataLabel.text = "Нет данных"
            cell.fileButton.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredArray.isEmpty {
            return 1
        }
        return filteredArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredArray.isEmpty {
            if let links = filteredArray[indexPath.row].links {
                alertShow(numberOfElements: links.count, indexPath: indexPath)
            }
        }
    }
    
    //MARK: - Searchbar setup
    
    private func searchBarSetup() {
        assert(navigationController != nil, "This view controller MUST be embedded in a navigation controller.")
        
        // Search button.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggle))
        
        // Search bar.
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        expandableView.addSubview(searchbar)
        leftConstraint = searchbar.leftAnchor.constraint(equalTo: expandableView.leftAnchor)
        leftConstraint.isActive = false
        
        let searchTextField: UITextField? = searchbar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: attributeDict)
            
        }
        
        searchbar.rightAnchor.constraint(equalTo: expandableView.rightAnchor).isActive = true
        searchbar.topAnchor.constraint(equalTo: expandableView.topAnchor).isActive = true
        searchbar.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor).isActive = true
        
        searchbar.showsCancelButton = true
        searchbar.tintColor = UIColor.black
        let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor(r: 230, g: 230, b: 230, alpha: 1)
        
        searchbar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        searchbar.backgroundColor = self.navigationController?.navigationBar.barTintColor
    }
    
    
    @objc func toggle() {
        self.navigationItem.titleView = self.expandableView
        
        let isOpen = leftConstraint.isActive == true
        
        // Inactivating the left constraint closes the expandable header.
        leftConstraint.isActive = isOpen ? false : true
        
        // Animate change to visible.
        UIView.animate(withDuration: 0.5, animations: {
            self.navigationItem.titleView?.alpha = isOpen ? 0 : 1
            self.navigationItem.titleView?.layoutIfNeeded()
        }) { (completed) in
            if isOpen {
                self.navigationItem.titleView = nil
                self.navigationItem.title = "Учебный план"
                self.navigationItem.titleView?.layoutIfNeeded()
            } else {
                UIView.animate(withDuration: 1, animations: {
                    self.navigationItem.titleView?.alpha = isOpen ? 0 : 1
                    self.navigationItem.titleView?.layoutIfNeeded()
                })
            }
        }
    }
    
    //MARK: - Helpers
    
    func alertShow(numberOfElements: Int, indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        if let links = filteredArray[indexPath.row].links {
            let alert = UIAlertController(title: filteredArray[indexPath.row].title, message: nil, preferredStyle: UIAlertController.Style.alert)
            
            for link in links {
                alert.addAction(UIAlertAction(title: link.title, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    self.openPDF(url: link.url ?? self.defultUrl, indexPath: indexPath)
                }))
            }
            
            if numberOfElements == 0 {
                alert.message = "Нет файла"
            }
            
            alert.addAction(UIAlertAction(title: "Отменить", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPDF(url: String, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let urlString = url
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }

    
    //MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: - Safari methods

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }

}

extension StudyPlanViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchbar.text!
        filteredArray = filteredArray.filter({($0.title?.lowercased().contains(text.lowercased()))!})
        
        searchBar.endEditing(true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text == "" {
            filterArray(studyPlan)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.text = ""
        searchBar.endEditing(true)
        toggle()
        filterArray(studyPlan)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
