//
//  ApplicationMineModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class ApplicationMineModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
    /// 单据编号
    var TID:String? = ""
    /// 单据名称
    var DJNAME:String? = ""
    /// 制单时间  ,
    var BDATE:String? = ""
    /// 工作流状态  ,
    var GZLSTATE:String? = ""
    
}
