//
//  WeekReportIncomeMoneyCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/20.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class WeekReportIncomeMoneyCell: UITableViewCell {
    /// 数量合计
    @IBOutlet weak var countLB: UILabel!
    /// 金额合计
    @IBOutlet weak var moneyLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setViewValue(model:InWeelReporTotalModel){
        
        self.countLB.text = model.SLTOTAL!
        self.moneyLB.text = "¥" + model.JETOTAL!
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
