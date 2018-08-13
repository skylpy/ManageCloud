//
//  SetIntroductionVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class SetIntroductionVM {

    func askForUpdateDescr(smodel:PersonInfoModel,sucBlock: @escaping ( _ codeStr:String, _ reamk:String ) -> ()) {
        
        var params = paramDic()
        let aOid:NSNumber = NSNumber(value: NSString(string: (HSInstance.share.userInfo?.EIOID)!).floatValue)

        params.updateValue(aOid, forKey: "EIOID")
        params.updateValue(smodel.Descr ?? "", forKey: "Descr")
        
        NetTool.request(type: .POST, urlSuffix: UpdatePersonDescrURL, paramters: params, successBlock: { (success) in
            
            let str = success.scode
            
            sucBlock(str!,success.remark!)
            
            
        }) { (fail) in
            
            HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)
        }
    }
}
