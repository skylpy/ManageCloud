//
//  MsgPeopleCCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MsgPeopleCCell: UICollectionViewCell {
    
    var isChoose: Bool = false{
        didSet{
            if isChoose{
                button.setTitleColor(BlueColor, for: .normal)
                button.backgroundColor = UIColor.white
            }
            else{
                button.setTitleColor(DeepDarkTitleColor, for: .normal)
                button.backgroundColor = UIColor.clear
            }
        }
    }

    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        
    }

}
