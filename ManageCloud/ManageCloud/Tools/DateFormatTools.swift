//
//  DateFormatTools.swift
//  YXCloud
//
//  Created by dehui chen on 2018/4/23.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class DateFormatTools {
    static let dateTool = DateFormatTools()

    static var instance:DateFormatTools = {
        
        return DateFormatTools()
    }()
    //MARK:获得当前 (年)-（月） 格式为：2018-04
      func getYearMonth() -> String {
       
        let date:Date = Date()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        return strNowTime
    }
    //MARK:获得当前 (年)-（月） 格式为：2018年04月
    func getUIYearMonth() -> String {
        
        let date:Date = Date()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy年MM月"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        return strNowTime
    }
    
    //2018
    func getYear() -> String {
        
        let date:Date = Date()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        return strNowTime
    }
    
    //04
    func getMonth() -> String {
        
        let date:Date = Date()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "MM"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        return strNowTime
    }
    
    /// 获取当前时间 年/月/日
    func getNowYearMonthDay() -> String {
        
        let date:Date = Date()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy/MM/dd"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        return strNowTime
    }
    
    
    /// 获取当前时间 年-月-日
    func getNowYearMonthDay2() -> String {
        
        let date:Date = Date()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM-dd"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        return strNowTime
    }
    
    

    /// 获取当前时间的前几天
    ///
    /// - Parameter count: 天数
    /// - Returns: 新的时间字符串"yyyy-MM-dd"
    func getCurrentDateWithSubDay(count:Int) -> String {
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let newDate = Date.init(timeInterval: TimeInterval(-count * 24 * 60 * 60), since: date)
        
        let str = formatter.string(from: newDate)
        return str
    }
}
