//
//  PersonInfoModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class PersonInfoModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    /// 照片
    var Photo:String? = ""
    /// 人员名
    var Name:String? = ""
    /// 人员部门ID
    var DepID:String? = ""
    /// 人员部门名称
    var DepName:String? = ""
    /// 人员简介
    var Descr:String? = ""
 
}
