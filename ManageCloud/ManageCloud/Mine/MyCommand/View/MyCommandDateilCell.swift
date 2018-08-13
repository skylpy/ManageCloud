//
//  MyCommandDateilCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MyCommandDateilCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var model = CommandDateilModel(){
        
        didSet {
            
            if model.Sex == "男" {
                self.headerImage.image = UIImage.init(named: avatarMale)
            }else {
                self.headerImage.image = UIImage.init(named: avatarFemale)
            }
            if model.Name != nil {
                if model.isReply == "是" || model.isReply == "需回复" || model.isReply == "是：需回复" {
                    self.titleLabel.text = String(format:"%@下达的指挥信息 (需回复)",model.Name!)
                }else {
                    self.titleLabel.text = String(format:"%@下达的指挥信息 (仅通知)",model.Name!)
                }
                
            }

            if (model.state?.isEqual("不重要不紧急"))! {
                
                self.iconImage.image = UIImage.init(named: "level_four")
            }else if (model.state?.isEqual("紧急不重要"))!{
                
                self.iconImage.image = UIImage.init(named: "level_two")
            }else if (model.state?.isEqual("重要并紧急"))! {
                
                self.iconImage.image = UIImage.init(named: "level_one")
            }else {
                
                self.iconImage.image = UIImage.init(named: "level_three")
            }
        
            if model.bdate_time != "" {
                self.timeLabel.text = NSString.refreshYMDHmTime(time: model.bdate_time!)
            }
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerImage.layer.cornerRadius = 25
        self.headerImage.clipsToBounds = true
    }
}

extension NSString {
    
    class func refreshYMDhmTime(time:String,format:String) -> String {
        
        return String(format: "%@%@%@%@%@ %@:%@",NSString.refreshYear(dateString: time),format,NSString.refreshMonth(dateString: time),format,NSString.refreshDay(dateString: time),NSString.refreshHour(dateString: time),NSString.refreshM(dateString: time))
    }
    
    class func refreshYMDTime(time:String) -> String {

        return String(format: "%@-%@-%@",NSString.refreshYear(dateString: time),NSString.refreshMonth(dateString: time),NSString.refreshDay(dateString: time))
    }
    
    class func refreshYMDHmTime(time:String) -> String {
        
        return String(format: "%@年%@月%@日 %@:%@",NSString.refreshYear(dateString: time),NSString.refreshMonth(dateString: time),NSString.refreshDay(dateString: time),NSString.refreshHour(dateString: time),NSString.refreshM(dateString: time))
    }
    
    class func refreshYear(dateString:String) -> String{
        
        let dayCommitString = dateString.components(separatedBy: " ").first!
        
        let dayArray = dayCommitString.components(separatedBy: "/")
        
        let year:String = dayArray[0]
        
        return year
    }
    
    class func refreshMonth(dateString:String) -> String{
        
        let dayCommitString = dateString.components(separatedBy: " ").first!
        
        let dayArray = dayCommitString.components(separatedBy: "/")
        
        let year:String = dayArray[1]
        
        return year
    }
    
    class func refreshDay(dateString:String) -> String{
        
        let dayCommitString = dateString.components(separatedBy: " ").first!
        
        let dayArray = dayCommitString.components(separatedBy: "/")
        
        let year:String = dayArray[2]
        
        return year
    }
    
    class func refreshHour(dateString:String) -> String{
        
        let dayCommitString = dateString.components(separatedBy: " ").last!
        
        let dayArray = dayCommitString.components(separatedBy: ":")
        
        let year:String = dayArray[0]
        
        return year
    }
    
    class func refreshM(dateString:String) -> String{
        
        let dayCommitString = dateString.components(separatedBy: " ").last!
        
        let dayArray = dayCommitString.components(separatedBy: ":")
        
        let year:String = dayArray[1]
        
        return year
    }
    
    class func refreshS(dateString:String) -> String{
        
        let dayCommitString = dateString.components(separatedBy: " ").last!
        
        let dayArray = dayCommitString.components(separatedBy: ":")
        
        let year:String = dayArray[2]
        
        return year
    }
}

extension NSArray {
    
    class func refreshDay(dateString:String) -> NSArray{
        
        let dayCommitString = dateString.components(separatedBy: " ").first!
        
        let dayArray = dayCommitString.components(separatedBy: "/")
        
        return dayArray as NSArray
    }
    
    class func refreshTime(dateString:String) -> NSArray{
        
        let timeCommitString = dateString.components(separatedBy: " ").last
        
        let timeArray = timeCommitString?.components(separatedBy: ":")
        
        return timeArray as! NSArray
    }
}
