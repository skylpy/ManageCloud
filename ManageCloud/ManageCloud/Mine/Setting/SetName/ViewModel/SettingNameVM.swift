//
//  SettingNameVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON
import PKHUD

class SettingNameVM {

    func askForUpdateName(smodel:PersonInfoModel,sucBlock: @escaping ( _ codeStr:String, _ reamk:String ) -> ()) {
        
        var params = paramDic()
        let aName = HSInstance.share.userInfo?.ACCOUNTNAME
        let aOid:NSNumber = NSNumber(value: NSString(string: (HSInstance.share.userInfo?.OID)!).floatValue)
        
        params.updateValue(aName ?? "", forKey: "AccountName")
        params.updateValue(smodel.Name ?? "", forKey: "EINAME")
        params.updateValue(aOid, forKey: "EIOID")
        params.updateValue(smodel.Photo ?? "", forKey: "Photo")
        params.updateValue(smodel.DepID ?? "", forKey: "DTID")
        params.updateValue(smodel.Descr ?? "", forKey: "Descr")
        
        
        NetTool.request(type: .POST, urlSuffix: UpdatePersonNameURL, paramters: params, successBlock: { (success) in
            
            sucBlock(success.scode!, success.remark! )
            
            
        }) { (fail) in
            
            HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)
        }
    }
}
