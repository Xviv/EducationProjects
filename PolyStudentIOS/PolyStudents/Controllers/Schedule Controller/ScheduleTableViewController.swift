//
//  ScheduleTableViewController.swift
//  PolyStudents
//
//  Created by Мария Волкова on 27/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import SVProgressHUD
import JTAppleCalendar
import Alamofire

class ScheduleTableViewController: UIViewController, selectedDateDelegate {
    func selectTheDate() -> String {
        return self.selectedDate
    }
    
    let baseURL = "***"
    
    private var currentDate = Date()
    private var curDateString: String = ""
    let apiClient = APIClient()
    var roomsArray:[Auditorie] = []
    var groupsArray:[Group] = []
    var teachersArray:[Teacher] = []
    var lessonsArray:[Day] = []
    var uniqLessons:[Day] = []
    var filteredArray: [Day] = []
    let searchBar = UISearchBar()
    let dataSource = ExpandableCalendarDataSource()
    var searchRequestText: String?
    
    enum direction {
        case right
        case left
    }
    
    var scrollDirection: direction?
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var expandableCalendarCollectionView: JTAppleCalendarView!
    @IBOutlet weak var calendarCollectionView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topCalendarConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthLabel: UILabel!
    
    private var leftConstraint: NSLayoutConstraint!
    let expandableView = ExpandableView()

    private var isAnimating: Bool = false
    private var dropDownViewIsDisplayed: Bool = false
    private var searchIsOpen = false
    
    private let todayDate = Date()
    let formatter = DateFormatter()
    var selectedDate: String = ""
    var selectedDateOfTypeDate = Date()
    var lastContentOffset: CGFloat = 0
    
    var roomId: Int = 0
    var buildingId: Int = 0
    var groupId: Int = 0
    var teacherId: Int = 0
    
    private let selectedDateColor = #colorLiteral(red: 0.1921568627, green: 0.6078431373, blue: 0.2392156863, alpha: 1)
    
    //MARK: - ViewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            tableView.addGestureRecognizer(tap)

