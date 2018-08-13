//
//  PostEmailModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/17.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON



class PostEmailModel: NSObject,HandyJSON{
    
    required override init() {
        
    }
    //SHOU、CHAO、BLACK 格式用户管理员(2),测试人员(3),
    
    /// 邮件编号
    var TID:String? = ""
    /// Txt主题 邮件名称
    var SUBJECT:String? = ""
    /// 发送人 ,
    var FROM:String? = ""
    /// 收件人列表 ,
    var SHOU:String? = ""
    /// 邮件内容 ,
    var MCONTENT:String? = ""
    /// 是否回复邮件
    var IsReply:Bool? = false
    /// 要回复的邮件编号 如果存在回复邮件，则放入被回复邮件单据编号（即TID）
    var P_TID:String? = ""
    
    /// 附件信息列表
    var ATTACHMENT:[AttachmentInfo]? = nil
    
}
