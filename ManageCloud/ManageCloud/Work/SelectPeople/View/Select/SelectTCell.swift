//
//  SelectTCell.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class SelectTCell: UITableViewCell {
    
    //单选、多选
    var type: selectType = .single

    @IBOutlet weak var avatarLeading: NSLayoutConstraint!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var depLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.textColor = DarkTitleColor
        depLB.textColor = GrayTitleColor
    }
    
    
    var personModel: personModel!{
        didSet{
            nameLB.text = personModel.EINAME
            depLB.text = personModel.DeptName
            avatar.setImageWithBase64String(imgStr: personModel.Photo ?? "", isAvatar: true)
            if personModel.Sex == "男" {
                avatar.image = LoadImage(avatarMale)
            }
            else{
                avatar.image = LoadImage(avatarFemale)
            }
            selectBtn.isSelected = personModel.isSelete
            switch type {
            case .single:
                avatarLeading.constant = 16
                selectBtn.isHidden = true
            default:
                avatarLeading.constant = 46
                selectBtn.isHidden = false
            }
        }
    }
    
    var signModel: SignPersonListModel!{
        didSet{
            nameLB.text = signModel.Name
            depLB.text = "今日签到次数：" + signModel.num! + "次"
//            avatar.setImageWithBase64String(imgStr: signModel.Photo ?? "", isAvatar: true)
            if signModel.Sex == "男" {
                avatar.image = LoadImage(avatarMale)
            }
            else{
                avatar.image = LoadImage(avatarFemale)
            }
            avatarLeading.constant = 16
            selectBtn.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
