//
//  PostEmailVM.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/17.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import HandyJSON
import TZImagePickerController
import PKHUD


// 上传邮件附件Model（专用）
class AttachmentPostInfo: NSObject,HandyJSON {
    
    required override init() {
        
    }
    /// 附件序号
    var OID:String? = ""
    ///  附件来源编号,写入附件时请填写添加附件表名称，如'D_GONGGAO' ,
    var WFTID:String? = ""
    /// 附件名称 ,
    var FileName:String? = ""
    /// 附件前台显示名
    var DisplayName:String? = ""
    /// 是否被删除  ,
    var IsDelete:String? = ""
    ///  附件地址
    var URL:String? = ""
    ///  文件大小
    var FileLen:CDouble = 0
}

class PostEmailVM {

    /// 发送邮件
    func askForPostEmail(postM:PostEmailModel, _ scuBlock:@escaping(_ code:String,  _ remark:String)->()) {
        
//        var params = postM.toJSON()!
         var params = paramDic()
        params.updateValue(postM.TID ?? " ", forKey: "TID")
         params.updateValue(postM.SUBJECT ?? " ", forKey: "SUBJECT")
         params.updateValue(postM.FROM ?? " ", forKey: "FROM")
         params.updateValue(postM.SHOU ?? " ", forKey: "SHOU")
         params.updateValue(postM.MCONTENT ?? " ", forKey: "MCONTENT")
        
        if postM.IsReply == true {
             params.updateValue(true, forKey: "IsReply")
             params.updateValue(postM.TID!, forKey: "P_TID")
        }else {
            params.updateValue(false, forKey: "IsReply")
            params.updateValue(postM.TID!, forKey: "P_TID")
        }
       
        
        var fuckAry:[AttachmentPostInfo] = [AttachmentPostInfo]()
        
        for item in postM.ATTACHMENT! {
            let aModel = item
            let model:AttachmentPostInfo = AttachmentPostInfo()
            model.OID = aModel.OID
            model.WFTID = aModel.WFTID
            model.FileName = aModel.FileName
            model.DisplayName = aModel.DisplayName
            model.IsDelete = aModel.IsDelete
            model.URL = aModel.URL
            let fileSize =  FileTools.toKB(size: aModel.FileLen!)
            model.FileLen = fileSize
            
            fuckAry.append(model)
        }
        
//        let tep = fuckAry.toJSON()
//        print("附件数组：")
        params.updateValue(fuckAry.toJSON(), forKey: "ATTACHMENT")
        
         //params.updateValue(postM.ATTACHMENT, forKey: "ATTACHMENT")
//        var size = ""
//        if postM.ATTACHMENT?.count != 0 {
//            let aTTACHMENT = postM.ATTACHMENT![0]
//            size = aTTACHMENT.FileLen!
//            let fileSize =  FileTools.toKB(size: size)
////            aTTACHMENT.FileLen2 = fileSize
//            var dac:[[String:Any]] = params["ATTACHMENT"] as! [[String : Any]]
//
//            for (index,item) in dac {
//
//            }
//            dac.updateValue(fileSize, forKey: "FileLen")
//        }

       
        NetTool.request(type: .POST, urlSuffix: SubmitMailURL, paramters: params, successBlock: { (success) in
            
           //guard (success.results as? NSArray) != nil  else{return}
            

            scuBlock(success.scode ?? "nil error",success.remark ?? " ")
            
            
        }) { (fail) in
            HUD.flash(.labeledError(title: nil, subtitle: fail.remark), delay: 1.0)
            
        }
    }
        
    /// 上传附件到指定服务器 POST
    ///
    /// - Parameters:
    ///   - file: 文件
    ///   - PurposeFileName: 类型
    ///   - URL: 请求
    ///   - scuBlock: 成功
    func askForUpdateFile(file:AnyObject, PurposeFileName:String, URL:String, _ scuBlock:@escaping(_ code:String,  _ remark:String, _ uuid: String)->(),_ failBlock:@escaping()->()) {
        
        var params = paramDic()

        let uuid = CFUUIDCreate(nil)
        var str:String = String(CFUUIDCreateString(nil, uuid))
        str = str.replacingOccurrences(of: ["-"], with: "")

        if file is UIImage {
            
            let img =  file as! UIImage
            let istr = img.base64StrForImg()
            params.updateValue(istr , forKey: "myByte")
            params.updateValue(str + PurposeFileName, forKey: "PurposeFileName")
            
            NetTool.request(type: .POST, urlSuffix: URL, paramters: params, successBlock: { (success) in
                
                //            guard let personArr = success.results as? NSArray  else{return}
                
                
                scuBlock(success.scode ?? "nil error",success.remark ?? " ",str + PurposeFileName)
                
                
            }) { (fail) in
                failBlock()
                
            }
            
        }else {
            //视频
            
            let asset =  file as! PHAsset
            
            TZImageManager.default().getVideoWithAsset(asset) { (playerItem, info) in
                
                print("\(print(playerItem))")
                print("\(print(info))")
                // 获取文件路劲
                let pathary:String = info!["PHImageFileSandboxExtensionTokenKey"] as!String;
                print("\(pathary)")
                let path =  pathary.components(separatedBy: ";").last
               
                var videoData = NSData(contentsOfFile: path!)
                videoData = videoData?.base64EncodedData(options: [NSData.Base64EncodingOptions(rawValue: 0)]) as! NSData
                
                let base64String:String = String.init(data: (videoData! as NSData) as Data, encoding: .utf8)!
                
                
                
                params.updateValue(base64String , forKey: "myByte")
                params.updateValue(str + PurposeFileName, forKey: "PurposeFileName")
                
                NetTool.request(type: .POST, urlSuffix: URL, paramters: params, successBlock: { (success) in
                    
                    //            guard let personArr = success.results as? NSArray  else{return}
                    
                    
                    scuBlock(success.scode ?? "nil error",success.remark ?? " ",str + PurposeFileName)
                    
                    
                }) { (fail) in
                    failBlock()
                    
                }
                
//                let base64String:String = (videoData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))!
                //print("\(base64String)")
                
//                NSString *base64String = [encodeData base64EncodedStringWithOptions:0];DLog(@"Encode String Value: %@", base64String);
//
            }
        }
    }
}
