//
//  UpdateVM.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/17.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON
import HandyJSON


class HomeVM{

    // MARK: - 检查更新
    class func checkupVersion(_ showAlredayNew: Bool) {
        let info = Bundle.main.infoDictionary
        let app_Version = info!["CFBundleShortVersionString"] as! String
        var params = paramDic()
        params["Type"] = "IOS"
        params["Version"] = app_Version
        
        NetTool.request(type: .POST, urlSuffix: CheckUpdate, paramters: params, successBlock: { (resSuc) in
            if let update = resSuc.Update as? [String: Any]{
                let alert =  UIAlertController.init(title:update["Title"] as! String, message: update["Note"] as! String, defaultActionButtonTitle:"取消" , tintColor: BlueColor)
                alert.addAction(title: "更新", style: .cancel, isEnabled: true, handler: { (action) in
                    UIApplication.shared.openURL(URL.init(string: update["Url"] as! String)!)
                })
                alert.show(animated: true, vibrate: true, completion: {})
            }
            
        }) { (resFail) in
            if showAlredayNew{
                HUD.flash(.label(resFail.remark))
            }
            
        }
    }
    
    // MARK: - 获取新邮件未读数
    class func GetNewEmailCount(sucBlock: @escaping ((String) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var params = paramDic()
        params["AccountName"] = MyName()
        params["Sex"] = ""
        NetTool.request(type: .POST, urlSuffix: newEmailCount, paramters: params, successBlock: { (resSuc) in
            let num = (resSuc.results as! [AnyObject]).first!
            sucBlock("\(num)")
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    // MARK: - 获取权限列表
    class func GetAuthority(sucBlock: @escaping (([HomeAuthorityModel]) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var params = paramDic()
        params["AccountName"] = MyName()
        params["OID"] = (HSInstance.share.userInfo?.OID)!
        NetTool.request(type: .POST, urlSuffix: GetPersonAuthority, paramters: params, successBlock: { (resSuc) in
            let json = JSON(resSuc.results!).arrayObject
            
            if let personArr = [HomeAuthorityModel].deserialize(from: json){
                sucBlock(personArr as! [HomeAuthorityModel])
            }
            else{
                sucBlock([HomeAuthorityModel]())
            }
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    // MARK: - 工作区轮播公告
    class func GetHomeGongGao(sucBlock: @escaping ((String) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var params = paramDic()
        params["AccountName"] = MyName()
        NetTool.request(type: .POST, urlSuffix: homeGongGao, paramters: params, successBlock: { (resSuc) in
            let gonggao = (resSuc.results as! [AnyObject]).first!
            sucBlock(gonggao as! String)
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    // MARK: - 获取下属人员列表
    class func GetSubPeopleList(sucBlock: @escaping (([personModel]?) -> ()), failBlock: @escaping ((ResObject) -> ())) {
    
        NetTool.reqBody(urlstr: subPersonList, strTID: MyOid(), successBlock: { (resSuc) in
            let json = JSON(resSuc.results!).arrayObject
            
            if let personArr = [personModel].deserialize(from: json){
                sucBlock(personArr as? [personModel])
            }
            else{
                sucBlock(nil)
            }
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    
    
    // MARK: - 获取权限人员列表
    class func GetAuthorPeopleList(sucBlock: @escaping (([personModel]?) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        
        NetTool.reqBody(urlstr: CommandPersonList, strTID: MyOid(), successBlock: { (resSuc) in
            let json = JSON(resSuc.results!).arrayObject
            
            if let personArr = [personModel].deserialize(from: json){
                sucBlock(personArr as? [personModel])
            }
            else{
                sucBlock(nil)
            }
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    
    
    // MARK: - 获取关键人员列表
    class func GetKeyPeopleList(sucBlock: @escaping (([personModel]?) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        
        NetTool.reqBody(urlstr: GetKeyPersonList, strTID: MyOid(), successBlock: { (resSuc) in
            let json = JSON(resSuc.results!).arrayObject
            
            if let personArr = [personModel].deserialize(from: json){
                sucBlock(personArr as? [personModel])
            }
            else{
                sucBlock(nil)
            }
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    class func askHomeLogList(isSub: Bool, Oid: String, sucBlock: @escaping (([HomeLogModel]?) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var params = paramDic()
        params["EIOID"] = Oid
        var url = ""
        if isSub {
            url = HomeSubLogList
        }
        else{
            url = HomeLogList
        }
        NetTool.request(type: .POST, urlSuffix: url, paramters: params, successBlock: { (resSuc) in
            let json = JSON(resSuc.results!).arrayObject
            
            if let personArr = [HomeLogModel].deserialize(from: json){
                sucBlock(personArr as! [HomeLogModel])
            }
            else{
                sucBlock(nil)
            }
        }) { (resFail) in
            failBlock(resFail)
        }
//        NetTool.reqBody(urlstr: HomeLogList, strTID: MyOid!, successBlock: { (resSuc) in
//            let json = JSON(resSuc.results!).arrayObject
//
//            if let personArr = [HomeLogModel].deserialize(from: json){
//                sucBlock(personArr as [HomeLogModel])
//            }
//            else{
//                sucBlock(nil)
//            }
//        }) { (resFail) in
//            failBlock(resFail)
//        }
    }
    
    

}


class HomeLogModel: HandyJSON{
    //工作日志编号
    var OID: String? = ""
    //人员编号
    var EIOID: String? = ""
    //人员名称
    var EINAME: String? = ""
    //人员头像
    var Photo: String? = ""
    //人员性别
    var Sex: String? = ""
    //工作日志生成日期
    var BDATE: String? = ""
    //计划
    var TomorrowPlan: String? = ""
    //完成
    var TodayPlan: String? = ""
    //是否有附件:无、有 2种状态
    var AttachCount: String? = ""
    
    required init() {}
}


class HomeAuthorityModel: HandyJSON{
    //父菜单编号
    var ParentID: String? = ""
    //菜单编码
    var TID: String? = ""
    //菜单名称
    var Name: String? = ""
    //人员权限编号
    var OID: String? = ""
    //菜单编号
    var DMOID: String? = ""
    //增加权限
    var Adds: String? = ""
    //编辑权限
    var Edit: String? = ""
    //删除权限
    var Del: String? = ""
    //查询权限
    var Sel: String? = ""
    
    required init() {}
}
