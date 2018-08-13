//
//  MyJournalCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MyJournalCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var receivedLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UIButton!
    
    var model = SendJournalModel(){
        
        didSet{
            
            self.titleLabel.text = model.Title
            if model.DayDate != "" {
                self.timeLabel.text = String(format: "%@/%@", NSString.refreshMonth(dateString: model.DayDate!),NSString.refreshDay(dateString: model.DayDate!))
            }
            let list = model.ReceiveEID?.components(separatedBy: ",")
            var ReceiveEID:String! = ""
            
            for str in list! {
                let lists = str.components(separatedBy: "(")
                if ReceiveEID == "" {
                    ReceiveEID = String(format: "%@", lists[0])
                }else {
                    ReceiveEID = String(format: "%@,%@", ReceiveEID,lists[0])
                }
            }
            
            self.receivedLabel.text = String(format:"接收人: %@",ReceiveEID!)
            if model.REPLYCON != "" {
                
                self.contentLabel.text = String(format:"回复内容: %@",model.REPLYCON!)
            }else {
                
                self.contentLabel.text = ""
            }
            
            self.numberLabel.setTitle(String(format:" %@",model.AttachCount!), for: .normal)
            self.numberLabel.isHidden = model.AttachCount?.intValue == 0 ? true : false
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
