//
//  MyReceiveCommandCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MyReceiveCommandCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    
    var model = AddCommandModel(){
        
        didSet {
            
            self.titleLabel.text = model.perform_title
            self.stateLabel.text = String(format:"重要程度: %@",model.state!)
            if model.end_time != "" {
                self.timeLabel.text = String(format: "限定时间: %@", NSString.refreshYMDTime(time: model.end_time!))
            }
            
            if model.isReply == "是" || model.isReply == "需回复" || model.isReply == "是：需回复" {
                switch model.num {
                case "0":
                    self.replyButton.setTitle(" 未回复", for: .normal)
                    self.replyButton.setTitleColor(UIColor.gray, for: .normal)
                    break
                default:
                    self.replyButton.setTitle(" 已回复", for: .normal)
                    self.replyButton.setTitleColor(UIColor.init(red: 57, green: 152, blue: 245), for: .normal)
                    break
                }
            }else {
                switch model.num {
                case "0":
                    self.replyButton.setTitle(" 未读", for: .normal)
                    self.replyButton.setTitleColor(UIColor.gray, for: .normal)
                    break

                default:
                    self.replyButton.setTitle(" 已读", for: .normal)
                    self.replyButton.setTitleColor(UIColor.init(red: 57, green: 152, blue: 245), for: .normal)
                    break
                }
            }
            
            if (model.state?.isEqual("不紧急不重要"))! {
                
                self.linImage.image = UIImage.init(named: "hlineC")
            }else if (model.state?.isEqual("紧急不重要"))!{
                
                self.linImage.image = UIImage.init(named: "hlineG")
            }else if (model.state?.isEqual("重要并紧急"))! {
                
                self.linImage.image = UIImage.init(named: "hlineR")
            }else {
                
                self.linImage.image = UIImage.init(named: "hlineL")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
