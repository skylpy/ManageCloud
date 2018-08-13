//
//  SignListModel.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class SignListModel: NSObject, HandyJSON {
    //地址
    var Address: String? = ""
    //签到时间
    var Bdate: String? = ""
    //地址
    var content: String? = ""
    //维度
    var lat: String? = ""
    //经度
    var lng: String? = ""
    //附件信息
    var thecontent: [SignAttachmentInfo]? = nil
    //序号
    var tid: String? = ""

    required override init() {}
}


class SignPersonListModel: NSObject, HandyJSON {
    //人员编号
    var oid: String? = ""
    //账户名称
    var TTID: String? = ""
    //人员名
    var Name: String? = ""
    //当日签到次数
    var num: String? = ""
    //头像
    var Photo: String? = ""
    //性别
    var Sex: String? = ""
    
    required override init() {}
}


