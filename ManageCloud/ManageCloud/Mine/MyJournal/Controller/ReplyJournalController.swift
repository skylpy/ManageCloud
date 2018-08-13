//
//  ReplyJournalController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class ReplyJournalController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var conentText: UITextView!
    
    var oid:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "回复"
        self.setNavItem()
        self.conentText.delegate = self
        self.conentText.textColor = UIColor.gray
        self.conentText.becomeFirstResponder()
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
        if self.conentText.text! == "" || self.conentText.text! == "请输入回复的内容"{
            HUD.flash(.label("请输入内容"), onView: self.view)
            return
        }
        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
        JournalModel.journalReplyRequest(WLOID: self.oid, MAKEREID: MyOid(), REPLYCON: self.conentText.text!, successBlock: { (arg0) in
            HUD.hide()
            HUD.flash(.success, onView: UIApplication.shared.keyWindow, delay: 2, completion: { (isbool) in
                self.navigationController?.popViewController(animated: true)
            })
            
            
        }) { (error) in
            HUD.hide()
            HUD.flash(.error, onView: self.view)
        }

    }
}

extension ReplyJournalController {
    
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
