//
//  OutWeekReportCellTableViewCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class OutWeekReportCellTableViewCell: UITableViewCell {

    /// 科目名称
    @IBOutlet weak var subjectLB: UILabel!
    /// 金额
    @IBOutlet weak var moneyLB: UILabel!
    /// 支出次数
    @IBOutlet weak var payCount: UILabel!
    
    /// 科目编号
    var KMTID = " "
    /// 所选账户的编号
    var ZHTID = " "
    /// 开始时间
    var starTimes = " "
    /// 结束时间
    var endTimes = " "
    
    
    
    var nav:UINavigationController? = UINavigationController()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(model:OutWeekModel,starTime:String,endTime:String,accountID:String) {
        
        self.subjectLB.text = model.KMNAME
        self.moneyLB.text = model.AMOUNT
        self.payCount.text = model.NUMS
        
        self.KMTID = model.KMTID!
        self.ZHTID = accountID
        self.starTimes = starTime
        self.endTimes = endTime
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bntAction(_ sender: UIButton) {
        let vc = OutWeekReportDetailViewController()
        
        vc.KMTID = self.KMTID
        vc.ZHTID = self.ZHTID
        vc.starDateUI = self.starTimes
        vc.endDateUI = self.endTimes
        
        self.nav?.pushViewController(vc)
    }
    
}
