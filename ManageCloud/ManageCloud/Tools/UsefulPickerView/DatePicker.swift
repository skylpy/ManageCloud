//
//  DatePicker.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

enum DatePickerType {
    case Year
    case YearMonth
}

class DatePickerTool {
    
    typealias MultipleDoneAction = (_ selectedIndexs: [Int], _ selectedValues: [String]) -> Void
    
    var selectedIndexs: [Int] = [0]
    
    //数据源
    var yearArr: [String] = []
    var monthArr: [String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    
    //seletedString 格式一定要以-间隔 如 2016-12-12 12:23:33
    convenience init(pickType type: DatePickerType, seletedString: String, minDateString: String? = "1900", maxDateString: String? = "2100", doneAction: MultipleDoneAction?) {
        self.init()
        if type == .Year {
            let maxYear = maxDateString?.intValue
            var minYear = minDateString?.intValue
            
            while(minYear! <= maxYear!){
                let yearString = String(minYear!)
                if yearString == seletedString{
                    selectedIndexs = [yearArr.count]
                }
                yearArr.append(yearString)
                minYear! += 1
            }
            
            UsefulPickerView.showMultipleColsPicker("请选择年份", data: [yearArr], defaultSelectedIndexs: selectedIndexs, doneAction: doneAction)
        }
        else if type == .YearMonth{
            
            
            let maxYear = maxDateString?.intValue
            var minYear = minDateString?.intValue
            
            let seletedYear = seletedString.components(separatedBy: "-").first!
            var seletedMonth = seletedString.components(separatedBy: "-").last!
            if seletedMonth.hasPrefix("0"){
                seletedMonth = seletedMonth.substring(from: 1)
            }
            var seletedYearIndex = 0
            while(minYear! <= maxYear!){
                let yearString = String(minYear!)
                if yearString == seletedYear{
                    seletedYearIndex = yearArr.count
                }
                yearArr.append(yearString)
                minYear! += 1
            }
            
            var selectedMonthIndex = 0
            for (index, month) in monthArr.enumerated(){
                if month == seletedMonth{
                    selectedMonthIndex = index
                }
            }
            
            
            UsefulPickerView.showMultipleColsPicker("请选择年月", data: [yearArr, monthArr], defaultSelectedIndexs: [seletedYearIndex, selectedMonthIndex], doneAction: doneAction)
        }
        
    }

}
