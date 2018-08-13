//
//  MineTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MineTCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.textColor = DarkGrayTitleColor
        nameLB.font = UIFont.init(fontName: kRegFont, size: 16)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
