//
//  EndApplicationListViewCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class EndApplicationListViewCell: UITableViewCell {

    /// 标题
    @IBOutlet weak var titleLB: UILabel!
    /// 创建时间
    @IBOutlet weak var creatTime: UILabel!
    /// 审批状态
    @IBOutlet weak var flowStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setViewValue(model:ApplicationModel){
        let dateStr = model.UPTIMESET?.replacingOccurrences(of: ["/"], with: "-")
        self.titleLB.text = model.DJNAME
        self.creatTime.text = model.EINAME! + "创建于 " + dateStr!
        self.flowStateLabel.text =  "我的审批:" + model.FJTYPE!
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
