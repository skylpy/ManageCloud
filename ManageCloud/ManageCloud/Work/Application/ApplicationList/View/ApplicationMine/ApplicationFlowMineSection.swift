//
//  ApplicationFlowMineSection.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

let ApplicationFlowMineSectionHeight = 43


class ApplicationFlowMineSection: UIView {

    @IBOutlet weak var line: UIView!
    /// 月
    @IBOutlet weak var monthLB: UILabel!
    /// 日
    @IBOutlet weak var dayLB: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.width = KWidth
    }

}
