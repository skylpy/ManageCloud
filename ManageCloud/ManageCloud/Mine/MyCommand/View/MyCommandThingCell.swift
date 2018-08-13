//
//  MyCommandThingCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MyCommandThingCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connentLabel: UILabel!
    
    var indexPath:NSIndexPath!
    
    
    var model = CommandDateilModel(){
        
        didSet {
            
            self.titleLabel.text = self.indexPath.row == 1 ? "执行事情: " : "具体事项: "
            self.connentLabel.text = self.indexPath.row == 1 ? model.perform_title : model.perform_content
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
