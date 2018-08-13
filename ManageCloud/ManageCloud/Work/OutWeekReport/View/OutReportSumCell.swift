//
//  OutReportSumCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class OutReportSumCell: UITableViewCell {

    @IBOutlet weak var moneyLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(model:OutWeekTotalEntiesModel) {
        
        self.moneyLB.text = "¥" + model.ZCTOTAL!
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
