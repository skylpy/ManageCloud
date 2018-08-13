//
//  OutWeekReportDetailVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class OutWeekReportDetailVM: NSObject {

    
    /// 查询支出周报详情数据
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForOutWeekReportDetailsList(BEGINDATE:String,ENDDATE:String,KMTID:String,ZHTID:String, _ scuBlock:@escaping(_ model:[OutWeekReportDetailModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(KMTID , forKey: "KMTID")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: OutWeekReportDetailsURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [OutWeekReportDetailModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [OutWeekReportDetailModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
    
    ///查询支出周报合计信息
    ///
    /// - Parameters:
    ///   - BEGINDATE: 起始日期 格式要求(yyyy-MM-dd) ,
    ///   - ENDDATE:  结束日期 格式要求(yyyy-MM-dd) ,
    ///   - ZHTID: 所选账户的编号
    ///   - scuBlock: 成功
    ///   - failBlock: 失败
    func askForInWeelReporTotal(BEGINDATE:String,ENDDATE:String,KMTID:String,ZHTID:String, _ scuBlock:@escaping(_ model:InWeelReporTotalModel)->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        params.updateValue(BEGINDATE , forKey: "BEGINDATE")
        params.updateValue(ENDDATE , forKey: "ENDDATE")
        params.updateValue(KMTID , forKey: "KMTID")
        params.updateValue(ZHTID , forKey: "ZHTID")
        
        NetTool.request(type: .POST, urlSuffix: OutWeelDetailsotalURL, paramters: params, successBlock: { (success) in
            
            guard let dic = success.result as? NSDictionary  else{return}
            
            let dateSouce = InWeelReporTotalModel.deserialize(from: dic)
            
            scuBlock(dateSouce! as! InWeelReporTotalModel)
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
    
}
