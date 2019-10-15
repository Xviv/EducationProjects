//
//  ExpandableCalendarDataSource.swift
//
//
//  Created by Dan on 20/04/2019.
//

import UIKit
import JTAppleCalendar

protocol selectedDateDelegate {
    func selectTheDate() -> String
}

class ExpandableCalendarDataSource: NSObject, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    private let todayDate = Date()
    private let formatter = DateFormatter()
    var selectedDate = ""
    var selectedDateOfTypeDate = Date()
    var delegate: selectedDateDelegate?
    private let selectedDateColor = #colorLiteral(red: 0.1921568627, green: 0.6078431373, blue: 0.2392156863, alpha: 1)
    var month: String = ""
    
    func callFromOtherClass() {
        selectedDate = (self.delegate?.selectTheDate())!
    }
    
    private func postSelectedDate() {
        NotificationCenter.default.post(name: .saveSelectedDate, object: self)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        self.formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2028 01 01")!
        let numberOfRows = 6
        let firstDayOfAWeek:DaysOfWeek = .monday
        calendar.scrollingMode = .stopAtEachCalendarFrame
        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows, firstDayOfWeek: firstDayOfAWeek)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! expandableCalendarDateCell
        
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        month = formatter.string(from: range.start)
        header.monthTitle.text = month.capitalizingFirstLetter()
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! expandableCalendarDateCell
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        self.formatter.locale = Calendar.current.locale
        self.formatter.timeZone = Calendar.current.timeZone
        let calendarDate = formatter.string(from: cellState.date)
        let currentDate = formatter.string(from: todayDate)
        
        cell.dateLabel.text = cellState.text
        configureCell(view: cell, cellState: cellState)
        
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
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.formatter.dateFormat = "yyyy-MM-dd"
        self.formatter.locale = Calendar.current.locale
        self.formatter.timeZone = Calendar.current.timeZone
        selectedDate = formatter.string(from: date)
        selectedDateOfTypeDate = date
        
        self.handleCellSelected(cell: cell, cellState: cellState)
        postSelectedDate()
        calendar.reloadData()
        
    }
    
    //MARK: - Handlers
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? expandableCalendarDateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: expandableCalendarDateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
    }
    
    
    private func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? expandableCalendarDateCell else { return }
        
        if validCell.isSelected {
            DispatchQueue.main.async {
                validCell.selectedCellView.backgroundColor = self.selectedDateColor
                validCell.dateLabel.textColor = UIColor.white
            }
        } else {
            DispatchQueue.main.async {
                validCell.selectedCellView.backgroundColor = UIColor.clear
                validCell.dateLabel.textColor = UIColor.black
            }
        }
    }
    
}

