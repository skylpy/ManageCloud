//
//  SendTextCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class SendTextCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var conentTextView: UITextView!
    
    var indexpath : NSIndexPath?
    var sendType:NSInteger?
    
    
    var model = SendJournalInit(){
        
        didSet{
            
            self.conentTextView.text = model.conent == "" ? model.title : model.conent
        }
    }
    
    var addModel = AddCommandInit(){
        
        didSet{
            
            self.conentTextView.text = addModel.conent == "" ? addModel.title : addModel.conent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.conentTextView.delegate = self
        self.conentTextView.textColor = UIColor.gray

    }
    
}

extension SendTextCell {
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame;
        
        if self.sendType == 0 {
            
            self.model.conent = self.conentTextView.text
            self.conentTextView.textColor = UIColor.black
            self.model.conentH = newFrame.size.height + 20 < 120 ? 120 : newFrame.size.height + 20
        }else if self.sendType == 1 {
            
            self.addModel.conent = self.conentTextView.text
            self.conentTextView.textColor = UIColor.black
            self.addModel.conentH = newFrame.size.height + 20 < 120 ? 120 : newFrame.size.height + 20
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        
        if self.sendType == 0 {
            if textView.text.isEqual("请输入今日完成的工作") || textView.text.isEqual("请输入明日计划的工作") {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }else  if self.sendType == 1 {
            if textView.text.isEqual("请输入执行的事情") || textView.text.isEqual("请输入具体的事项") {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "textViewDidChange")));
        let textVStr = textView.text as NSString
        
        if self.sendType == 0 {
            
            if textVStr.length < 1 {
                
                if self.indexpath?.section == 1 {
                    textView.text =  "请输入今日完成的工作"
                }else {
                    textView.text =  "请输入明日计划的工作"
                }
                textView.textColor = UIColor.gray
                
            }
            
        }else if self.sendType == 1 {
            
            if textVStr.length < 1 {
                
                if self.indexpath?.section == 1 {
                    textView.text =  "请输入执行的事情"
                }else {
                    textView.text =  "请输入具体的事项"
                }
                textView.textColor = UIColor.gray
                
            }
        }
        
    }
}
