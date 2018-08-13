//
//  JournalModel.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON

class SendJournalInit: NSObject {
    
    
    var title:String? = ""
    var conent:String? = ""
    var conentH:CGFloat? = 120
    
    class func send(title:String,conent:String) -> SendJournalInit {
        
        let model = SendJournalInit()
        model.title = title
        model.conent = conent
        
        return model
    }
    
    class func sendList() -> NSMutableArray {
        
        let list = NSMutableArray()
        
        let fristList = NSMutableArray()
        
        let model1 = SendJournalInit.send(title: "*接收人", conent: "未选择")
        let model2 = SendJournalInit.send(title: "*工作日期", conent: NSString.getCurrentTimes())
        fristList.add(model1)
        fristList.add(model2)
        
        let twoList = NSMutableArray()
        let model3 = SendJournalInit.send(title: "请输入今日完成的工作", conent: "")
        twoList.add(model3)
        
        let thresList = NSMutableArray()
        let model4 = SendJournalInit.send(title: "请输入明日计划的工作", conent: "")
        thresList.add(model4)
        
        list.add(fristList)
        list.add(twoList)
        list.add(thresList)
        
        return list
        
    }
}

class JournalDateilModel: NSObject, HandyJSON {
    
    //标题
    var Title:String? = ""
    //工作日期
    var GDATE:String? = ""
    //发送时间
    var BDATE:String? = ""
    //接收人格式
    var ReceiveEID:String? = ""
    //今日完成
    var TodayPlan:String? = ""
    //明日计划
    var TomorrowPlan:String? = ""
    //附件信息
    var Attachinfo:[AttachinfoModel]? = []
    //回复信息
    var RebackInfo:[RebackInfoModel]? = []
    
    var TomorrowtextHeight:CGFloat? = 0
    var TomorrowcellHeight:CGFloat? = 0
    
    var TodaytextHeight:CGFloat? = 0
    var TodaycellHeight:CGFloat? = 0
    
    required override init() {}
}

class AttachinfoModel: NSObject,HandyJSON {
    //附件名称
    var DisplayName:String? = ""
    var FileName:String? = ""
    var FileLen:NSInteger = 0
    ///  附件来源编号,写入附件时请填写添加附件表名称，如'D_GONGGAO' ,
    var WFTID:String? = ""
    
    required override init() {}
}

class RebackInfoModel: NSObject,HandyJSON {
    //回复人员名称
    var EINAME:String? = ""
    //回复内容
    var REPLYCON:String? = ""
    //回复时间
    var BDATE:String? = ""

    var textHeight:CGFloat? = 0
    var cellHeight:CGFloat? = 0
    required override init() {}
}

class SendJournalModel: NSObject, HandyJSON {
    
    //工作日志编号
    var OID:String? = ""
    //工作日志标题
    var Title:String? = ""
    //附件个数
    var AttachCount:String? = ""
    //接收人
    var ReceiveEID:String? = ""
    //回复内容
    var REPLYCON:String? = ""
    //完成
    var DayTime:String? = ""
    var DayDate:String? = ""
    var GDATE:String? = ""
    
    //人员头像
    var Photo:String? = ""
    
    required override init() {}
}

class JournalModel: NSObject {
    
    class func uploadRequest(myByte:String,PurposeFileName:String,successBlock:@escaping(_ _M:()) -> (),failBlock:@escaping(_ refail:ResObject) -> ()) {
        var params = paramDic()
        params.updateValue(myByte, forKey: "myByte")
        params.updateValue(PurposeFileName, forKey: "PurposeFileName")
        
        NetTool.request(type: .POST, urlSuffix: WorkLogUpdateFile, paramters: params, successBlock: { (suceeReg) in
            
            successBlock(())
            
        }) { (failReg) in
            
            failBlock(failReg)
            
        }
    }
    
    //我发的日志列表
    class func sendJournalListRequest(EIOID: String, sucBlock:@escaping (_ journalList:[SendJournalModel]) -> (), failBlock: @escaping (_ Result:ResObject) -> ()) {
        var params = paramDic()
        params.updateValue(EIOID, forKey: "EIOID")
        
