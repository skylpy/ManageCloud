//
//  DailyReportModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/19.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class DailyReportModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
    /// 账户
    var ZHNAME:String? = ""
    ///  所属公司 ,
    var DNAME:String? = ""
    ///  到账日期  ,
    var DZDATE:String? = ""
    ///  摘要  ,
    var DESCR:String? = ""
    /// 类型   ,
    var MONEYTYPE:String? = ""
    /// 科目名称 ,
    var KEMUNAME:String? = ""
    /// 收入 ,
    var SRAMOUNT:String? = ""
    /// 支出
    var ZCAMOUNT:String? = ""
    /// 结余 ,
    var SURPLUS:String? = ""
    /// 制单日期
    var BDATE:String? = ""
    
}
