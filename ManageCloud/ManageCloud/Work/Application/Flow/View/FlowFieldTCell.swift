//
//  FlowFieldTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class FlowFieldTCell: UITableViewCell {
    
    var inputBlock:((String)->())?
    
    var model: FormControlModel!{
        didSet{
            if  model.AllowNullInput == "false" {
                field.placeholder = "请输入" + model.CFIELDNAME! + "(必填)"
            }
            else{
                field.placeholder = "请输入" + model.CFIELDNAME!
            }
            
        }
    }

    @IBOutlet weak var field: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        field.textColor = DeepDarkTitleColor
        field.font = UIFont.init(fontName: kRegFont, size: 17)
        field.addTarget(self, action: #selector(changeText), for: .editingChanged)
        
    }
    
    @objc fileprivate func changeText(_ textField: UITextField) {
        inputBlock!(textField.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
