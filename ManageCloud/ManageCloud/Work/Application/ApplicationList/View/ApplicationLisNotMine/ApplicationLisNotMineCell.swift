//
//  ApplicationLisNotMineCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

/// 有数据的工作流和无数据的工作流要统一显示
let NotificationName_ShareMineWorkType = "NotificationName_ShareMineWorkType"


class ApplicationLisNotMineCell: UITableViewCell {

    @IBOutlet weak var changeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addNotification()
        changeBtn.setTitle(MineWorkFlowType, for: .normal)
    }

    @IBAction func changeType(_ sender: UIButton) {
        
         let alert =  UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(title: "全部", style: .default, isEnabled: true) { (action) in
            
            sender.setTitle("全部", for: .normal)
            MineWorkFlowType = "全部"
        }
        
        alert.addAction(title: "成功", style: .default, isEnabled: true) { (action) in
            
            sender.setTitle("成功", for: .normal)
            MineWorkFlowType = "成功"
        }
        
        alert.addAction(title: "失败", style: .default, isEnabled: true) { (action) in
            
            sender.setTitle("失败", for: .normal)
            MineWorkFlowType = "失败"
        }
        
        let action = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        let cancelStr = NSMutableAttributedString.init(string: "取消")
        cancelStr.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: UIFont.systemFont(ofSize: 20), range: NSRange.init(location:0, length: cancelStr.length))
        action.setValue(RGBA(r: 51, g: 51, b: 51, a: 0.9), forKey: "titleTextColor")
        
        alert.addAction(action)
        alert.show()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //监听
    func addNotification() {
        
        let notificationName = Notification.Name(rawValue: NotificationName_ShareMineWorkType)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(shareType(notification:)),
                                               name: notificationName, object: nil)
        
    }
    
    @objc func shareType(notification: Notification) {
       
        changeBtn.setTitle(MineWorkFlowType, for: .normal)
    }
    
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
}
