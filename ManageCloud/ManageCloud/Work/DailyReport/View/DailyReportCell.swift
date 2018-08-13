//
//  DailyReportCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/13.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class DailyReportCell: UITableViewCell {

    /// 账户
    @IBOutlet weak var accountLB: UILabel!
    /// 公司
    @IBOutlet weak var companyLB: UILabel!
    /// 到账日期
    @IBOutlet weak var endDateLB: UILabel!
    /// 摘要
    @IBOutlet weak var pickLB: UILabel!
    /// 类型
    @IBOutlet weak var typeLB: UILabel!
    /// 科目名称
    @IBOutlet weak var subjectLB: UILabel!
    /// 收入
    @IBOutlet weak var incomeLB: UILabel!
    /// 支付
    @IBOutlet weak var payLB: UILabel!
    /// 结余
    @IBOutlet weak var balanceLB: UILabel!
    /// 制单日期
    @IBOutlet weak var makeDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(model:DailyReportModel) {
        
        self.accountLB.text = model.ZHNAME
        self.companyLB.text = model.DNAME
        self.endDateLB.text = model.DZDATE
        self.pickLB.text = model.DESCR
        self.typeLB.text = model.MONEYTYPE
        self.subjectLB.text = model.KEMUNAME
        self.incomeLB.text = model.SRAMOUNT
        self.payLB.text = model.ZCAMOUNT
        self.balanceLB.text = model.SURPLUS
        self.makeDate.text = model.BDATE
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
