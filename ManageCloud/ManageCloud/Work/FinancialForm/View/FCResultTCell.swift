//
//  FCResultTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/1.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class FCResultTCell: UITableViewCell {

    @IBOutlet weak var LB: UILabel!
    @IBOutlet weak var Btn: UIButton!
    @IBOutlet weak var imgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        LB.textColor = DarkTitleColor
        LB.font = UIFont.init(fontName: kRegFont, size: 16)
    }
    
    var model: FCItem!{
        didSet{
            imgV.image = LoadImage(model.iconImg!)
            Btn.setImage(LoadImage(model.BtnImg!), for: .normal)
            LB.text = model.LBtext
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
