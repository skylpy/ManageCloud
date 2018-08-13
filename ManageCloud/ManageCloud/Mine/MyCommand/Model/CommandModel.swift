//
//  CommandModel.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class AddCommandModel: NSObject, HandyJSON {
    //指挥序号
    var pk_id:String? = ""
    //发送人编号
    var userid:String? = ""
    //发送人
    var Name:String? = ""
    //指挥信息标题
    var perform_title:String? = ""
    //指挥信息内容
    var perform_content:String? = ""
    //接受人
    var accepts:String? = ""
    //生效时间
    var end_time:String? = ""
    //发送时间
    var bdate_time:String? = ""
    //紧急程度:不紧急不重要\紧急不重要\重要并紧急\重要不紧急
    var state:String? = ""
    //回复数\已读数。isReply=是，回复数;isReply=否,已读数
    var num:String? = ""
    //指挥类型：是：需回复\否：仅通知
    var isReply:String? = ""
    
    required override init() {}
}

class CommandDateilModel: NSObject,HandyJSON {
    
    var pk_id:String? = ""
    //下达人员照片
    var Photo:String? = ""
    //下达人员名
    var Name:String? = ""
    //指挥回复信息列表
    var Reply:[ReplyModel]? = []
    //发送人编号
    var userid:String? = ""
    //执行人
    var accepts:String? = ""
    //紧急程度
    var state:String? = ""
    //性别
    var Sex:String? = ""
    //标题
    var perform_title:String? = ""
    //内容
    var perform_content:String? = ""
    //指挥类型
    var isReply:String? = ""
    //下达人员名
    var end_time:String? = ""
    //回复时间
    var bdate_time:String? = ""
    
    var perform_titleHeight:CGFloat? = 0
    var perform_titlecellHeight:CGFloat? = 0
    var perform_contentHeight:CGFloat? = 0
    var perform_contentcellHeight:CGFloat? = 0
    required override init() {}
}

class ReplyModel: NSObject,HandyJSON {
    
    //指挥回复信息序号
    var pk_id:String? = ""
    //指挥序号
    var cpid:String? = ""
    //指挥回复人员编号
    var userid:String? = ""
    //指挥回复人员
    var Name:String? = ""
    //指挥回复内容
    var replycontent:String? = ""
    //回复时间
    var bdate_time:String? = ""
    //已回复\已读
    var isread:String? = ""
    
    var textHeight:CGFloat? = 0
    var cellHeight:CGFloat? = 0
    required override init() {}
}


class CommandModel: NSObject {
    
    //添加指挥
    class func addCommantRequest(pk_id:NSInteger,userid:String,accepts:String,state:String,perform_title:String,perform_content:String,isReply:String,end_time:String,successBlock:@escaping (_ r_id:String) -> (),failBlock:@escaping(_ result:ResObject) -> ()) {
        
        var parm = paramDic()
        parm.updateValue((pk_id), forKey: "pk_id")
        parm.updateValue(userid, forKey: "userid")
        parm.updateValue(accepts, forKey: "accepts")
        parm.updateValue(state, forKey: "state")
        parm.updateValue(perform_title, forKey: "perform_title")
        parm.updateValue(perform_content, forKey: "perform_content")
        parm.updateValue(isReply, forKey: "isReply")
        parm.updateValue(end_time, forKey: "end_time")
        
        NetTool.request(type: .POST, urlSuffix: SubmitCommand, paramters: parm, successBlock: { (model) in
            
            guard let commandList = model.results as? NSArray else {return}
            successBlock((commandList[0] as! NSNumber).stringValue)
            
        }) { (error) in
            failBlock(error)
        }
    }
    
    //我发送的指挥列表
    class func sendCommantListRequest(EIOID:String, successBlock:@escaping (_ list:[AddCommandModel]) -> (),failBlock:@escaping(_ result:ResObject) -> ()) -> () {
        
        NetTool.reqBody(urlstr: GetSendCommandList, strTID: EIOID, successBlock: { (model) in
            
            guard let commandList = model.results as? NSArray else {return}
            
            if let commandModelList = [AddCommandModel].deserialize(from: commandList)  {
                
                successBlock(commandModelList as! [AddCommandModel])
            }
            
        }) { (error) in
            failBlock(error)
        }
    }
    
    //我接收的指挥列表
    class func receiveCommantListRequest(OID:String, successBlock:@escaping ( _ list:[AddCommandModel]?) -> (),failBlock:@escaping(_ result:ResObject) -> ()) -> () {
        
        NetTool.reqBody(urlstr: GetReceiveCommandList, strTID: OID, successBlock: { (model) in
            
            guard let commandList = model.results as? NSArray else {return successBlock(nil)}
            
            if let commandModelList = [AddCommandModel].deserialize(from: commandList)  {
                
                successBlock(commandModelList as! [AddCommandModel])
            }
            
        }) { (error) in
            failBlock(error)
        }
    }
    
    
    //获取本人最近接受的3条指挥信息
    class func receiveTop3CommantListRequest(OID:String, successBlock:@escaping ( _ list:[AddCommandModel]?) -> (),failBlock:@escaping(_ result:ResObject) -> ()) -> () {
        
