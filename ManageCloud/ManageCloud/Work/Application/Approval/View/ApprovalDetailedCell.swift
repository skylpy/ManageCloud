//
//  ApprovalDetailedCell.swift
//  ManageCloud
//
//  Created by aaron on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApprovalDetailedCell: UITableViewCell {
    
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //内容
    @IBOutlet weak var connentLabel: UILabel!
    //部门
    @IBOutlet weak var defLabel: UILabel!
    //人员
    @IBOutlet weak var personLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
