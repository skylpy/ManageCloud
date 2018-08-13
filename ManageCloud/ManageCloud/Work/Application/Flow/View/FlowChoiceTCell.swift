//
//  FlowChoiceTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class FlowChoiceTCell: UITableViewCell {
    
    
    
    var model: FormControlModel!{
        didSet{
            if (model.Value?.isEmpty)!{
                model.Value = "false"
            }
            selectBtn.isSelected = model.isSelected
            titleLB.text = model.ControlName?.components(separatedBy: "-").first
            contentLB.text = model.TEXT
            if model.isFirst{
                headerView.isHidden = false
            }
            else{
                headerView.isHidden = true
            }
        }
    }

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var contentLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLB.textColor = GrayTitleColor
        contentLB.textColor = DarkTitleColor
        titleLB.font = UIFont.init(fontName: kRegFont, size: 18)
        contentLB.font = UIFont.init(fontName: kRegFont, size: 17)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
