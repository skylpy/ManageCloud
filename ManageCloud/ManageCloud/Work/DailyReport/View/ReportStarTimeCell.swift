//
//  ReportStarTimeCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/13.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ReportStarTimeCell: UITableViewCell {

    @IBOutlet weak var timeLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeLB.text = DateFormatTools.instance.getNowYearMonthDay2()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
