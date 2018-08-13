//
//  MsgOrderTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

enum OrderType {
    case OrderA //重要并紧急  253 0 70
    case OrderB //紧急不重要 252 161 62
    case OrderC //重要不紧急 115 186 65
    case OrderD //不重要不紧急 153 153 153
}

class MsgOrderTCell: UITableViewCell {
    
    @IBOutlet weak var detailLB: UILabel!
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    var type: OrderType = .OrderA

    override func awakeFromNib() {
        super.awakeFromNib()
        typeLB.textColor = UIColor.white
        detailLB.textColor = DarkTitleColor
        timeLB.textColor = GrayTitleColor
        
        
        //
        typeLB.backgroundColor = COLOR(red: 253, green: 0, blue: 70)
    }
    
    var model: AddCommandModel!{
        didSet{
            let ymd = model.bdate_time!.components(separatedBy: " ").first!
            let hms = model.bdate_time!.components(separatedBy: " ").last!
            let month = ymd.components(separatedBy: "/")[1]
            let day = ymd.components(separatedBy: "/")[2]
            var hm = hms.substring(to: 5)
            if hm.hasSuffix(":") {
                hm = hm.substring(to: 4)
            }
            let timeString = "\(NSString.init(format: "%d", Int(month)!))月\(NSString.init(format: "%d", Int(day)!))日 \(hm)"
            timeLB.text = "发送人：\(model.Name!) • \(timeString)"
            detailLB.text = model.perform_title!
            if model.state == "不紧急不重要" {
                typeLB.backgroundColor = GrayTitleColor
            }
            else if model.state == "紧急不重要"{
                typeLB.backgroundColor = COLOR(red: 253, green: 161, blue: 62)
            }
            else if model.state == "重要并紧急"{
                typeLB.backgroundColor = COLOR(red: 253, green: 0, blue: 70)
            }
            else if model.state == "重要不紧急"{
                typeLB.backgroundColor = COLOR(red: 115, green: 186, blue: 65)
            }
            typeLB.text = model.state
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
