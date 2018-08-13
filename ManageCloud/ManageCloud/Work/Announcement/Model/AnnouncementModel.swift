//
//  AnnouncementModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class AnnouncementModel: NSObject,HandyJSON {

    required override init() {
        
    }
    //SHOU、CHAO、BLACK 格式用户管理员(2),测试人员(3),
    
    /// 公告头
    var _subject:String? = ""
    /// 人员名称
    var _person:String? = ""
    /// 日期
    var _bdate:String? = ""
    /// 公告编号
    var Tid:String? = ""
    /// 公告内容,
    var wContent:String? = ""
    /// 公告已读人数
    var ReadCount:String? = ""
    /// 附件列表
    var thecontent:[AttachmentModel]? = nil

}

/// 附件
class AttachmentModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    /// 附件序号
    var OID:String? = ""
    ///  附件来源编号,写入附件时请填写添加附件表名称，如'D_GONGGAO' ,
    var WFTID:String? = ""
    /// 附件名称 ,
    var FileName:String? = ""
    /// 附件前台显示名
    var DisplayName:String? = ""
    /// 是否被删除  ,
    var IsDelete:String? = ""
    ///  附件地址
    var URL:String? = ""
    /// 文件大小
    var FileLen:String = ""
    
    
}


