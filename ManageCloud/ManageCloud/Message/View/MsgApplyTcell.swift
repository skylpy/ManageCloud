//
//  MsgApplyTcell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MsgApplyTcell: UITableViewCell {

    var isMine: Bool = false {
        didSet{
            if !isMine{
                applyBtn.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var detailLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.textColor = DarkTitleColor
        detailLB.textColor = GrayTitleColor
    }

    @IBAction func Apply(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
