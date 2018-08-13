//
//  JournalCommentCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class JournalCommentCell: UITableViewCell {
    @IBOutlet weak var connentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var model = RebackInfoModel(){
        
        didSet {
            
            self.connentLabel.text = String(format:"%@: %@",model.EINAME!,model.REPLYCON!)
            self.timeLabel.text = model.BDATE
            if model.BDATE != "" {
                self.timeLabel.text = String(format: "%@-%@-%@ %@:%@", NSString.refreshYear(dateString: model.BDATE!),NSString.refreshMonth(dateString: model.BDATE!),NSString.refreshDay(dateString: model.BDATE!),NSString.refreshHour(dateString: model.BDATE!),NSString.refreshM(dateString: model.BDATE!))
            }
        }
    }
    
    var cmodel = ReplyModel(){
        
        didSet {
            
            self.connentLabel.text = String(format:"%@: %@",cmodel.Name!,cmodel.replycontent!)
            if cmodel.bdate_time != "" {
                self.timeLabel.text = String(format: "%@-%@-%@ %@:%@", NSString.refreshYear(dateString: cmodel.bdate_time!),NSString.refreshMonth(dateString: cmodel.bdate_time!),NSString.refreshDay(dateString: cmodel.bdate_time!),NSString.refreshHour(dateString: cmodel.bdate_time!),NSString.refreshM(dateString: cmodel.bdate_time!))
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
