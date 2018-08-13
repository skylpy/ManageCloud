//
//  SignInSearchView.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/13.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class SignInSearchView: UIView {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tipsLB: UILabel!
    
    var count: String = ""{
        didSet{
            let tips: NSString = "共找到\(count)个结果，输入全称获取更精准结果" as NSString
            let tipsAtt = NSAttributedString.init(string: tips as String)
            let NewTips = tipsAtt.foregroundColor(BlueColor, range: tips.range(of: count))
            tipsLB.attributedText = NewTips
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipsLB.textColor = GrayTitleColor
    }
    

}
