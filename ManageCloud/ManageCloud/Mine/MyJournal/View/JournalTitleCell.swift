//
//  JournalTitleCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class JournalTitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var workTimeLabel: UILabel!
    
    @IBOutlet weak var sendTimeLabel: UILabel!
    
    @IBOutlet weak var personLabel: UILabel!
    
    var model = JournalDateilModel(){
        
        didSet {
            
            self.titleLabel.text = model.Title
            
            if model.GDATE != "" {
                self.workTimeLabel.text = String(format: "工作日期: %@", String(format: "%@", NSString.refreshYMDTime(time: model.GDATE!)))
                self.sendTimeLabel.text = String(format: "发送时间: %@",NSString.refreshYMDhmTime(time: model.BDATE!, format: "-") )
                
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
                self.personLabel.text = String(format: "接收人: %@", ReceiveEID)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
