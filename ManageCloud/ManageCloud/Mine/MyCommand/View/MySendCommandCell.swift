//
//  MySendCommandCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MySendCommandCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lineImage: UIImageView!
    
    @IBOutlet weak var personLabel: UILabel!
    
    @IBOutlet weak var createLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyLabel: UIButton!
    
    @IBOutlet weak var importantLabel: UILabel!
    
    var model = AddCommandModel(){
        
        didSet {
            
            self.titleLabel.text = model.perform_title
            let list = model.accepts?.components(separatedBy: ",")
            var ReceiveEID:String! = ""
            
            for str in list! {
                let lists = str.components(separatedBy: "(")
                if ReceiveEID == "" {
                    ReceiveEID = String(format: "%@", lists[0])
                }else {
                    ReceiveEID = String(format: "%@,%@", ReceiveEID,lists[0])
                }
            }
            self.personLabel.text = String(format:"接收人: %@",ReceiveEID)
            self.importantLabel.text = String(format:"重要程度: %@",model.state!)
            if model.bdate_time != "" {
                self.createLabel.text = String(format:"创建时间: %@",NSString.refreshYMDhmTime(time: model.bdate_time!, format: "/"))
            }

            if model.end_time != "" {
                self.timeLabel.text = String(format: "限定时间: %@", NSString.refreshYMDTime(time: model.end_time!))
            }
            
            
            if model.isReply == "是" || model.isReply == "需回复" || model.isReply == "是：需回复" {
                switch model.num {
                case "0":
                    self.replyLabel.setTitle(" 未回复", for: .normal)
                    self.replyLabel.setTitleColor(UIColor.gray, for: .normal)
                    break
//                case "1":
//                    self.replyLabel.setTitle(" 已回复", for: .normal)
//                    self.replyLabel.setTitleColor(UIColor.init(red: 57, green: 152, blue: 245), for: .normal)
//                    break
                default:
                    self.replyLabel.setTitle(String(format: "%@ 人回复", model.num!), for: .normal)
                    self.replyLabel.setTitleColor(UIColor.init(red: 57, green: 152, blue: 245), for: .normal)
                    break
                }
            }else {
                switch model.num {
                case "0":
                    self.replyLabel.setTitle(" 未读", for: .normal)
                    self.replyLabel.setTitleColor(UIColor.gray, for: .normal)
                    break
                case "1":
                    self.replyLabel.setTitle(" 已读", for: .normal)
                    self.replyLabel.setTitleColor(UIColor.init(red: 57, green: 152, blue: 245), for: .normal)
                    break
                default:
                    self.replyLabel.setTitle(String(format: "%@ 人已读", model.num!), for: .normal)
                    self.replyLabel.setTitleColor(UIColor.init(red: 57, green: 152, blue: 245), for: .normal)
                    break
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