        //NOTIFICATION
        NotificationCenter.default.addObserver(forName: .saveSelectedDate, object: nil, queue: OperationQueue.main) { (notification) in
            
            self.dateDidSelect(notification)
            
            DispatchQueue.main.async {
                self.closeSearch {
                    if self.searchIsOpen {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.leftConstraint.isActive = false
                            self.navigationItem.titleView?.alpha = 0
                            self.navigationItem.titleView?.layoutIfNeeded()
                        }) { (completed) in
                            if completed {
                                self.navigationItem.titleView = nil
                                self.navigationItem.titleView?.layoutIfNeeded()
                                self.searchIsOpen = !self.searchIsOpen
                            }
                        }
                    }
                }
                if (self.dropDownViewIsDisplayed) {
                    self.hideDropDownView()
                }
            }
        }
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        self.calendarView.dropShadow()
        
        calendarCollectionView.scrollToDate(todayDate, animateScroll: false)
        expandableCalendarCollectionView.scrollToDate(todayDate, animateScroll: false)
        searchBar.delegate = self
        
        expandableCalendarCollectionView.ibCalendarDataSource = dataSource
        expandableCalendarCollectionView.ibCalendarDelegate = dataSource
        dataSource.delegate = self
    
        tableView.register(UINib(nibName: "LessonTableViewCell", bundle: nil), forCellReuseIdentifier: "lessonCell")
        tableView.register(UINib(nibName: "TeacherTableCell", bundle: nil), forCellReuseIdentifier: "teacherCell")
        dateSetup(todayDate)
        searchBarSetup()
        navBarViewSetup()
    }
    
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.searchIsOpen = false
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        self.closeSearch(completion: nil)
        self.hideDropDownView()
        
    }
    
    private func dateDidSelect(_ notification: Notification) {
        let dateVC = notification.object as! ExpandableCalendarDataSource
        self.selectedDate = dateVC.selectedDate
        self.selectedDateOfTypeDate = dateVC.selectedDateOfTypeDate
        self.calendarCollectionView.reloadData()
        self.calendarCollectionView.scrollToDate(dateVC.selectedDateOfTypeDate, animateScroll: false)
        if (groupId != 0 || teacherId != 0 || roomId != 0) && self.searchBar.text != "" {
            searchForData(searchBar)
            searchBar.text = ""
        } else if (groupId == 0 && teacherId == 0 && roomId == 0) && self.searchBar.text != "" {
            searchForData(searchBar)
            searchBar.text = ""
        } else {
            self.downloadNewWeek()
        }
    }
    
    private func searchBarSetup() {
        assert(navigationController != nil, "This view controller MUST be embedded in a navigation controller.")
        
        // Search button.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggle))
        
        // Search bar.
        
        leftConstraint = searchBar.leftAnchor.constraint(equalTo: expandableView.leftAnchor)
        leftConstraint.isActive = false
        
        let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: attributeDict)
            
        }
        
        searchBar.showsCancelButton = false
        searchBar.tintColor = UIColor.black
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor(r: 230, g: 230, b: 230, alpha: 1)
        
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        searchBar.backgroundColor = self.navigationController?.navigationBar.barTintColor
    }
    
    @objc func toggle() {
        searchIsOpen = !searchIsOpen
        
        closeSearch {
            if self.searchIsOpen {
                UIView.animate(withDuration: 0.5, animations: {
                    self.leftConstraint.isActive = true
                    self.navigationItem.titleView?.layoutIfNeeded()
                })
            }
        }
    }
    
    func openSearch() {
        searchIsOpen = true
        
        navigationItem.titleView = expandableView
        expandableView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.rightAnchor.constraint(equalTo: expandableView.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: expandableView.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor).isActive = true
        
        if self.searchIsOpen {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationItem.titleView?.alpha = 1
                self.leftConstraint.isActive = true
                self.navigationItem.titleView?.layoutIfNeeded()
            })
        }
    }
    
    
    func closeSearch(completion: (() -> ())?) {
        
        if searchIsOpen {
            navigationItem.titleView = expandableView
            expandableView.addSubview(searchBar)
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.rightAnchor.constraint(equalTo: expandableView.rightAnchor).isActive = true
            searchBar.topAnchor.constraint(equalTo: expandableView.topAnchor).isActive = true
            searchBar.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor).isActive = true
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationItem.titleView?.alpha = 1
            if self.searchBar.text != "" {
                self.navigationItem.title = self.searchBar.text
            } else {
                if self.searchRequestText == nil {
                    self.navigationItem.title = "Расписание"
                } else {
                    self.navigationItem.title = self.searchRequestText
                }
                
            }
            self.navigationItem.titleView?.layoutIfNeeded()
        }) { (completed) in
            if completed {
                if !self.searchIsOpen {
                    UIView.animate(withDuration: 0.5, animations: {
                            self.leftConstraint.isActive = false
                            self.navigationItem.titleView?.alpha = 0
                            self.navigationItem.titleView?.layoutIfNeeded()
                    }) { (completed) in
                        if completed {
                            DispatchQueue.main.async {
                                self.navigationItem.titleView = nil
                                self.navigationItem.titleView?.layoutIfNeeded()
                            }
                        }
                    }
                }
                completion?()
            }
        }
    }
    
    func alertShow(title: String) -> Void {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }  

    //MARK: - View setup
    
    private func navBarViewSetup() {
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func dateSetup(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ru_RU")
        monthFormatter.dateFormat = "LLLL"
        let month = monthFormatter.string(from: date).capitalizingFirstLetter()
        
        self.monthLabel.text = month
        selectedDate = result
        dataSource.callFromOtherClass()
    }
    
    //MARK: - Helpers
    
    func cancelAllRequests(completion: @escaping () -> ()) {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func filterArray(_ array: [Day], selectedDate: String) {
        filteredArray = array.filter{$0.date == selectedDate}
    }
    
    private func containsOnlyLetters(input: String) -> Bool {
        for chr in input {
            if (!(chr >= "а" && chr <= "я") && !(chr >= "А" && chr <= "Я") ){
                return false
            }
        }
        
        return true
    }
    
    func removeDuplicates() -> [Day]{
        var i = 0
        var uniqueArray = self.lessonsArray
        
        for day in self.lessonsArray {
            var j = 1
            var h = 0
            if let les = day.lessons {
                for _ in les {
                    if j < uniqueArray[i].lessons!.count {
                        if self.lessonsArray[i].lessons![h].time_end == uniqueArray[i].lessons![j].time_end {
                            uniqueArray[i].lessons?.remove(at: j)
                            j += 1
                        }                }
                    h += 1
                }
                i += 1
            }
        }
        return uniqueArray
    }
    
    private func cleanAllArraysAndVariables() {
        lessonsArray = []
        uniqLessons = []
        filteredArray = []
        teachersArray = []
        groupsArray = []
        roomsArray = []
        roomId = 0
        groupId = 0
        buildingId = 0
        teacherId = 0
        searchRequestText = ""
    }
    
    //MARK: - Calendar show/hide funcs
    @IBAction func calendarButtonClicked(_ sender: Any) {
        if (self.dropDownViewIsDisplayed) {
            print(dropDownViewIsDisplayed)
            self.hideDropDownView()
        } else {
            self.showDropDownView()
        }
    }
    
    private func hideDropDownView() {
        self.animateDropDownToFrame(constraintConstant: -270) {
            self.dropDownViewIsDisplayed = false
        }
    }
    
    private func showDropDownView() {
        self.animateDropDownToFrame(constraintConstant: 0) {
            self.dropDownViewIsDisplayed = true
        }
    }
    
    private func animateDropDownToFrame(constraintConstant: CGFloat, completion: @escaping () -> Void) {
        self.topCalendarConstraint.constant = constraintConstant
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.calendarView.superview?.layoutIfNeeded()
        }) { (completed) in
            if completed {
                completion()
            }
        }
    }
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? DateCell else { return }
        
        if validCell.isSelected {
            DispatchQueue.main.async {
                validCell.selectedDateView.backgroundColor = self.selectedDateColor
                validCell.dateLabel.textColor = UIColor.white
            }
        } else {
            DispatchQueue.main.async {
                validCell.selectedDateView.backgroundColor = UIColor.clear
                validCell.dateLabel.textColor = UIColor.black
            }
        }
    }

}

    //MARK: - SearchBar delegate

