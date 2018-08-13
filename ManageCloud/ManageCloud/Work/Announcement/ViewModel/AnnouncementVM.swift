//
//  AnnouncementVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class AnnouncementVM {
    
    /// 请求公告列表
    func askForAnnouncementList( _ scuBlock:@escaping(_ model:[AnnouncementModel])->(), _ failBlock:@escaping () -> ()) {
        
        var params = paramDic()
        let aName = HSInstance.share.userInfo?.ACCOUNTNAME
        params.updateValue(aName ?? "", forKey: "AccountName")
        
        NetTool.request(type: .POST, urlSuffix: GetGongGaoListURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
//            let dateSouce:NSMutableArray = NSMutableArray.init(array: personArr)
            
            if let dateSouce = [AnnouncementModel].deserialize(from: personArr )  {
                //                let amodel = smodel.attachment
//                for index in personArr{
//                    let smodel = MailModel.deserialize(from: (index as! NSDictionary))
//                    dateSouce.add(smodel!)
//                }
                scuBlock(dateSouce as! [AnnouncementModel] )
            }
            
            
        }) { (fail) in
            failBlock()
            HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)
        }
    }
    
    
    
//    func askForAnnouncementDetail( strTID:String,_ scuBlock:@escaping(_ model:[AnnouncementModel])->()) {
////        var params = paramDic()
////        params.updateValue(strTID, forKey: strTID)
//        
//        NetTool.reqBody(urlstr: GetGongGaoURL, strTID: strTID, successBlock: { (success) in
//            guard let personArr = success.results as? NSArray  else{return}
//            
//            if let dateSouce = [AnnouncementModel].deserialize(from: personArr )  {
//                
//                scuBlock(dateSouce as! [AnnouncementModel] )
//            }
//            
//        }) { (fail) in
//             HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)
//        }
//
//    }
    
    /// 请求公告详情
    func askForAnnouncementDetail( strTID:String,strEIOD:String, _ scuBlock:@escaping(_ model:[AnnouncementModel])->()) {
        //        var params = paramDic()
        //        params.updateValue(strTID, forKey: strTID)
        var params = paramDic()
        params.updateValue(strTID, forKey: "Tid")
        params.updateValue(strEIOD, forKey: "EIOD")
        
        NetTool.request(type: .POST, urlSuffix: GetGongGaoURL,paramters:params,  successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            if let dateSouce = [AnnouncementModel].deserialize(from: personArr )  {
                
                scuBlock(dateSouce as! [AnnouncementModel] )
            }
            
        }) { (fail) in
            
            HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)

        }
        
    }

    
    /// 公告附件读取
//    func askForGongGaoReadFile( strTID:String,_ scuBlock:@escaping(_ model:[AnnouncementModel])->()) {
//        //        var params = paramDic()
//        //        params.updateValue(strTID, forKey: strTID)
//        
//        NetTool.reqBody(urlstr: GongGaoReadFileURL, strTID: strTID, successBlock: { (success) in
//            guard let personArr = success.results as? NSArray  else{return}
//
//            if let dateSouce = [AnnouncementModel].deserialize(from: personArr )  {
//                
//                scuBlock(dateSouce as! [AnnouncementModel] )
//            }
//            
//        }) { (fail) in
//            
//        }
//        
//    }
}
