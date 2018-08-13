//
//  JournalPaneCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class JournalPaneCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var conentLabel: UILabel!
    
    var indexPath:NSIndexPath!
    
    
    var model = JournalDateilModel(){
        
        didSet {
            self.titleLabel.text = self.indexPath.row == 0 ? "今日完成的工作":"明天计划的工作"
            self.conentLabel.text = self.indexPath.row == 0 ? model.TodayPlan:model.TomorrowPlan
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
