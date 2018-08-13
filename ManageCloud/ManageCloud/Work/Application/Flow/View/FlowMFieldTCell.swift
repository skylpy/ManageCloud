//
//  FlowMFieldTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import GrowingTextView

class FlowMFieldTCell: UITableViewCell, GrowingTextViewDelegate, UITextViewDelegate {
    
    var inputBlock:((String)->())?
    var heightBlock:((CGFloat)->())?
    
    var model: FormControlModel!{
        didSet{
            if  model.AllowNullInput == "false" {
                nameLB.text = model.CFIELDNAME! + "(必填)"
            }
            else{
                nameLB.text = model.CFIELDNAME!
            }
            contentText.placeholder = "请输入" + model.CFIELDNAME!
            contentText.text = model.Value!
        }
    }

    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var contentText: GrowingTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.textColor = DarkGrayTitleColor
        contentText.textColor = DarkTitleColor
        nameLB.font = UIFont.init(fontName: kRegFont, size: 18)
        contentText.font = UIFont.init(fontName: kRegFont, size: 17)
//        contentText.isScrollEnabled = false
        contentText.delegate = self
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        heightBlock!(height)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        inputBlock!(textView.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
