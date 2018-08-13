//
//  MyReceivedJournalCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MyReceivedJournalCell: UITableViewCell {
    
    @IBOutlet weak var headerView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var number: UIButton!
    var model = NSDictionary(){
        
        didSet {
            self.headerView.image = UIImage.init(named: "headPlaceHolder")

            self.titleLabel.text = model["Title"]! as! String
            
            if (model["REPLYCON"] as! String) != "" {
                self.contentLabel.text = String(format:"回复内容:%@",model["REPLYCON"]! as! CVarArg)
            }

            self.timeLabel.text = model["DayTime"] as! String
            self.number.setTitle(String(format:" %@",model["AttachCount"]! as! CVarArg), for: .normal)
            self.number.isHidden = (model["AttachCount"] as AnyObject).intValue == 0 ? true : false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerView.clipsToBounds = true
        self.headerView.layer.cornerRadius = 20
    }
}
