//
//  DailyReportMoneyCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/13.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class DailyReportMoneyCell: UITableViewCell {

    /// 收入
    @IBOutlet weak var incomeLB: UILabel!
    /// 支出
    @IBOutlet weak var payLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(model:DailyReporTotalModel){
        
        self.incomeLB.text = "¥" + model.SRTOTAL!
        self.payLB.text = "¥" + model.ZCTOTAL!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