extension ScheduleTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if self.dropDownViewIsDisplayed {
            self.hideDropDownView()
        }
        
        toggle()
        searchForData(searchBar)
        searchBar.text = ""
    }
    
    private func searchForData(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            SVProgressHUD.show()
            searchBar.endEditing(true)
            self.cleanAllArraysAndVariables()
        }
    
        var errCount = 0
        
        self.apiClient.getTeachersData(searchName: searchBar.text!, date: self.curDateString) { (responseArray, error) in
            if let err = error {
                errCount += 1
                if errCount == 3 {
                    SVProgressHUD.dismiss()
                    self.alertShow(title: err.localizedDescription)
                }
            } else {
                self.teachersArray = responseArray as! [Teacher]
                print("TEACHERS:\n\(self.teachersArray)")
                self.tableViewDataReload()
                SVProgressHUD.dismiss()
            }
        }
        
        self.apiClient.getRoomsData(searchName: searchBar.text!, date: self.curDateString, completion: { (responseArray, error) in
            if let err = error {
                errCount += 1
                if errCount == 3 {
                    SVProgressHUD.dismiss()
                    self.alertShow(title: err.localizedDescription)
                }
            } else {
                self.roomsArray = responseArray as! [Auditorie]
                self.tableViewDataReload()
                SVProgressHUD.dismiss()
            }
        })
        
        self.apiClient.getGroupsData(searchName: searchBar.text!, date: self.curDateString) { (responseArray, error) in
            if let err = error {
                errCount += 1
                if errCount == 3 {
                    SVProgressHUD.dismiss()
                    self.alertShow(title: err.localizedDescription)
                }
            } else {
                self.groupsArray = responseArray as! [Group]
                SVProgressHUD.dismiss()
                self.tableViewDataReload()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
}


