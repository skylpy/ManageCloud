//
//  SendTitleCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class SendTitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectlabel: UILabel!
    
    var model = SendJournalInit(){
        
        didSet{
           
            self.titleLabel?.attributedText = NSAttributedString.allConentStr(model.title!, withAttStr: "*")

            self.selectlabel.text = model.conent
            
            self.selectlabel.textColor = (model.conent?.isEqual("未选择" ))! ? UIColor.init(hex: "#98989C") : UIColor.init(hex: "#333333")
        }
    }
    
    var addModel = AddCommandInit(){
        
        didSet{
            
            self.titleLabel?.attributedText = NSAttributedString.allConentStr(addModel.title!, withAttStr: "*")
            self.selectlabel.text = addModel.conent
            
            self.selectlabel.textColor = (addModel.conent?.isEqual("未选择"))! ? UIColor.init(hex: "#98989C") : UIColor.init(hex: "#333333")
        }
    }
    
    func attributedStr(YStr:String,GStr:String) -> NSAttributedString {
        //字体颜色

        let noteStr = NSMutableAttributedString.init(string: YStr)
        let nsRange = NSRange(location: 0, length: 1)
        noteStr.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: UIColor.red, range: nsRange)
        
        return noteStr
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
