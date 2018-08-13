//
//  ReportAcountCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/13.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ReportAcountCell: UITableViewCell {

    /// 账户
    @IBOutlet weak var accountLB: UILabel!
    /// 公司
    @IBOutlet weak var companyLB: UILabel!
    /// 余额
    @IBOutlet weak var moneyLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// 赋值
    func setViewValue(model:ReportAccountListModel){
        
        self.accountLB.text = model.ZHNAME
        self.companyLB.text = model.DNAME
        self.moneyLB.text = model.ZHBALANCE
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
