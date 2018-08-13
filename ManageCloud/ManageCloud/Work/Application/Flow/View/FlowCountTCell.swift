//
//  FlowCountTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class FlowCountTCell: UITableViewCell {

    var inputBlock:((String)->())?
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var contentField: UITextField!
    
    var model: FormControlModel!{
        didSet{
            if  model.AllowNullInput == "false" {
                nameLB.text = model.CFIELDNAME! + "(必填)"
            }
            else{
                nameLB.text = model.CFIELDNAME!
            }
            contentField.placeholder = "请输入" + model.CFIELDNAME!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.textColor = GrayTitleColor
        contentField.textColor = DarkTitleColor
        nameLB.font = UIFont.init(fontName: kRegFont, size: 17)
        contentField.font = UIFont.init(fontName: kRegFont, size: 17)
        contentField.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc fileprivate func changeText(_ textField: UITextField) {
        inputBlock!(textField.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
