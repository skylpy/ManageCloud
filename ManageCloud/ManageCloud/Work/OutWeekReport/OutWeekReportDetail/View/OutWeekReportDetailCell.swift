//
//  OutWeekReportDetailCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class OutWeekReportDetailCell: UITableViewCell {

    /// 账户
    @IBOutlet weak var accountLB: UILabel!
    /// 支出日期
    @IBOutlet weak var payDateLB: UILabel!
    /// 所属公司
    @IBOutlet weak var payCompanyLB: UILabel!
    /// 供应商
    @IBOutlet weak var salesman: UILabel!
    /// 产品编号
    @IBOutlet weak var productNum: UILabel!
    /// 产品名称
    @IBOutlet weak var productName: UILabel!
    /// 科目
    @IBOutlet weak var subjectLB: UILabel!
    /// 数量
    @IBOutlet weak var countLB: UILabel!
    /// 金额
    @IBOutlet weak var moneyLB: UILabel!
    /// 制单人
    @IBOutlet weak var maekerLB: UILabel!
    /// 制单部门
    @IBOutlet weak var makeDeparkmentLB: UILabel!
    /// 制单日期
    @IBOutlet weak var maekDateLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setViewValue(model:OutWeekReportDetailModel) {
        
        self.accountLB.text = model.ZHNAME
        self.payCompanyLB.text = model.DNAME
        self.salesman.text = model.GYSNAME
        self.productNum.text = model.MTID
        self.productName.text = model.MNAME
        self.subjectLB.text = model.KMNAME
        self.countLB.text = model.QUANTITY
        self.moneyLB.text = model.AMOUNT
        self.maekerLB.text = model.EINAME
        self.makeDeparkmentLB.text = model.ZDNAME
        
        
        var tempAry =  model.DZDATE!.components(separatedBy: " ")
        let timeAry = tempAry[0].components(separatedBy: "/")
        self.payDateLB.text = timeAry[0] + "-" + timeAry[1] + "-" + timeAry[2]
        
        var tempAry2 =  model.BDATE!.components(separatedBy: " ")
        let timeAry2 = tempAry2[0].components(separatedBy: "/")
        self.maekDateLB.text = timeAry2[0] + "-" + timeAry2[1] + "-" + timeAry2[2]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
