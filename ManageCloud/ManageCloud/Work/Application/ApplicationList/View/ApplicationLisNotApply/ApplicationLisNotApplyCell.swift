//
//  ApplicationLisNotApplyCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApplicationLisNotApplyCell: UITableViewCell {

    override func draw(_ rect: CGRect) {
        
        let maskPath = UIBezierPath(roundedRect: rect,
                                    
                                    byRoundingCorners: .allCorners,
                                    
                                    cornerRadii: CGSize(width: 8, height: 8))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
