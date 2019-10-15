//
//  RecordBookViewController.swift
//  PolyStudents
//
//  Created by Dan on 26/11/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class RecordBookTableController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var marks: RecordBook?
    var marksArray: [Marks] = []
    var semesters: [Marks] = []
    var selectedSem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        if let marks = marks?.data.marks {
            marksArray = marks
            semesters = unique(marks: marksArray)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RecordBookLessonCell", bundle: nil), forCellReuseIdentifier: "recordBookLessonCell")
    }
    
    func unique(marks: [Marks]) -> [Marks] {
        
        var uniqueSemesters = [Marks]()
        
        for semester in marks {
            if !uniqueSemesters.contains(semester) {
                uniqueSemesters.append(semester)
            }
        }
        let sorted = uniqueSemesters.sorted { $0.semester! < $1.semester! }
        
        return sorted
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            if self.selectedSem != 0 {
                selectedSem -= 1
                let i = IndexPath(item: selectedSem, section: 0)
                print("Swipe Right")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    let range = NSMakeRange(0, self.tableView.numberOfSections)
                    let sections = NSIndexSet(indexesIn: range)
                    self.tableView.reloadSections(sections as IndexSet, with: .automatic)

                    self.collectionView.scrollToItem(at: i, at: .right, animated: true)
                }
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            if selectedSem + 1 < semesters.count {
                print("Swipe Left")
                selectedSem += 1
                let i = IndexPath(item: selectedSem, section: 0)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    let range = NSMakeRange(0, self.tableView.numberOfSections)
                    let sections = NSIndexSet(indexesIn: range)
                    self.tableView.reloadSections(sections as IndexSet, with: .automatic)

                    self.collectionView.scrollToItem(at: i, at: .right, animated: true)
                }
            }
        }
    }
}

    //MARK: - TableView

extension RecordBookTableController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if marksArray.isEmpty {
            return 1
        } else {
            return numberOfSemesters(section: selectedSem)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordBookLessonCell", for: indexPath) as! RecordBookLessonCell
        
        cellSetup(indexPath: indexPath, cell: cell)
        
        return cell
    }
    
    func numberOfSemesters(section: Int) -> Int {
        let filteredArray = marksArray.filter({$0.semester == semesters[section].semester})
        
        return filteredArray.count
    }
    
    
    func cellSetup(indexPath: IndexPath, cell: RecordBookLessonCell) {
        if marks != nil {
            let filteredArray = marksArray.filter({$0.semester == semesters[selectedSem].semester})
            
            if !marksArray.isEmpty {
                let mark = filteredArray[indexPath.row]
                cell.lessonNameLabel.text = mark.subject
                cell.lessonMarkLabel.text = mark.mark_value?.title
                cell.teacherName.text = mark.lecturers
                cell.typeObj.text = mark.control_type
                cell.noDataLabel.text = ""
                
                DispatchQueue.main .async {
                    switch mark.mark_value?.title {
                    case "отлично":
                        cell.markBGView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0, alpha: 1)
                    case "зачет":
                        cell.markBGView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0, alpha: 1)
                    case "хорошо":
                        cell.markBGView.backgroundColor = #colorLiteral(red: 0, green: 0.5450980392, blue: 0.5960784314, alpha: 1)
                    case "удовлетворительно":
                        cell.markBGView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                        cell.lessonMarkLabel.text = "удовл."
                    case "неявка":
                        cell.markBGView.backgroundColor = #colorLiteral(red: 0.8352941176, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
                    default:
                        cell.markBGView.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
                    }
                }
            } else {
                cell.lessonNameLabel.text = ""
                cell.lessonMarkLabel.text = ""
                cell.teacherName.text = ""
                cell.typeObj.text = ""
                cell.markBGView.backgroundColor = .clear
                cell.noDataLabel.text = "Нет данных"
            }
        }
    }
    
    //MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//MARK: - CollectonView

extension RecordBookTableController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return semesters.count
//        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "semesterCell", for: indexPath) as! SemesterCollectionCell
        cell.semesterNumber.text = String(semesters[indexPath.row].semester!)
        if indexPath.row == selectedSem {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
//        cell.semesterNumber.text = "10"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSem = indexPath.row
        print(selectedSem)
        DispatchQueue.main.async {
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)

            collectionView.reloadData()
//            self.tableView.reloadData()
            self.tableView.setContentOffset(.zero, animated: false)
        }
    }
}
