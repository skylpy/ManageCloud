//
//  MyCommandInfoCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MyCommandInfoCell: UITableViewCell {
    
    @IBOutlet weak var personLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var model = CommandDateilModel(){
        
        didSet {
            
            if model.accepts != nil {
                
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
                self.personLabel.attributedText = NSAttributedString.allConentStr(String(format:"接收人: %@",ReceiveEID), withAttStr: "接收人: ", withAcolor: UIColor.lightGray)
                if model.bdate_time != "" {
                    self.timeLabel.attributedText = NSAttributedString.allConentStr(String(format:"限定时间: %@",NSString.refreshYMDTime(time: model.end_time!)), withAttStr: "限定时间: ", withAcolor: UIColor.lightGray)
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
