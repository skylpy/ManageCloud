//
//  EmailListVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class EmailListVM {
    
    /// 请求邮件列表
    func askForEmailList(listType:String, condType:String, _ scuBlock:@escaping(_ model:[MyEmailModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        let Oid = HSInstance.share.userInfo?.EIOID
        params.updateValue(Oid ?? "", forKey: "EIOID")
        params.updateValue(listType, forKey: "Type")
        params.updateValue(condType, forKey: "Cond")
        
        NetTool.request(type: .POST, urlSuffix: EmailListURL, paramters: params, successBlock: { (success) in
            
             guard let personArr = success.results as? NSArray  else{return}

            let dateSouce = [MyEmailModel].deserialize(from: personArr )
            
//            if [MailModel].deserialize(from: personArr ) != nil {
////                let amodel = smodel.attachment
//                for index in personArr{
//                    let smodel = MailModel.deserialize(from: (index as! NSDictionary))
//                    dateSouce.add(smodel!)
//                }
//                scuBlock(dateSouce)
//            }
            scuBlock(dateSouce! as! [MyEmailModel])

            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
}
