//
//  ReplyCommandController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class ReplyCommandController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var conentTextView: UITextView!
    var oid:NSInteger!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "回复"
        self.setNavItem()
        self.conentTextView.delegate = self
        self.conentTextView.textColor = UIColor.gray
        self.conentTextView.becomeFirstResponder()
    }
    
    func setNavItem() {
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.setTitle("确定", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        rightButton.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView:rightButton )
        
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    @objc func sendRequest() {
        
        self.view.endEditing(false)
        if self.conentTextView.text! == "" || self.conentTextView.text! == "请输入回复的内容" {
            
            HUD.flash(.label("请输入内容"), onView: self.view)
            return
        }

        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
        CommandModel.commantReplyRequest(pk_id: self.oid, cpid: "", userid: MyOid(), Name: MyName(), replycontent: self.conentTextView.text!, bdate_time: self.getNowTimeStamp(),isread:"已回复" ,successBlock: {
            
            HUD.hide()
            HUD.flash(.success, onView: UIApplication.shared.keyWindow, delay: 2, completion: { (isbool) in
                self.navigationController?.popViewController(animated: true)
            })
        }) { (error) in
            HUD.hide()
            HUD.flash(.error, onView: self.view)
        }
    }
    
    //MARK: 获取当前时间的时间戳的两种方法(秒为单位)
    func getNowTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"//设置时间格式；hh——>12小时制， HH———>24小时制
        
        //设置时区
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        formatter.timeZone = timeZone
        
        let dateNow = Date()//当前的时间
        
        //当前时间戳
        let timeStamp = String.init(format: "%ld", Int(dateNow.timeIntervalSince1970))
        
        return timeStamp
    }
}

extension ReplyCommandController {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let textVStr = textView.text as NSString
        if textVStr.length < 1 {
            
            textView.text =  "请输入回复的内容"
            textView.textColor = UIColor.gray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text.isEqual("请输入回复的内容")  {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}
