//
//  ReportAccountMoneyCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/20.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ReportAccountMoneyCell: UITableViewCell {

    /// 公司名称
    @IBOutlet weak var companyLB: UILabel!
    /// 余额合计
    @IBOutlet weak var moneyLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(money:Double, company:String){
        
        self.companyLB.text = company
        self.moneyLB.text = String(format: "%.2f", money)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
