//
//  SignDatePicker.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Alamofire

class SignDatePicker: UIView, JTAppleCalendarViewDataSource,JTAppleCalendarViewDelegate {
    
    

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var selectedDate: Date!
    
    var selectedBlock: ((Date)->())!
    
    let formatter = DateFormatter()
    var testCalendar = Calendar.current
    var numberOfRows = 4
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    var hasStrictBoundaries = true
    let firstDayOfWeek: DaysOfWeek = .monday
    var monthSize: MonthSize? = MonthSize(defaultSize: 50, months: [75: [.feb, .apr]])
    var cancelBlock: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.sectionInset  = UIEdgeInsetsMake(10, 20, 10, 20)
        //*********************貌似这个属性要在xib点才会scrollToDate的时候不出现偏移差
        calendarView.isPagingEnabled = true
        calendarView.minimumLineSpacing = 0.1
        calendarView.minimumInteritemSpacing = 0.1
//        calendarView.cellSize = 34 + 20
        calendarView.register(UINib.init(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
             self.setupViewsOfCalendar(from: visibleDates)
        }
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        let selectedDateString = formatter.string(from: Date())
        selectedDate = formatter.date(from: "2018 05 29")
        initDate()
    }
    
    //选择传进来的date
    func initDate(){
        calendarView.scrollToDate(selectedDate, animateScroll: false, preferredScrollPosition: .left)
        calendarView.selectDates([selectedDate])
    }
    
    public func DispatchAfter(after: Double, handler:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            handler()
        }
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        cancelBlock!()
    }
    @IBAction func finish(_ sender: UIButton) {
        selectedBlock(selectedDate)
        cancelBlock!()
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = testCalendar.component(.year, from: startDate)
        monthLabel.text =  String(year) + "年" + String(month) + "月"
    }
    
    @IBAction func previous(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func next(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
    
    
    
    // MARK: - JTAppleCalendarViewDelegate
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        
        let startDate = formatter.date(from: "2000 01 01")!
        let endDate = formatter.date(from: "2099 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: testCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! DateCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
        selectedDate = date
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    
    
    
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let stride = calendarView.frame.width * CGFloat(indexPath.section)
        return CGRect(x: stride + 5, y: 5, width: calendarView.frame.width - 10, height: calendarView.frame.height - 10)
    }
    
//    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
//        return monthSize
//    }
    
    
    
    func configureVisibleCell(myCustomCell: DateCell, cellState: CellState, date: Date) {
        myCustomCell.dayLabel.text = cellState.text
        //是不是今天
//        if testCalendar.isDateInToday(date) {
//            myCustomCell.backgroundColor = UIColor.red
//        } else {
//            myCustomCell.backgroundColor = UIColor.white
//        }
        
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
        
        //月份label
//        if cellState.text == "1" {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMM"
//            let month = formatter.string(from: date)
//            myCustomCell.monthLabel.text = "\(month) \(cellState.text)"
//        } else {
//            myCustomCell.monthLabel.text = ""
//        }
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? DateCell else {return }
        //        switch cellState.selectedPosition() {
        //        case .full:
        //            myCustomCell.backgroundColor = .green
        //        case .left:
        //            myCustomCell.backgroundColor = .yellow
        //        case .right:
        //            myCustomCell.backgroundColor = .red
        //        case .middle:
        //            myCustomCell.backgroundColor = .blue
        //        case .none:
        //            myCustomCell.backgroundColor = nil
        //        }
        //
        if cellState.isSelected{
            myCustomCell.selectedView.backgroundColor = COLOR(red: 126, green: 213, blue: 256)
            myCustomCell.selectedView.layer.cornerRadius =  17
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.backgroundColor = UIColor.white
            myCustomCell.selectedView.isHidden = true
        }
    }
    let DateGray: UIColor = COLOR(red: 109, green: 109, blue: 114)
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? DateCell  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = DateGray
            } else {
                myCustomCell.dayLabel.textColor = COLOR(red: 203, green: 203, blue: 206)
            }
        }
    }
    
    

}
