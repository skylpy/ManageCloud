//
//  ApplyTableViewCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApplyTableViewCell: UITableViewCell {

    /// 审批内容
    @IBOutlet weak var contextLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none

    }
    
    func setViewValue(model:ApplicationModel) {
        
        self.contextLB.text = model.DJNAME
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 审批点击事件
    @IBAction func selectApply(_ sender: UIButton) {
        
        
    }
    
}