        NetTool.request(type: .POST, urlSuffix: SendWorkLog, paramters: params, successBlock: { (resSuc) in
            guard let journalList = resSuc.results as? NSArray  else{return}
            if let journaModellList = [SendJournalModel].deserialize(from: journalList ) {
                sucBlock(journaModellList as! [SendJournalModel])
            }
            
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    //添加日志
    class func sendJournalRequest(ReceiveEID:String,GDATE:String,TodayPlan:String,TomorrowPlan:String,CreateEID:String,array:[AttachmentInfo],successBlock:@escaping (_ _M:()) -> (),failBlock:@escaping(_ result:ResObject) -> ()) -> () {
        
        var parm = paramDic()
        parm.updateValue(ReceiveEID, forKey: "ReceiveEID")
        parm.updateValue(GDATE, forKey: "GDATE")
        parm.updateValue(TodayPlan, forKey: "TodayPlan")
        parm.updateValue(TomorrowPlan, forKey: "TomorrowPlan")
        parm.updateValue(CreateEID, forKey: "CreateEID")

        let attArr:NSMutableArray = NSMutableArray()
        for item:AttachmentInfo in array {
            
            let dict = NSMutableDictionary()
            dict.setValue(item.OID, forKeyPath: "OID")
            dict.setValue(item.WFTID, forKeyPath: "WFTID")
            dict.setValue(item.FileName, forKeyPath: "FileName")
            dict.setValue(item.DisplayName, forKeyPath: "DisplayName")
            dict.setValue(item.IsDelete, forKeyPath: "IsDelete")
            dict.setValue(item.URL, forKeyPath: "URL")
            dict.setValue((item.FileLen?.intValue), forKeyPath: "FileLen")
            attArr.add(dict)
        }
        parm.updateValue(attArr, forKey: "Attachments")

        NetTool.request(type: .POST, urlSuffix: AddWorkLog, paramters: parm, successBlock: { (resSuc) in
            
            successBlock(())
            
        }) { (result) in
            failBlock(result)
        }
    }
    
    //收到的日志列表
    class func receivedJournalListRequest(EIOID:String,EINAME:String,successBlock:@escaping(_ list : [NSArray]) -> (),failBlock:@escaping(_ refail:ResObject) -> ()) -> () {
        
        var pram = paramDic()

        pram.updateValue((EIOID.intValue), forKey: "EIOID")
//        pram.updateValue(EINAME, forKey: "EINAME")
  
        print(pram)
        
        NetTool.request(type: .POST, urlSuffix: ReceiveWorkLog, paramters: pram, successBlock: { (resSuc) in
            guard let journalList = resSuc.results as? NSArray else {return}
            let listss:NSArray = CustomString.sort(journalList as! [Any]) as! NSArray
            successBlock(listss as! [NSArray])

        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    //回复
    class func journalReplyRequest(WLOID:String,MAKEREID:String,REPLYCON:String,successBlock:@escaping(_ _M:()) -> (),failBlock:@escaping(_ refail:ResObject) -> ()) -> () {
        
        var pram = paramDic()
        pram.updateValue(WLOID, forKey: "WLOID")
        pram.updateValue(MAKEREID, forKey: "MAKEREID")
        pram.updateValue(REPLYCON, forKey: "REPLYCON")
        
        NetTool.request(type: .POST, urlSuffix: AddWorkLogReback, paramters: pram, successBlock: { (resSuc) in
            
            successBlock(())
            
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    //日志详情
    class func journalDateilRequest(OID:String,successBlock:@escaping(_ model:JournalDateilModel) -> (),failBlock:@escaping(_ refail:ResObject) -> ()) -> () {
        
        var pram = paramDic()
        pram.updateValue(OID, forKey: "OID")
        
        NetTool.request(type: .POST, urlSuffix: WorkLogDisplay, paramters: pram, successBlock: { (resSuc) in
            
            if let journaModel = JournalDateilModel.deserialize(from: resSuc.result as? [String: Any]) {
                
                journaModel.TomorrowtextHeight = CGFloat.countTextHeight(text:journaModel.TomorrowPlan!)
                journaModel.TomorrowcellHeight = journaModel.TomorrowtextHeight!+30
                
                journaModel.TodaytextHeight = CGFloat.countTextHeight(text:journaModel.TodayPlan!)
                journaModel.TodaycellHeight = journaModel.TodaytextHeight!+30
                
                for item:RebackInfoModel in journaModel.RebackInfo! {
                    
                    item.textHeight = CGFloat.countTextHeight(text: item.REPLYCON!)
                    item.cellHeight = item.textHeight!+30
                }
                successBlock(journaModel )
            }
            
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
}

//NSString 扩展
extension NSString {
    
    //获取当前的时间
    class func getCurrentTimes() -> String {
        
        let formatter = DateFormatter.init()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "YYYY-MM-dd"
        
        //设置时区
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        formatter.timeZone = timeZone
        
        let datenow = NSDate.init()
        let currentTimeString = formatter.string(from: datenow as Date)
        
        return currentTimeString
    }
}

//CGFloat 扩展

extension CGFloat {
    
    //计算高度
    static func countcustTextHeight(text:String,width:CGFloat) -> CGFloat {
        
        let textStr = text as NSString
        
        let attributeString = NSMutableAttributedString.init(string: text)
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 0
        let font = UIFont.init(fontName: kRegFont, size: 17)
        attributeString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value: style, range: NSRange(location: 0, length: textStr.length))
        attributeString.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: font, range: NSRange(location: 0, length: textStr.length))
        
        let options:NSStringDrawingOptions = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)
        
        let rect = attributeString.boundingRect(with: CGSize(width: KWidth - width, height: CGFloat.greatestFiniteMagnitude), options: options, context: nil)
        
        return rect.size.height 
        
    }
    
    //计算高度
    static func countTextHeight(text:String) -> CGFloat {
        
        let textStr = text as NSString
        
        let attributeString = NSMutableAttributedString.init(string: text)
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 0
        let font = UIFont.init(fontName: kRegFont, size: 16)
        attributeString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value: style, range: NSRange(location: 0, length: textStr.length))
        attributeString.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: font, range: NSRange(location: 0, length: textStr.length))
        
        let options:NSStringDrawingOptions = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)
        
        let rect = attributeString.boundingRect(with: CGSize(width: KWidth - 30, height: CGFloat.greatestFiniteMagnitude), options: options, context: nil)
        
        return rect.size.height + 23
        
    }
}

extension NSMutableAttributedString {
    
    static func initHighLightText(_ normal: String, highLight: String, font: UIFont, color: UIColor, highLightColor: UIColor) -> NSMutableAttributedString {
        
    //定义富文本即有格式的字符串
    let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
    let strings = normal.components(separatedBy: highLight)
    for i in 0..<strings.count {
        let item = strings[i]
        let dict = [kCTFontAttributeName: font, kCTForegroundColorAttributeName: color]
        let content = NSAttributedString(string: item, attributes: dict as [NSAttributedStringKey : Any])
        attributedStrM.append(content)
        if i != strings.count - 1 {
            let dict1 = [kCTFontAttributeName: font, kCTForegroundColorAttributeName: highLightColor]
            let content2 = NSAttributedString(string: highLight, attributes: dict1 as [NSAttributedStringKey : Any])
            attributedStrM.append(content2)
        }
    }
    return attributedStrM
    
    }
    
}

