//
//  ApproveTableTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import GrowingTextView

class ApproveTableTCell: UITableViewCell, GrowingTextViewDelegate {
    
    @IBOutlet weak var contentLB: UILabel!
    
    @IBOutlet weak var nameLB: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.textColor = DarkGrayTitleColor
        contentLB.textColor = DarkTitleColor
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
