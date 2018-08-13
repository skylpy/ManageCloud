//
//  AnnouncementCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class AnnouncementCell: UITableViewCell {

    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(model:AnnouncementModel) {
        
        self.titleLB.text = model._subject
        self.contentLB.text = model.wContent
        
        // 2018/5/25 16:28:12
        let ary = model._bdate?.components(separatedBy: " ")
        let dateAry = ary![0].components(separatedBy: "-")
        // 转成两位数的月 日
        let month = NSString.init(format:"%02d",dateAry[1].intValue)
        let day = NSString.init(format:"%02d",dateAry[2].intValue)
        
        let timeAry = ary?.last!.components(separatedBy: ":")
        
        let tempStr = NSString.init(format:"%@年%@月%@日 %@:%@",dateAry[0],month,day,timeAry![0],timeAry![1])
        self.timeLB.text = model._person! + "  " + (tempStr as String)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
