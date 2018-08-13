//
//  ApplicationModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class ApplicationModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
    /// 单据编号
    var TID:String? = ""
    /// 单据名称
    var DJNAME:String? = ""
    /// 制单人名称  ,
    var EINAME:String? = ""
    /// 制单时间  ,
    var BDATE:String? = ""
    /// 审批更新时间  ,
    var UPTIMESET:String? = ""
    /// 审批流程编号 , ,
    var BPFTID:String? = ""
    /// 表单类型编号 ,
    var CRTID:String? = ""
    /// 我的审批(审批状态)
    var FJTYPE:String? = ""
    
    
}
