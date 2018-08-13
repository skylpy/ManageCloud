//
//  WeekReportVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/20.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class WeekReportVM: NSObject {

    
    /// 查询收入周报数据
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForInWeekReportList(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:[WeekReportModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: inWeekReportListURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [WeekReportModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [WeekReportModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
    
    ///查询收入周报合计信息
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForInWeelReporTotal(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:InWeelReporTotalModel)->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: inWeelReporTotalURL, paramters: params, successBlock: { (success) in
            
            guard let dic = success.result as? NSDictionary  else{return}
            
            let dateSouce = InWeelReporTotalModel.deserialize(from: dic)
            
            scuBlock(dateSouce! as! InWeelReporTotalModel)
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
}
