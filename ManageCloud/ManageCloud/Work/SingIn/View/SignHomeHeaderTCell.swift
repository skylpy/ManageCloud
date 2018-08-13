//
//  SignHomeHeaderTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class SignHomeHeaderTCell: UITableViewCell {

    @IBOutlet weak var mreLB: UILabel!
    @IBOutlet weak var signTitleLB: UILabel!
    @IBOutlet weak var dayLB: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        signTitleLB.textColor = DarkTitleColor
        dayLB.textColor = DarkTitleColor
        mreLB.textColor = GrayTitleColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
