//
//  WeekReportIncomeCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/20.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class WeekReportIncomeCell: UITableViewCell {

    /// 账户
    @IBOutlet weak var accountLB: UILabel!
    /// 公司
    @IBOutlet weak var companyLB: UILabel!
    /// 付款单位
    @IBOutlet weak var payCompanyLB: UILabel!
    /// 业务员
    @IBOutlet weak var salesman: UILabel!
    /// 产品名称
    @IBOutlet weak var productName: UILabel!
    /// 数量
    @IBOutlet weak var countLB: UILabel!
    /// 金额
    @IBOutlet weak var moneyLB: UILabel!
    /// 时间
    @IBOutlet weak var timeLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(model:WeekReportModel) {
        
        self.accountLB.text = model.ZHNAME
        self.companyLB.text = model.DNAME
        self.payCompanyLB.text = model.FKDW
        self.salesman.text = model.YWYNAME
        self.productName.text = model.MNAME
        self.countLB.text = model.QUANTITY
        self.moneyLB.text = model.AMOUNT
        
        self.timeLB.text = model.DZDATE
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
