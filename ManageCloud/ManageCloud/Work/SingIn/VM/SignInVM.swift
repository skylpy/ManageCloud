//
//  SignInVM.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import Alamofire

class SignInVM{
    @discardableResult
    class func ToSignIn(withAddress address: String, Lat: String, Long: String, content: String, attach: [AttachmentInfo]?, sucBlock: @escaping (() -> ()), failBlock: @escaping ((ResObject) -> ())) -> DataRequest{
        var param = paramDic()
        param["ETID"] = MyOid()
        param["lat"] = Lat
        param["lng"] = Long
        param["content"] = content
        param["Address"] = address
        var imageData: [String] = [String]()
        var attachArr = [[String: String]]()
        if let attachs = attach{
            for attachmodel in  attachs
            {
                let attachDic:[String: String] = ["GFileName":attachmodel.FileName!]
                attachArr.append(attachDic)
            }
        }
        param["thecontent"] = attachArr
        return NetTool.request(type: .POST, urlSuffix: SignIn, paramters: param, successBlock: { (resSuc) in
            sucBlock()
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    
    // MARK: - 获取某人某日签到列表
    /// - Parameters:
    ///   - tid: 签到人员编号
    ///   - date: 获签到查询时间
    class func LoadPerDaySignList(withTid tid: String, date: String, sucBlock: @escaping (([SignListModel]?) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var dict = paramDic()
        dict["strETID"] = tid
        dict["strBdate"] = date
        NetTool.request(type: .POST, urlSuffix: PerDaySignList , paramters: dict, successBlock: { (resSuc) in
            sucBlock([SignListModel].deserialize(from: resSuc.results as? [Any]) as! [SignListModel]?)
            
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    // MARK: - 获取某人所有签到列表
    class func LoadAllSignList(sucBlock: @escaping (([SignListModel]?) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var dict = paramDic()
        dict["strETID"] = MyOid()
        NetTool.request(type: .POST, urlSuffix: AllDaySignList , paramters: dict, successBlock: { (resSuc) in
            sucBlock([SignListModel].deserialize(from: resSuc.results as? [Any]) as! [SignListModel]?)
            
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    // MARK: - 获取可查阅的签到人员列表
    class func LoadSignPersonList(sucBlock: @escaping (([SignPersonListModel]?) -> ()), failBlock: @escaping ((ResObject) -> ())) {
        var dict = paramDic()
        dict["strETID"] = MyOid()
        NetTool.request(type: .POST, urlSuffix: SignPersonList , paramters: dict, successBlock: { (resSuc) in
            sucBlock([SignPersonListModel].deserialize(from: resSuc.results as? [Any]) as! [SignPersonListModel]?)
            
        }) { (resFail) in
            failBlock(resFail)
        }
    }
    
    
    //读取签到附件
    class func askForSignReadFile(SourceFileName:String, _ sucBlock:@escaping(URL)->()) {
        
        var dic = paramDic()
        dic.updateValue(SourceFileName, forKey: "SourceFileName")
        
        NetTool.request(type: .POST, urlSuffix: SignDownLoad, paramters: dic, successBlock: { (success) in
            
            guard let personArr = success.results as? NSArray  else{return}
            let base64String = personArr[0] as! String
            let file = UrlForDocument[0].appendingPathComponent(SourceFileName)
            FileTools.createFile(name: SourceFileName, baseStr: base64String, { (code) in
                if code == true{
                    sucBlock(file)
                }
            }, { (size) in
                //已经存在
                sucBlock(file)
            })
            
        }) { (fail) in
            
        }
    }
    
    
    
    
    

}
