//
//  DailyReporTotalModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/20.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class DailyReporTotalModel:NSObject,HandyJSON {
    
    required override init() {
        
    }
    /// 收入合计
    var SRTOTAL:String? = ""
    ///  支出合计
    var ZCTOTAL:String? = ""
    
}
