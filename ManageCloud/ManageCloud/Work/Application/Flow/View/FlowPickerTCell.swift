//
//  FlowPickerTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class FlowPickerTCell: UITableViewCell {
    
    var selectBlock:(()-> ())?

    @IBOutlet weak var nameLB: UILabel!

    @IBOutlet weak var contentLB: UILabel!
    
    var content:String!{
        didSet{
            if content.isEmpty{
                contentLB.text = "未选择"
                contentLB.textColor = GrayTitleColor
            }
            else{
                contentLB.text = content
                contentLB.textColor = DarkTitleColor
            }
        }
    }
    
    
    var model: FormControlModel!{
        didSet{
            if  model.AllowNullInput == "false" {
                nameLB.text = model.CFIELDNAME! + "(必选)"
            }
            else{
                nameLB.text = model.CFIELDNAME!
            }
            content = model.Value
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.textColor = DarkGrayTitleColor
        content = ""
        nameLB.font = UIFont.init(fontName: kRegFont, size: 17)
        contentLB.font = UIFont.init(fontName: kRegFont, size: 17)
    }
    
    @IBAction func selectMore(_ sender: UIButton) {
        selectBlock!()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
