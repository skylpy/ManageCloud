//
//  EndApplicationVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class EndApplicationVM: NSObject {

    /// 请求审批列表
    func askForEndApplicationList(_ scuBlock:@escaping(_ model:[ApplicationModel])->(), _ failBlock:@escaping(_ Result:ResObject)->()) {
        
        var params = paramDic()
        
        let OID = HSInstance.share.userInfo?.EIOID
        
        params.updateValue(OID ?? "", forKey: "eitid")
        
        
        NetTool.request(type: .POST, urlSuffix: ApprovedListURL, paramters: params, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            
            let dateSouce = [ApplicationModel].deserialize(from: personArr )
            
            scuBlock(dateSouce! as! [ApplicationModel])
            
            
        }) { (fail) in
            
            failBlock(fail)
        }
    }
}
