//
//  MsgDailyTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MsgDailyTCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var complete: UILabel!
    @IBOutlet weak var plan: UILabel!
    @IBOutlet weak var com: UILabel!
    @IBOutlet weak var pla: UILabel!
    @IBOutlet weak var attachIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = DarkTitleColor
        date.textColor = GrayTitleColor
        complete.textColor = GrayTitleColor
        plan.textColor = GrayTitleColor
        com.textColor = DeepDarkTitleColor
        pla.textColor = DeepDarkTitleColor
        
    }
    
    
    var logModel: HomeLogModel!{
        didSet{
//            avatar.setImageWithBase64String(imgStr: logModel.Photo, isAvatar: true)
            if logModel.Sex == "男" {
                avatar.image = LoadImage(avatarMale)
            }
            else{
                avatar.image = LoadImage(avatarFemale)
            }
            name.text = logModel.EINAME
            let ymd = logModel.BDATE?.components(separatedBy: " ").first!
            let hms = logModel.BDATE?.components(separatedBy: " ").last!
            let month = ymd?.components(separatedBy: "/")[1]
            let day = ymd?.components(separatedBy: "/")[2]
            var hm = hms?.substring(to: 5)
            if (hm?.hasSuffix(":"))! {
                hm = hm?.substring(to: 4)
            }
            date.text = "\(NSString.init(format: "%d", Int(month!)!))月\(NSString.init(format: "%d", Int(day!)!))日 \(hm!)"
            attachIcon.isHidden = logModel.AttachCount == "无" ? true : false
            plan.text = logModel.TomorrowPlan
            complete.text = logModel.TodayPlan
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
