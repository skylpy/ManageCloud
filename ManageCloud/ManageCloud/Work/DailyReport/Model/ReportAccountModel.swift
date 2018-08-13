//
//  ReportAccountModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/19.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class ReportAccountModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    ///  账户编号
    var ZHTID:String? = ""
    ///  账户名称,
    var ZHNAME:String? = ""
    
}

class ReportAccountListModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    ///  账户名
    var ZHNAME:String? = ""
    ///  所属公司名
    var DNAME:String? = ""
    /// 账户余额
    var ZHBALANCE:String? = ""

}

