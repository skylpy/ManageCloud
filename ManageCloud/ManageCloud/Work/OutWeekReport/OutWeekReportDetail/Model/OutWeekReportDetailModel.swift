//
//  OutWeekReportDetailModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class OutWeekReportDetailModel: NSObject ,HandyJSON {
    
    required override init() {
        
    }
    
    /// 账户
    var ZHNAME:String? = ""
    ///  所属公司 ,
    var DNAME:String? = ""
    ///  支出日期  ,
    var DZDATE:String? = ""
    ///  供应商 ,
    var GYSNAME:String? = ""
    /// 产品编号   ,
    var MTID:String? = ""
    /// 产品名称 ,
    var MNAME:String? = ""
    /// 科目
    var KMNAME:String? = ""
    ///  数量
    var QUANTITY:String? = ""
    ///  金额 ,
    var AMOUNT:String? = ""
    /// 备注
    var DESCR:String? = ""
    ///  制单人
    var EINAME:String? = ""
    ///  制单部门 ,
    var ZDNAME:String? = ""
    /// 制单日期
    var BDATE:String? = ""
    
}


/// 支出合计Model 用 InWeelReporTotalModel

