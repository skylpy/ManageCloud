//
//  ApplicationFlowMineCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApplicationFlowMineCell: UITableViewCell {

    let ingColor = RGBA(r: 102, g: 102, b: 102, a: 1)//灰色
    let sucColor = RGBA(r: 10, g: 195, b: 128, a: 1)//绿色
    let failColor = RGBA(r: 255, g: 59, b: 48, a: 1)//红色
    
    @IBOutlet weak var stateLB: UILabel!
    
    @IBOutlet weak var titleLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none

    }

    func setViewValue(model:ApplicationMineModel) {
        
        self.titleLB.text = model.DJNAME
        self.stateLB.text = model.GZLSTATE
        if model.GZLSTATE == "成功" {
            self.stateLB.textColor = sucColor
        }else if model.GZLSTATE == "失败"{
            self.stateLB.textColor = failColor
        }else {
            self.stateLB.textColor = ingColor
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
