//
//  FixPassWordsVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON
import PKHUD
class FixPassWordsVM {

    func askForPassWork(wordStr:String,sucBlock: @escaping ( _ codeStr:String, _ reamk:String ) -> ()) {
        
        var params = paramDic()
        let aOid:NSNumber = NSNumber(value: NSString(string: (HSInstance.share.userInfo?.EIOID)!).floatValue)
        
        params.updateValue(aOid, forKey: "EIOID")
        params.updateValue(wordStr, forKey: "PASSWORD")
        
        NetTool.request(type: .POST, urlSuffix: changepwdURL, paramters: params, successBlock: { (success) in
            
            let str = success.scode
            
            sucBlock(str!,success.remark!)
            
            
        }) { (fail) in
            HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)
            
        }
    }
}
