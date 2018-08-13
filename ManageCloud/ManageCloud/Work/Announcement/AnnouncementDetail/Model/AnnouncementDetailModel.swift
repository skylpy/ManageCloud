//
//  AnnouncementDetailModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class AnnouncementDetailModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
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
