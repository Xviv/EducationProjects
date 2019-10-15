//
//  smallCalendarDataSource.swift
//  PolyStudents
//
//  Created by Dan on 21/04/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit
import JTAppleCalendar

//MARK - Collection view controller dataSource

extension ScheduleTableViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        self.formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2028 01 01")!
        let numberOfRows = 1
        let firstDayOfAWeek:DaysOfWeek = .monday
        calendar.scrollingMode = .stopAtEachSection
        calendar.scrollDirection = .horizontal
        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows, firstDayOfWeek: firstDayOfAWeek)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.formatter.dateFormat = "yyyy-MM-dd"
        self.formatter.locale = Calendar.current.locale
        self.formatter.timeZone = Calendar.current.timeZone
        selectedDate = formatter.string(from: date)
        
        self.handleCellSelected(cell: cell, cellState: cellState)
        dataSource.callFromOtherClass()
        
        if !lessonsArray.isEmpty {
            let uniqArray = removeDuplicates()
            filterArray(uniqArray, selectedDate: selectedDate)
            self.tableView.reloadData()
        }
        
        self.selectedDateOfTypeDate = date
        self.setMonthLabel(date: date)
        
        calendar.reloadData()
        expandableCalendarCollectionView.reloadData()
        expandableCalendarCollectionView.scrollToDate(self.selectedDateOfTypeDate, animateScroll: false)
    }
}
//MARK: Collection view Delegate
extension ScheduleTableViewController: JTAppleCalendarViewDelegate, UIScrollViewDelegate {
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        self.formatter.dateFormat = "yyyy-MM-dd"
        print(calendar.contentOffset.x)
        print(lastContentOffset)
        
        if scrollDirection == .right {
            nextWeekData(for: calendar, forDays: 7)
        } else {
            nextWeekData(for: calendar, forDays: -7)
        }
    }
    
    func nextWeekData(for calendar: JTAppleCalendarView,forDays dayValue: Int) {
        selectedDateOfTypeDate = Calendar.current.date(byAdding: .day, value: dayValue, to: selectedDateOfTypeDate)!
        selectedDate = formatter.string(from: selectedDateOfTypeDate)
        dataSource.callFromOtherClass()
        
        self.cancelAllRequests {
            self.downloadNewWeek()
            
            self.expandableCalendarCollectionView.scrollToDate(self.selectedDateOfTypeDate, animateScroll: false)
            DispatchQueue.main.async {
                self.setMonthLabel(date: self.selectedDateOfTypeDate)
                calendar.reloadData()
                self.expandableCalendarCollectionView.reloadData()
                calendar.scrollToDate(self.selectedDateOfTypeDate, animateScroll: true)
            }
        }
    }
    
    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        if lastContentOffset < calendar.contentOffset.x {
            scrollDirection = .right
        } else if lastContentOffset > calendar.contentOffset.x {
            scrollDirection = .left
        }

        lastContentOffset = calendar.contentOffset.x
    }
    
    func setMonthLabel(date: Date) {
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ru_RU")
        monthFormatter.dateFormat = "LLLL"
        let month = monthFormatter.string(from: date).capitalizingFirstLetter()
        self.monthLabel.text = month
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        let calendarDate = formatter.string(from: cellState.date)
        
        cell.dateLabel.text = cellState.text

        if calendarDate ==  selectedDate {
            DispatchQueue.main.async {
                cell.isSelected = true
                self.handleCellSelected(cell: cell, cellState: cellState)
            }
        } else {
            cell.isSelected = false
            self.handleCellSelected(cell: cell, cellState: cellState)
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! DateCell
        
        cell.dateLabel.text = cellState.text
    }
    
}
