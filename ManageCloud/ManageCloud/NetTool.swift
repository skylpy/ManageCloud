//
//  NetTool.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import SwiftyJSON
import HandyJSON

enum MethodType{
    case GET
    case POST
}


class ResObject: HandyJSON {
    var result: AnyObject? = nil
    var results: AnyObject? = nil
    var scode: String? = nil
    var remark: String? = nil
    var Update: AnyObject? = nil
    
    required init(){}
}

class NetTool{
    @discardableResult
    class func request(type: MethodType, urlSuffix: String, paramters: [String: Any]? = nil, successBlock:@escaping (_ Result:ResObject) -> (), failBlock: @escaping (_ Result:ResObject) -> ()) -> DataRequest{
        DPrint("\(BASE_URL(suffix: urlSuffix))")
        let manager = SessionManager.default
        manager.session.configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        //发送类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        //发送网络请求
        return Alamofire.request(BASE_URL(suffix: urlSuffix), method: method, parameters: paramters, encoding:JSONEncoding.default).responseJSON { (response) in
            print("request:\(response.request)") // original URL request
            print("response:\(response.response)")// URL response
            guard let result = response.result.value else{
                DPrint(response)
                print(response.result.error!)
                HUD.flash(.label("网络不佳~"),delay:0.8) {_ in }
                return
            }
            DPrint(result)
            var results = result as! [String: Any]
            
            if results["scode"] is Int {
                 results["scode"] = String(results["scode"] as! Int)
            }
            if results["scode"] as! String == "200"{
                if let model = ResObject.deserialize(from: results)
                {
                    successBlock(model)
                }
                
            }
            else
            {
                if let model = ResObject.deserialize(from: results)
                {
                    failBlock(model)
                }
            }
        }
    }
    
    /// body传字符串请求
    class func reqBody(urlstr:String, strTID:String, successBlock:@escaping (_ Result:ResObject) -> (), failBlock: @escaping (_ Result:ResObject) -> ()) {
        
        
        let url = URL(string: BASE_URL(suffix: urlstr))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let str:Data = strTID.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        
        
        urlRequest.httpBody = str
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseJSON { (response) in
            
            print("request:\(response.request)") // original URL request
            print("response:\(response.response)")// URL response
            guard let result = response.result.value else{
                DPrint(response)
                print(response.result.error!)
                HUD.flash(.label("网络不佳~"),delay:0.8) {_ in
                    
                }
                return
            }
            DPrint(result)
            var results = result as! [String: Any]
            
            if results["scode"] is Int {
                results["scode"] = String(results["scode"] as! Int)
            }
            if results["scode"] as! String == "200"{
                if let model = ResObject.deserialize(from: results)
                {
                    successBlock(model)
                }
                
            }
            else
            {
                if let model = ResObject.deserialize(from: results)
                {
                    failBlock(model)
                }
            }
            
        }
    }
}
