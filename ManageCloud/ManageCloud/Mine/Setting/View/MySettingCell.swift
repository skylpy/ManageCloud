//
//  MySettingCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MySettingCell: UITableViewCell {

    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var arrowIMG: UIImageView!
    @IBOutlet weak var rightTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
