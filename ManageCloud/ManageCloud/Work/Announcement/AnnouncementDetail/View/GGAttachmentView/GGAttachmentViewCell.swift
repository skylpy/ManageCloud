//
//  GGAttachmentViewCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class GGAttachmentViewCell: UITableViewCell {

    @IBOutlet weak var tittleLB: UILabel!
    /// 下载中 蓝色57,152,245  黑色：51,51,51
    @IBOutlet weak var stateLB: UILabel!
    @IBOutlet weak var bgPro: UIView!
    @IBOutlet weak var pro: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewValue(model:AttachmentModel) {
       
        
        let size = FileTools.stringWithFileSize(size:  model.FileLen.double()!)
        self.tittleLB.text = model.DisplayName! +  "(" + size + ")"
        
        //计算进度条  pro.width = 百分比 * bgPro.width
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
