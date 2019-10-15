//
//  ScheduleDataSource.swift
//  PolyStudents
//
//  Created by Dan on 21/04/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit
import SVProgressHUD

extension ScheduleTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        if groupsArray.isEmpty || roomsArray.isEmpty {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !uniqLessons.isEmpty {
            return nil
        }
        
        if !teachersArray.isEmpty {
            if section == 0 {
                return "Выберите преподавателя"
            }
        }
        
        if !groupsArray.isEmpty && !roomsArray.isEmpty {
            if section == 0 {
                return "Выберите группу"
            }
            if section == 1 {
                return "Выберите аудиторию"
            }
        } else if !groupsArray.isEmpty && roomsArray.isEmpty {
            if section == 0 {
                return "Выберите группу"
            }
        } else if groupsArray.isEmpty && !roomsArray.isEmpty {
            if section == 0 {
                return "Выберите аудиторию"
            }
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !uniqLessons.isEmpty {
           filterArray(uniqLessons, selectedDate: selectedDate)

            if !filteredArray.isEmpty {
                if let filtered = filteredArray[0].lessons {
                    return filtered.count
                }
            } else {
                return 1
            }
        }
        
        if !teachersArray.isEmpty {
            if section == 0 {
                return teachersArray.count
            }
        }
        
        if !groupsArray.isEmpty && !roomsArray.isEmpty {
            if section == 0 {
                return groupsArray.count
            }
            if section == 1 {
                return roomsArray.count
            }
        } else if !groupsArray.isEmpty && roomsArray.isEmpty {
            if section == 0 {
                return groupsArray.count
            }
        } else if groupsArray.isEmpty && !roomsArray.isEmpty {
            if section == 0 {
                return roomsArray.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Lessons
        if !filteredArray.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath) as! LessonTableCell
            
            filterArray(uniqLessons, selectedDate: selectedDate)
            if !filteredArray.isEmpty {
                tableViewCellSetup(cell, array: filteredArray, indexPath: indexPath)
            }
            return cell
        } else if filteredArray.isEmpty && teachersArray.isEmpty && groupsArray.isEmpty && roomsArray.isEmpty && groupId == 0 && teacherId == 0 && roomId == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath) as! LessonTableCell
            cell.toggleSearchButton.isEnabled = true
            cell.buttonTappedAction = {
                self.openSearch()
                print("Button tapped")
            }
            
            emptyCellSetup(message: "Введите данные в поиск", cell)
            
