//
//  HSInstance.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class HSInstance: NSObject {
    //一般取值从这里获取
    var userInfo: HSUserInfo? = nil
    //计算属性---更新的时候要赋值给newUserInfo，登录判断需要用这个
    var newUserInfo: HSUserInfo?{
        set(newValue){
            MCSave.saveData(Model: newValue, withKey: "userInfo")
            userInfo = newValue
        }
        get{
            if userInfo == nil {
                let info = MCSave.getDataWithKey(HSUserInfo.self, key: "userInfo") as? HSUserInfo
                userInfo = MCSave.getDataWithKey(HSUserInfo.self, key: "userInfo") as? HSUserInfo
            }
            return userInfo
        }
    }
    static let share = HSInstance();
    private override init(){}
    
    func getInfoByDictionary() -> [String: Any] {
        var dict: [String:Any] = [String: Any]()
//        if !(userInfo?.SessionID?.isEmpty)! {
//            dict["SessionID"] = userInfo?.SessionID
//        }
//        else
//        {
//            dict["SessionID"] = "!@#!@#!@%$^$%^&@@#$@!$#WDFSDFASDFAFD"
//        }
//        guard let info = userInfo else{return dict}
//        if !(userInfo?.ACCOUNTNAME?.isEmpty)! {
//            dict["AccountName"] = userInfo?.ACCOUNTNAME
//        }
        return dict
    }
}
