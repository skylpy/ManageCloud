//
//  DailyReportVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/19.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class DailyReportVM: NSObject {

    /// 请求查询日报表数据
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForDailyReportList(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:[DailyReportModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: DailyReportListURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [DailyReportModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [DailyReportModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
   
    
    
    /// 查询日报中账户信息
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
//    func askForDailyReporAccount(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:[DailyReportModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
//        
//        var params = paramDic()
//        
//        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
//        params.updateValue(ENDDATE , forKey: "ENDDATE")
//        params.updateValue(ZHTID , forKey: "ZHTID")
//        
//        NetTool.request(type: .POST, urlSuffix: DailyReporAccountURL, paramters: params, successBlock: { (success) in
//            
//            guard let personArr = success.results as? NSArray  else{return}
//            
//            let dateSouce = [DailyReportModel].deserialize(from: personArr )
//            
//            scuBlock(dateSouce! as! [DailyReportModel])
//            
//            
//        }) { (fail) in
//            
//            failBlock(fail)
//        }
//    }
    
    /// 查询日报表合计信息(收入合计，支出合计)
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForDailyReporTotal(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:DailyReporTotalModel)->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: DailyReporTotalURL, paramters: params, successBlock: { (success) in
            
            guard let dic = success.result as? NSDictionary  else{return}
            
            let dateSouce = DailyReporTotalModel.deserialize(from: dic)
            
            scuBlock(dateSouce! as! DailyReporTotalModel)
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
    
    /// 查询日报中账户信息
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForDailyReporAccount(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:[ReportAccountListModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: DailyReporAccountURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [ReportAccountListModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [ReportAccountListModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
    
    /// 请求账户列表
    ///
    /// - Parameters:
    ///   - ACCOUNTNAME: 登录账号名称
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForReportAccountList(_ scuBlock:@escaping(_ model:[ReportAccountModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        let ACCOUNTNAME =  MyName()
        params.updateValue(ACCOUNTNAME , forKey: "ACCOUNTNAME")

        NetTool.request(type: .POST, urlSuffix: BankAccountListURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [ReportAccountModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [ReportAccountModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
}
