//
//  WeekReportModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/20.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class WeekReportModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
    /// 账户
    var ZHNAME:String? = ""
    ///  所属公司 ,
    var DNAME:String? = ""
    ///  日期  ,
    var DZDATE:String? = ""
    ///  付款单位  ,
    var FKDW:String? = ""
    /// 业务员  ,
    var YWYNAME:String? = ""
    /// 产品名称,
    var MNAME:String? = ""
    /// 数量
    var QUANTITY:String? = ""
    /// 金额
    var AMOUNT:String? = ""
    /// 备注
    var DESCR:String? = ""
    
    
}

/// 查询收入周报合计Modl
class InWeelReporTotalModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
    /// 数量合计
    var SLTOTAL:String? = ""
    ///  金额合计
    var JETOTAL:String? = ""
    
}
