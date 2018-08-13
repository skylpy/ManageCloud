//
//  FlowPSelectTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/13.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class FlowPSelectTCell: UITableViewCell {
    
    var personModel: FlowStepPerson!{
        didSet{
            nameLB.text = personModel.PName
            selectBtn.isSelected = personModel.isSelete
        }
    }

    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var nameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.font = UIFont.init(fontName: kRegFont, size: 17)
        nameLB.textColor = DarkTitleColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
