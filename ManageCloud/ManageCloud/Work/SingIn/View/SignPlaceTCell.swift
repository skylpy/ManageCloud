//
//  SignPlaceTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class SignPlaceTCell: UITableViewCell {

    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var companyName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        companyName.textColor = DeepDarkTitleColor
        Address.textColor = GrayTitleColor
    }
    
    
    var highLightText: String = ""{
        didSet{
            let text: NSString = highLightText as NSString
            if let name = companyName.text {
                let nameS = NSString.init(string: name)
                let nameRange: NSRange = nameS.range(of: text as String)
                if nameRange.length != 0 {
                    var nameAtt: NSAttributedString = NSAttributedString.init(string: name)
                    nameAtt = nameAtt.foregroundColor(BlueColor, range: nameRange)
                    companyName.attributedText = nameAtt
                }
            }
            if let address = Address.text{
                let addressS = NSString.init(string: address)
                let addressRange: NSRange = addressS.range(of: text as String)
                if addressRange.length != 0 {
                    var addressAtt: NSAttributedString = NSAttributedString.init(string: address)
                    addressAtt = addressAtt.foregroundColor(BlueColor, range: addressRange)
                    Address.attributedText = addressAtt
                }
            }
            
            
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
