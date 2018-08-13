//
//  OutReportViewModel.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit


class OutReportViewModel: NSObject {

    /// 查询支出周报数据
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForOutWeekReportList(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:[OutWeekModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: OutWeekReportListURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [OutWeekModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [OutWeekModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
    
    /// 查询支出周报合计信息
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForOutWeelReporTotal(BEGINDATE:String,ENDDATE:String,ZHTID:String, _ scuBlock:@escaping(_ model:OutWeekTotalEntiesModel)->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: OutWeelReporTotalURL, paramters: params, successBlock: { (success) in
            
            guard let dic = success.result as? NSDictionary  else{return}
            
            let dateSouce = OutWeekTotalEntiesModel.deserialize(from: dic)
            
            scuBlock(dateSouce! )
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
}
