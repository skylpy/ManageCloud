//
//  ApprovalHeaderView.swift
//  ManageCloud
//
//  Created by aaron on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApprovalHeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func initRegister() -> UIView {
        
        return Bundle.main.loadNibNamed("ApprovalHeaderView", owner: nil, options: nil)?[0] as! ApprovalHeaderView
    }
    
}
