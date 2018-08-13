//
//  ApprovalInfoCell.swift
//  ManageCloud
//
//  Created by aaron on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApprovalInfoCell: UITableViewCell {
    
    //请假天数
    @IBOutlet weak var leaveDayLabel: UILabel!
    //开始时间
    @IBOutlet weak var starLabel: UILabel!
    //结束时间
    @IBOutlet weak var endLabel: UILabel!
    //备注
    @IBOutlet weak var remarksLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
