//
//  WorkFlowVM.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON
import PKHUD
import SwiftyJSON

class WorkFlowVM {
    //获取工作流列表
    class func loadFlowList(sucBlock: @escaping (([FlowListModel]) -> ()), failBlock: @escaping ((ResObject) -> ())){
         var param = paramDic()
        param["EiOid"] = MyOid()
        NetTool.request(type: .POST, urlSuffix: WorkFlowList, paramters: param, successBlock: { (resSuc) in
            sucBlock([FlowListModel].deserialize(from: resSuc.results as? [Any])! as! [FlowListModel])
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    //获取工作流样式
    class func loadFlowInput(WithBTid Btid:(String), sucBlock: @escaping ((FormInputModel) -> ()), failBlock: @escaping ((ResObject) -> ())){
        var param = paramDic()
        param["EiOid"] = MyOid()
        param["DOid"] = HSInstance.share.userInfo?.DOID
        param["AccountName"] = MyName()
        param["Tid"] = "0"
        param["BTid"] = Btid
        param["DName"] = HSInstance.share.userInfo?.DNAME
        param["EiName"] = HSInstance.share.userInfo?.EINAME
        NetTool.request(type: .POST, urlSuffix: WorkGetFrom, paramters: param, successBlock: { (resSuc) in
            sucBlock(FormInputModel.deserialize(from: resSuc.result as? [String: Any])!)
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    //保存表单
    class func save(WithTID Tid: String, controls:[FormControlModel], isModify: Bool,sucBlock: @escaping (() -> ()), failBlock: @escaping ((ResObject) -> ()) ){
        
        for model in controls{
            if model.AllowNullInput == "false" && (model.Value?.isEmpty)!{
                HUD.flash(.labeledError(title: nil, subtitle: "请输入" + model.ControlName!), delay: 1.0)
                return
            }
        }
        
        var param = paramDic()
        param["TID"] = Tid
        param["EiOid"] = MyOid()
        param["DOid"] = MyDOid()
        param["AccountName"] = MyName()
        var controlArr = [[String: String]]()
        for model in controls{
            var dict = [String: String]()
            dict.updateValue(model.EFIELDNAME!, forKey: "EFIELDNAME")
            dict.updateValue(model.ControlType!, forKey: "ControlType")
            dict.updateValue(model.Value!, forKey: "Value")
            controlArr.append(dict)
        }
        param["ColumnControls"] = controlArr
        var url = ""
        if isModify{
            url = modifyForm
        }
        else{
            url = saveForm
        }
        
//        NetTool.request(type: .POST, urlSuffix: url, paramters: param, successBlock: { (resSuc) in
//            sucBlock()
//        }) { (resFail) in
//            failBlock(resFail)
//        }
    }
    
    class func GetStep(WithTid tid: String, BTid: String, bpftid: String, sucBlock: @escaping (((String, [FlowStepPerson])) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var param = paramDic()
        param["crTid"] = tid
        param["bTid"] = BTid
        param["bpftid"] = bpftid
        param["fqrTid"] = MyOid()
        NetTool.request(type: .POST, urlSuffix: GetFlowStep, paramters: param, successBlock: { (resSuc) in
            let resulrJson = JSON(resSuc.result!)
            let inner = resulrJson["StepInfos"].arrayValue.first!
            let tips = inner["NodeNum"].stringValue.substring(from: 1) +  "请选择" + inner["NodeName"].stringValue
            let personArr = [FlowStepPerson].deserialize(from: inner["PersonList"].arrayObject)
            sucBlock((tips,personArr as? [FlowStepPerson] ?? [FlowStepPerson]()))
            
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    
}

class FormControlModel: HandyJSON{
    //控件名称
    var ControlName: String? = ""
    //控件类型
    var ControlType: String? = ""
    //控件标签名称
    var CFIELDNAME: String? = ""
    //控件的文本
    var TEXT: String? = ""
    //允许空值
    var AllowNullInput: String? = ""
    //是否只读
    var ReadOnly: String? = ""
    //控件对应数据库字段
    var EFIELDNAME: String? = ""
    //控件值
    var Value: String? = ""
    
    
    
    //单选控制器专属
    var selectedIndex: Int = 0
    var dataSource:[String] = []
    
    
    //时间选择器专属
    var selectedDate: Date = Date()
    //选择的日期
    var selectedDateString: String = ""{
        didSet{
            Value = selectedDateString
        }
    }
    
    
    //记录cell高度
    var cellHeight: CGFloat = 0
    
    //checkBox是否是分类中的第一个
    var isFirst: Bool = false
    //checkBox是否被选择
    var isSelected: Bool = false
    
    required init() {}
}

class FormOptionalModel: HandyJSON{
    //控件名称
    var ControlName: String? = ""
    //控件类型
    var Selected: String? = ""
    //控件值
    var Value: String? = ""
    //控件的文本
    var TEXT: String? = ""
    required init() {}
}

class FormInputModel: HandyJSON{
    var Controls: [FormControlModel]? = []
    var Options: [FormOptionalModel]? = []
    required init() {}
}



class FlowListModel: HandyJSON {
    // 自定义表单编号
    var Tid: String? = ""
    // 自定义表单名称
    var Name: String? = ""
    required init() {}
}


class FlowStepPerson: HandyJSON{
    //员工OID
    var POid : String? = ""
    //员工姓名
    var PName : String? = ""
    //部门OID
    var DOid : String? = ""
    //部门名称
    var DName : String? = ""
    
    var isSelete: Bool = false
    required init() {}
}
