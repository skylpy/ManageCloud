//
//  EmailDetailVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class EmailDetailVM {
    
    /// 获取邮件详情
    func askForEmailDetailList(strTID:String,EIOID:String,EINAME:String, _ scuBlock:@escaping(_ model:[MyEmailModel])->()) {
        
        var params = paramDic()
        params.updateValue(strTID, forKey: "TID")
        params.updateValue(EIOID, forKey: "EIOID")
        params.updateValue(EINAME, forKey: "EINAME")
        
        NetTool.request(type: .POST, urlSuffix: GetMailURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let smodel =  [MyEmailModel].deserialize(from: personArr )
            
            scuBlock(smodel! as! [MyEmailModel])
            
        }) { (fail) in
            
            
        }
        
    }
//    func askForEmailDetailList(strTID:String, _ scuBlock:@escaping(_ model:[MyEmailModel])->()) {
//
////        var params = paramDic()
////        params.updateValue(strTID, forKey: "strTID")
//
//        NetTool.reqBody(urlstr: GetMailURL, strTID: strTID, successBlock: { (success) in
//
//            guard let personArr = success.results as? NSArray  else{return}
//
//            let smodel =  [MyEmailModel].deserialize(from: personArr )
//
//            scuBlock(smodel! as! [MyEmailModel])
//            }
//
//        ) { (fail) in
//
//
//        }
//    }
    
    /// 删除邮件
    func askForDelEmailDetail(TID:String, _ scuBlock:@escaping(_ code:String, _ remark:String)->()) {
        
        NetTool.reqBody(urlstr: DeleteMailURL, strTID: TID, successBlock: { (success) in
            
            
            scuBlock(success.scode!, success.remark!)
        }
            
        ) { (fail) in
            
            
        }
    }
    
    
    /// 读取附件
    @discardableResult
    func askForReadFile(URL:String,SourceFileName:String, _ scuBlock:@escaping(_ byte:NSArray)->()) ->DataRequest {
        
        var dic = paramDic()
//        dic.updateValue(FTPFilePath, forKey: "FTPFilePath")
        dic.updateValue(SourceFileName, forKey: "SourceFileName")
        
        return NetTool.request(type: .POST, urlSuffix: URL , paramters: dic, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            scuBlock(personArr)
            
        }) { (fail) in
            HUD.flash(.label(fail.remark), delay: 2)
        }
    }
    
}
