//
//  ApprovalProgressCell.swift
//  ManageCloud
//
//  Created by aaron on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApprovalProgressCell: UITableViewCell {
    
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //审批状态
    @IBOutlet weak var approvalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
