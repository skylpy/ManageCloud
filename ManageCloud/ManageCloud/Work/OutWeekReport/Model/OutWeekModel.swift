//
//  OutWeekModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class OutWeekModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
    /// 科目编号
    var KMTID:String? = ""
    ///  科目名称 ,
    var KMNAME:String? = ""
    ///  金额  ,
    var AMOUNT:String? = ""
    ///  支出次数
    var NUMS:String? = ""
    
}

class OutWeekTotalEntiesModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
    /// 支出合计
    var ZCTOTAL:String? = ""
    
}