            return cell
            
        } else if filteredArray.isEmpty && teachersArray.isEmpty && groupsArray.isEmpty && roomsArray.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath) as! LessonTableCell
            
            cell.toggleSearchButton.isEnabled = false
            
            emptyCellSetup(message: "Нет занятий сегодня", cell)
            
            return cell
        } else if !teachersArray.isEmpty {
            tableView.allowsSelection = true
            tableView.separatorStyle = .singleLine
            
            let selectableCell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! TeacherTableViewCell
            
            selectableCell.name.text = teachersArray[indexPath.row].full_name
            selectableCell.chair.text = teachersArray[indexPath.row].chair
            
            return selectableCell
            
        } else if !groupsArray.isEmpty && !roomsArray.isEmpty {
            tableView.allowsSelection = true
            tableView.separatorStyle = .singleLine
            
            let selectableCell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! TeacherTableViewCell
            
            if indexPath.section == 0 {
                DispatchQueue.main.async {
                    selectableCell.name.text = self.groupsArray[indexPath.row].name
                    selectableCell.chair.text = ""
                }
                return selectableCell
            }
            if indexPath.section == 1 {
                DispatchQueue.main.async {
                    selectableCell.name.text = self.roomsArray[indexPath.row].name
                    selectableCell.chair.text = self.roomsArray[indexPath.row].building?.name
                }
                
                return selectableCell
            }
        } else if !groupsArray.isEmpty && roomsArray.isEmpty {
            tableView.allowsSelection = true
            tableView.separatorStyle = .singleLine
            print(groupsArray)
            
            let selectableCell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! TeacherTableViewCell
            
            if indexPath.section == 0 {
                DispatchQueue.main.async {
                    selectableCell.name.text = self.groupsArray[indexPath.row].name
                    selectableCell.chair.text = ""
                }
                return selectableCell
            }
        } else if groupsArray.isEmpty && !roomsArray.isEmpty {
            tableView.allowsSelection = true
            tableView.separatorStyle = .singleLine
            
            let selectableCell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! TeacherTableViewCell
            
            if indexPath.section == 0 {
                DispatchQueue.main.async {
                    selectableCell.name.text = self.roomsArray[indexPath.row].name
                    selectableCell.chair.text = self.roomsArray[indexPath.row].building?.name
                }
                return selectableCell
            }
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath) as! LessonTableCell
        
        
        return cell
    }
    //MARK: - LEsson cell setup
    func emptyCellSetup(message: String,_ cell: LessonTableCell) {
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        cell.noLessonsLabel.text = message
        cell.subjectLabel.text = ""
        cell.subjectLabel.textAlignment = .center
        cell.timeLabel.text = ""
        cell.auditorie.text = ""
        cell.teacherFullName.text = ""
        cell.typeObject.text = ""
    }
    
    func tableViewCellSetup (_ cell: LessonTableCell, array: [Day], indexPath: IndexPath) {
        
        cell.toggleSearchButton.isEnabled = false
        
        let redColor = UIColor(r: 192, g: 91, b: 81, alpha: 1)
        let blueColor = UIColor(r: 89, g: 118, b: 197, alpha: 1)
        
        let lessons = array[0].lessons?[indexPath.row]
        
        DispatchQueue.main.async {
            switch lessons?.typeObj?.name {
            case "Практика":
                cell.typeObjView.backgroundColor = redColor
            case "Лабораторные":
                cell.typeObjView.backgroundColor = blueColor
            case "Лекции":
                cell.typeObjView.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.6078431373, blue: 0.2392156863, alpha: 1)
            default:
                return
            }
        }
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        cell.noLessonsLabel.text = ""
        cell.subjectLabel.text = lessons?.subject
        cell.subjectLabel.textAlignment = .left
        cell.timeLabel.text = "\(lessons?.time_start ?? "")\(lessons?.time_end ?? "")"
        if let building = lessons?.auditories?[0].building?.abbr {
            if let auditorie = lessons?.auditories?[0].name {
                cell.auditorie.text = building + " \(auditorie)"
            } else {
                cell.auditorie.text = building
            }
        } else {
            cell.auditorie.text = ""
        }
        
        cell.teacherFullName.text = lessons?.teachers?[0].full_name
        cell.typeObject.text = lessons?.typeObj?.name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.cancelAllRequests {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
               SVProgressHUD.show()
                if !self.teachersArray.isEmpty {
                    if let id = self.teachersArray[indexPath.row].id {
                    
                        let searchTeachersUrl = self.baseURL + "api/v1/ruz/teachers/" + "\(id)/scheduler?date=\(self.selectedDate)"
                        
                        self.teacherId = id
                        
                        self.apiClient.getSchedule(url: searchTeachersUrl) { (lessons,error) in
                            if let lessonsThisWeek = lessons {
                                self.lessonsArray = lessonsThisWeek
                                print(self.lessonsArray)
                                self.uniqLessons = self.removeDuplicates()
                                self.tableViewDataReload()
                                SVProgressHUD.dismiss()
                                self.navigationItem.title = self.teachersArray[indexPath.row].full_name
                                self.searchRequestText = self.teachersArray[indexPath.row].full_name
                                if self.lessonsArray.isEmpty {
                                    self.alertShow(title: "Нет занятий на этой неделе")
                                }
                                self.arrayDataDelete()
                            }
                            if let err = error {
                                SVProgressHUD.dismiss()
                                self.tableViewDataReload()
                                print("Error: \(err)")
                                self.alertShow(title: "\(String(describing: err))")
                            }
                        }
                    }
                }
                
                if !self.groupsArray.isEmpty && !self.roomsArray.isEmpty {
                    if indexPath.section == 0 {
                        if let id = self.groupsArray[indexPath.row].id {
                        
                            let searchGroupUrl = self.baseURL + "api/v1/ruz/scheduler/" + "\(id)?date=\(self.selectedDate)"
                            
                            self.groupId = id
                            
                            self.apiClient.getSchedule(url: searchGroupUrl) { (lessons, error) in
                                if let lessonsThisWeek = lessons {
                                    self.lessonsArray = lessonsThisWeek
                                    self.uniqLessons = self.removeDuplicates()
                                    self.tableViewDataReload()
                                    SVProgressHUD.dismiss()
                                    self.navigationItem.title = self.groupsArray[indexPath.row].name
                                    self.searchRequestText = self.groupsArray[indexPath.row].name
                                    if self.lessonsArray.isEmpty {
                                        self.alertShow(title: "Don't have lessons this week")
                                    }
                                    self.arrayDataDelete()
                                }
                                if let err = error {
                                    SVProgressHUD.dismiss()
                                    self.tableViewDataReload()
                                    print("Error: \(err)")
                                    self.alertShow(title: "\(String(describing: err.localizedDescription))")
                                }
                            }
                        }
                    }
                    if indexPath.section == 1 {
                        if let roomId = self.roomsArray[indexPath.row].id {
                            if let buildingId = self.self.roomsArray[indexPath.row].building?.id {
                                let searchRoomUrl = self.baseURL + "api/v1/ruz/buildings/\(buildingId)/rooms/" + "\(roomId)/scheduler?date=\(self.selectedDate)"
                                
                                self.buildingId = buildingId
                                self.roomId = roomId
                                
                                self.apiClient.getSchedule(url: searchRoomUrl) { (lessons, error) in
                                    if let lessonsThisWeek = lessons {
                                        self.lessonsArray = lessonsThisWeek
                                        self.uniqLessons = self.removeDuplicates()
                                        self.tableViewDataReload()
                                        SVProgressHUD.dismiss()
                                        self.navigationItem.title = self.roomsArray[indexPath.row].name
                                        self.searchRequestText = self.roomsArray[indexPath.row].name
                                        if self.lessonsArray.isEmpty {
                                            self.alertShow(title: "Нет занятий на этой неделе")
                                        }
                                        self.arrayDataDelete()
                                    }
                                    if let err = error {
                                        SVProgressHUD.dismiss()
                                        self.tableViewDataReload()
                                        print("Error: \(err)")
                                        self.alertShow(title: "\(String(describing: err.localizedDescription))")
                                    }
                                }
                            }
                        }
                    }
                }
                if !self.groupsArray.isEmpty && self.roomsArray.isEmpty {
                    if indexPath.section == 0 {
                        if let id = self.groupsArray[indexPath.row].id {
                        
                            let searchGroupUrl = self.baseURL + "api/v1/ruz/scheduler/" + "\(id)?date=\(self.selectedDate)"
                            
                            self.groupId = id
                            
                            self.apiClient.getSchedule(url: searchGroupUrl) { (lessons, error) in
                                if let lessonsThisWeek = lessons {
                                    self.lessonsArray = lessonsThisWeek
                                    self.uniqLessons = self.removeDuplicates()
                                    self.tableViewDataReload()
                                    self.navigationItem.title = self.groupsArray[indexPath.row].name
                                    self.searchRequestText = self.groupsArray[indexPath.row].name
                                    SVProgressHUD.dismiss()
                                    if self.lessonsArray.isEmpty {
                                        self.alertShow(title: "Don't have lessons this week")
                                    }
                                    self.arrayDataDelete()
                                }
                                if let err = error {
                                    SVProgressHUD.dismiss()
                                    self.tableViewDataReload()
                                    print("Error: \(err)")
                                    self.alertShow(title: "\(String(describing: err.localizedDescription))")
                                }
                            }
                        }
                    }
                }
                if self.groupsArray.isEmpty && !self.roomsArray.isEmpty {
                    if indexPath.section == 0 {
                        
                        if let roomId = self.roomsArray[indexPath.row].id {
                            if let buildingId = self.self.roomsArray[indexPath.row].building?.id {
                                let searchRoomUrl = self.baseURL + "api/v1/ruz/buildings/\(buildingId)/rooms/" + "\(roomId)/scheduler?date=\(self.selectedDate)"
                                
                                self.buildingId = buildingId
                                self.roomId = roomId
                                
                                self.apiClient.getSchedule(url: searchRoomUrl) { (lessons, error) in
                                    if let lessonsThisWeek = lessons {
                                        
                                        self.lessonsArray = lessonsThisWeek
                                        self.uniqLessons = self.removeDuplicates()
                                        self.tableViewDataReload()
                                        SVProgressHUD.dismiss()
                                        self.navigationItem.title = self.roomsArray[indexPath.row].name
                                        self.searchRequestText = self.roomsArray[indexPath.row].name
                                        if self.lessonsArray.isEmpty {
                                            self.alertShow(title: "Don't have lessons this week")
                                        }
                                        self.arrayDataDelete()
                                    }
                                    if let err = error {
                                        SVProgressHUD.dismiss()
                                        self.tableViewDataReload()
                                        print("Error: \(err)")
                                        self.alertShow(title: "\(String(describing: err.localizedDescription))")
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    func tableViewDataReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func arrayDataDelete() {
        teachersArray = []
        groupsArray = []
        roomsArray = []
    }
    
    //MARK: - Function downloadNextWeek
    func downloadNewWeek() {
        
        self.tableViewDataReload()
        
        if teacherId != 0 {
            arrayDataDelete()
            SVProgressHUD.show()
            let searchTeachersUrl = self.baseURL + "api/v1/ruz/teachers/" + "\(teacherId)/scheduler?date=\(selectedDate)"
            self.apiClient.getSchedule(url: searchTeachersUrl) { (lessons, error) in
                if let lessonsThisWeek = lessons {
                    self.lessonsArray = lessonsThisWeek
                    print(self.lessonsArray)
                    self.uniqLessons = self.removeDuplicates()
                    self.tableViewDataReload()
                    SVProgressHUD.dismiss()
                    if self.lessonsArray.isEmpty {
                        self.alertShow(title: "Нет занятий на этой неделе")
                    }
                }
                if let err = error {
                    SVProgressHUD.dismiss()
                    self.tableViewDataReload()
                    self.alertShow(title: "\(String(describing: err.localizedDescription))")
                }
            }
        }
        
        if groupId != 0 {
            arrayDataDelete()
            SVProgressHUD.show()
            let searchGroupUrl = self.baseURL + "api/v1/ruz/scheduler/" + "\(groupId)?date=\(selectedDate)"
            print(searchGroupUrl)
            self.apiClient.getSchedule(url: searchGroupUrl) { (lessons, error) in
                if let lessonsThisWeek = lessons {
                    self.lessonsArray = lessonsThisWeek
                    print(self.lessonsArray)
                    self.uniqLessons = self.removeDuplicates()
                    self.tableViewDataReload()
                    SVProgressHUD.dismiss()
                    if self.lessonsArray.isEmpty {
                        self.alertShow(title: "Нет занятий на этой неделе")
                    }
                }
                if let err = error {
                    SVProgressHUD.dismiss()
                    self.tableViewDataReload()
                    self.alertShow(title: "\(String(describing: err.localizedDescription))")
                }
            }
        }
        if roomId != 0 && buildingId != 0 {
            arrayDataDelete()
            SVProgressHUD.show()
            let searchGroupUrl = self.baseURL + "api/v1/ruz/scheduler/" + "\(groupId)?date=\(selectedDate)"
            self.apiClient.getSchedule(url: searchGroupUrl) { (lessons, error) in
                if let lessonsThisWeek = lessons {
                    self.lessonsArray = lessonsThisWeek
                    print(self.lessonsArray)
                    self.uniqLessons = self.removeDuplicates()
                    self.tableViewDataReload()
                    SVProgressHUD.dismiss()
                    if self.lessonsArray.isEmpty {
                        self.alertShow(title: "Нет занятий на этой неделе")
                    }
                }
                if let err = error {
                    SVProgressHUD.dismiss()
                    self.tableViewDataReload()
                    self.alertShow(title: "\(String(describing: err.localizedDescription))")
                }
            }
        }
    }
    
    //MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if lessonsArray.isEmpty {
            if indexPath.section == 0 && !groupsArray.isEmpty {
                return 50
            } else {
                return 80
            }
        } else if filteredArray.isEmpty && teachersArray.isEmpty && groupsArray.isEmpty && roomsArray.isEmpty {
            return 80
        }
        return 130
    }
    
    // section view setup func
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !teachersArray.isEmpty || !groupsArray.isEmpty || !roomsArray.isEmpty {
            if lessonsArray.isEmpty {
                return 35
            }
        }
        tableView.backgroundColor = UIColor.white
        return 0
    }
}
