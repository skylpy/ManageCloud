//
//  PersonInfoVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON
import PKHUD

class PersonInfoVM {
    
//     public typealias PersonViewInfo = (_ sucBlock: @escaping (_ model:personModel ) -> ())
    
    /// 获取个人信息
    func askForPersonInfo(_ sucBlock: @escaping (_ model:[PersonInfoModel] ) -> (),_ failBlock: @escaping ()->())  {
        
        var params = paramDic()
        let aName = HSInstance.share.userInfo?.ACCOUNTNAME
        params.updateValue(aName ?? "", forKey: "AccountName")

        NetTool.request(type: .POST, urlSuffix: PersonInfoURL, paramters: params, successBlock: { (success) in
            
             guard let Arr = success.results as? NSArray  else{return}
            
            let smodel = [PersonInfoModel].deserialize(from:Arr )
            
            sucBlock(smodel! as! [PersonInfoModel])
            
            
            
        }) { (fail) in
            
            HUD.hide()
        }
    }
    
    /// 上传头像
    func askForUpLoadImg(smodel:PersonInfoModel,sucBlock: @escaping ( _ codeStr:String, _ reamk:String ) -> ()) {
        
        var params = paramDic()
        let aName = HSInstance.share.userInfo?.ACCOUNTNAME
        let aOid:NSNumber = NSNumber(value: NSString(string: (HSInstance.share.userInfo?.OID)!).floatValue)
        
        params.updateValue(aName ?? "", forKey: "AccountName")
        params.updateValue(smodel.Name ?? "", forKey: "EINAME")
        params.updateValue(aOid, forKey: "EIOID")
        params.updateValue(smodel.Photo ?? "", forKey: "Photo")
        params.updateValue(smodel.DepID ?? "", forKey: "DTID")
        params.updateValue(smodel.Descr ?? "", forKey: "Descr")
        
        NetTool.request(type: .POST, urlSuffix: UpdatePersonPhotoURL, paramters: params, successBlock: { (success) in
            
            sucBlock(success.scode!, success.remark! )
            
            
        }) { (fail) in
            HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)
            
        }
    }
}
