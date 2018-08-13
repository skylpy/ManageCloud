//
//  MyEmailModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

/// 邮件ViewModel
class MailModel: NSObject,HandyJSON {

    required override init() {
        
    }
    //SHOU、CHAO、BLACK 格式用户管理员(2),测试人员(3),
    
    /// 邮件编号
    var TID:String? = ""
    /// 邮件读取标志 0未读，1已读 ,
    var READ:String? = ""
    /// 邮件名称 ,
    var SUBJECT:String? = ""
    /// 发送人员编号 ,
    var FROM:String? = ""
    /// 发送人员 ,
    var FromName:String? = ""
    /// 接受人员编号
    var TO:String? = ""
    /// 接受人员
    var ToName:String? = ""
    /// 收件人编号序列 ,
    var SHOU:String? = ""
    /// 发送时间
    var SENT:String? = ""
    /// 邮件内容 （不是html了）
    var MCONTENT:String? = ""
    /// 附件信息列表
    var Attachments:[AttachmentInfo]? = nil
    /// 回复邮件信息
    //var ReplyMail:[MailModel]? = nil
    
}

/// 邮件附件Model
class AttachmentInfo: NSObject,HandyJSON {
    
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
    ///  文件大小
    var FileLen:String? = ""
    
    ///  上传专用(本地有服务器不会有这个字段)
   // var FileLen2:CDouble? = ""
    
    /// 附件
   // var attachment:[AttachmentInfo]? = nil
   
}
class MyEmailModel: NSObject,HandyJSON {
    
    required override init() {
        
    }
    
   /// 邮件
   // var mail:[MailModel]? = nil
    // 邮件编号
    var TID:String? = ""
    /// 邮件读取标志 0未读，1已读 ,
    var READ:String? = ""
    /// 邮件名称 ,
    var SUBJECT:String? = ""
    /// 发送人员编号 ,
    var FROM:String? = ""
    /// 发送人员 ,
    var FromName:String? = ""
    /// 接受人员编号
    var TO:String? = ""
    /// 接受人员
    var ToName:String? = ""
    /// 收件人编号序列 ,
    var SHOU:String? = ""
    /// 发送时间
    var SENT:String? = ""
    /// 邮件内容 （不是html了）
    var MCONTENT:String? = ""
    /// 是否是回复邮件
    var IsReply:Bool? = false
    /// 要回复的邮件编号 如果存在回复邮件，则放入被回复邮件单据编号（即TID）
    var P_TID:String? = ""
    /// 附件信息列表
    var Attachments:[AttachmentInfo]? = nil
    /// 回复邮件信息
    var ReplyMail:[MailModel]? = nil

}

//签到附件model
class SignAttachmentInfo: NSObject,HandyJSON {
    
    required override init() {
        
    }
    /// 签到附件编号
    var TID:String? = ""
    /// 签到表编号
    var MTID:String? = ""
    /// 签到显示文件名
    var FILENAME:String? = ""
    /// 签到文件名
    var GFileName:String? = ""
    /// 文件路径
    var URL:String? = ""
    
}