        NetTool.reqBody(urlstr: GetReceiveTop3CommandList, strTID: OID, successBlock: { (model) in
            
            guard let commandList = model.results as? NSArray else {return successBlock(nil)}
            
            if let commandModelList = [AddCommandModel].deserialize(from: commandList)  {
                
                successBlock(commandModelList as? [AddCommandModel])
            }
            
        }) { (error) in
            failBlock(error)
        }
    }
    
    
    
    //新指挥详情
    class func commantDateilsRequest(TID:String,userId:String,successBlock:@escaping (_ amodel:[CommandDateilModel]) -> (),failBlock:@escaping(_ result:ResObject) -> ()) -> () {
        
        var parm = paramDic()
        parm.updateValue(TID, forKey: "TID")
        parm.updateValue(userId, forKey: "userid")
        
        NetTool.request(type: .POST, urlSuffix: GetCommand, paramters: parm, successBlock: { (model) in
            
            guard let commandList = model.results as? NSArray else {return}
            if let smodell = [CommandDateilModel].deserialize(from:  commandList) {
                let cmodel:CommandDateilModel = smodell[0]!
                
                cmodel.perform_titleHeight = CGFloat.countcustTextHeight(text: cmodel.perform_title!, width: 100)
                cmodel.perform_titlecellHeight = cmodel.perform_titleHeight!+10
                
                cmodel.perform_contentHeight = CGFloat.countcustTextHeight(text: cmodel.perform_content!, width: 100)
                cmodel.perform_contentcellHeight = cmodel.perform_contentHeight!+25
                
                
                for item:ReplyModel in (smodell[0]?.Reply!)! {
                    
                    item.textHeight = CGFloat.countTextHeight(text: item.replycontent!)
                    item.cellHeight = item.textHeight!+30
                }
                successBlock(smodell as! [CommandDateilModel])
            }
            
        }) { (error) in
            failBlock(error)
        }
        
    }
    //指挥详情
    class func commantDateilRequest(TID:String,successBlock:@escaping (_ amodel:[CommandDateilModel]) -> (),failBlock:@escaping(_ result:ResObject) -> ()) -> () {
        
        NetTool.reqBody(urlstr: GetCommand, strTID: TID, successBlock: { (model) in

            guard let commandList = model.results as? NSArray else {return}
            if let smodell = [CommandDateilModel].deserialize(from:  commandList) {
                let cmodel:CommandDateilModel = smodell[0]!
                
                cmodel.perform_titleHeight = CGFloat.countTextHeight(text:cmodel.perform_title!)
                cmodel.perform_titlecellHeight = cmodel.perform_titleHeight!+10
                
                cmodel.perform_contentHeight = CGFloat.countTextHeight(text:cmodel.perform_content!)
                cmodel.perform_contentcellHeight = cmodel.perform_contentHeight!+25
                
                
                for item:ReplyModel in (smodell[0]?.Reply!)! {
                    
                    item.textHeight = CGFloat.countTextHeight(text: item.replycontent!)
                    item.cellHeight = item.textHeight!+30
                }
                successBlock(smodell as! [CommandDateilModel])
            }
        }) { (error) in
            failBlock(error)
        }
    }
    
    //指挥回复
    class func commantReplyRequest(pk_id:NSInteger,cpid:String,userid:String,Name:String,replycontent:String,bdate_time:String,isread:String,successBlock:@escaping () -> (),failBlock:@escaping(_ result:ResObject) -> ()) -> () {
        
        var parm = paramDic()
        parm.updateValue((pk_id), forKey: "pk_id")
        parm.updateValue((pk_id), forKey: "cpid")
        parm.updateValue(userid, forKey: "userid")
        parm.updateValue(Name, forKey: "Name")
        parm.updateValue(replycontent, forKey: "replycontent")
        parm.updateValue(bdate_time, forKey: "bdate_time")
        parm.updateValue(isread, forKey: "isread")
        
        NetTool.request(type: .POST, urlSuffix: SubmitCommandReply, paramters: parm, successBlock: { (model) in
            
            successBlock()
        }) { (error) in
            failBlock(error)
        }
    }
}

class AddCommandInit: NSObject {
    
    var title:String? = ""
    var conent:String? = ""
    var conentH:CGFloat? = 120
    
    class func send(title:String,conent:String) -> AddCommandInit {
        
        let model = AddCommandInit()
        model.title = title
        model.conent = conent
        
        return model
    }
    
    class func sendList() -> NSMutableArray {
        
        let list = NSMutableArray()
        
        let fristList = NSMutableArray()
        
        let model1 = AddCommandInit.send(title: "*接收人", conent: "未选择")
        let model2 = AddCommandInit.send(title: "*限定日期", conent: "未选择")
        let model3 = AddCommandInit.send(title: "*指挥类型", conent: "需回复")
        let modelj = AddCommandInit.send(title: "*重要程度", conent: "重要并紧急")
        fristList.add(model1)
        fristList.add(model2)
        fristList.add(model3)
        fristList.add(modelj)
        
        let twoList = NSMutableArray()
        let model4 = AddCommandInit.send(title: "请输入执行的事情", conent: "")
        twoList.add(model4)
        
        let thresList = NSMutableArray()
        let model5 = AddCommandInit.send(title: "请输入具体的事项", conent: "")
        thresList.add(model5)
        
        list.add(fristList)
        list.add(twoList)
        list.add(thresList)
        
        return list
        
    }
}
