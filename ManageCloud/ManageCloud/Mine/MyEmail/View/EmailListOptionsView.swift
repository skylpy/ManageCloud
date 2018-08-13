//
//  EmailListOptionsView.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

/// 监听切换 的时候原来收件箱的type
let NotificationName_OldSendEmailList = "NotificationName_OldSendEmailList"

class EmailListOptionsView: UIView {

    @IBOutlet weak var changeBtn: UIButton!
    override func awakeFromNib() {
        
        self.y = 0
        self.x = KWidth/2
        self.width = KWidth/2
        self.height = 50
        
        /// 监听切换 的时候原来收件箱的type
        self.addNotification()
    }
    /// 选择列表
    @IBAction func changeList(_ sender: UIButton) {
        
        let alert =  UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(title: "全部邮件", style: .default, isEnabled: true) { (action) in
            
//            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
//            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"收件箱", "cound" : "全部邮件"])
            EmailListShowType = ["收件箱","全部邮件"]
            sender.setTitle("全部邮件", for: .normal)
        }
        alert.addAction(title: "未读邮件", style: .default, isEnabled: true) { (action) in
//            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
//            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"收件箱", "cound" : "未读邮件"])
            EmailListShowType = ["收件箱","未读邮件"]
            sender.setTitle("未读邮件", for: .normal)
        }
        alert.addAction(title: "附件邮件", style: .default, isEnabled: true) { (action) in
//            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
//            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"收件箱", "cound" : "附件邮件"])
            EmailListShowType = ["收件箱","附件邮件"]
            sender.setTitle("附件邮件", for: .normal)
        }
        
        let action = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        let cancelStr = NSMutableAttributedString.init(string: "取消")
        cancelStr.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: UIFont.systemFont(ofSize: 20), range: NSRange.init(location:0, length: cancelStr.length))
        action.setValue(RGBA(r: 51, g: 51, b: 51, a: 0.9), forKey: "titleTextColor")
//         action.setValue(cancelStr, forKey: "attributedTitle")
        
        alert.addAction(action)
       alert.show()
        
        /// 保存类型 用于下拉刷新
       // EmailListShowType = ["收件箱",sender.currentTitle] as! [String]
    }
    
    // 通知
    func addNotification() {
        
        let notificationName = Notification.Name(rawValue: NotificationName_OldSendEmailList)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(loadList(notification:)),
                                               name: notificationName, object: nil)
        
    }
    
    @objc func loadList(notification: Notification) {
        
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let type = userInfo["type"] as! String
//        let cond = userInfo["cound"] as! String
        
        if changeBtn.currentTitle == "全部邮件" {
            
            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"收件箱", "cound" : "全部邮件"])
            
            
        }else if changeBtn.currentTitle == "未读邮件"{
            
            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"收件箱", "cound" : "未读邮件"])
            
        }else if changeBtn.currentTitle == "附件邮件"{
            
            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"收件箱", "cound" : "附件邮件"])
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
