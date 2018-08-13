//
//  EmailReceiptCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class EmailReceiptCell2: UITableViewCell {

    /// 是否已读： 值为10显示  0为隐藏
    @IBOutlet weak var isRead: NSLayoutConstraint!
    /// 是否已读： 未读值为10的距离  0为已读的距离
    @IBOutlet weak var nameLeft: NSLayoutConstraint!
    /// 附件数量
    @IBOutlet weak var attachmentCount: UIButton!
    /// 发件人
    @IBOutlet weak var fromNameLB: UILabel!
    /// 时间 or 发送中 状态
    @IBOutlet weak var timeLB: UILabel!
    /// 主题
    @IBOutlet weak var ttittleLB: UILabel!
    /// 内容
    @IBOutlet weak var concetextLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 手动点击取消未读状态
    func readCell() {
        self.isRead.constant = 0
        self.nameLeft.constant = 0
    }
    
    /// 赋值
    func setViewValue(model:MyEmailModel) {
        
        if model.READ == "0" {//未读
            self.isRead.constant = 10
            self.nameLeft.constant = 10
        }else {
            self.isRead.constant = 0
            self.nameLeft.constant = 0
        }
        
        if EmailListShowType[0] == "发件箱" {
            self.isRead.constant = 0
            self.nameLeft.constant = 0
        }
        
        //发件人
        fromNameLB.text = model.FromName
        
        if EmailListShowType[0] == "发件箱" {
            
            //采购购(15),CC1(21),ccc(6),测试人员1w(7),李清立(22),
            var ary = model.SHOU?.components(separatedBy: ",")
            
            var strShou = " "
            
            if (ary?.count)! >= 2 {
                ary!.remove(at: (ary!.count - 1))
                for (index,item) in (ary?.enumerated())! {
                    
                    var tempAry = item.components(separatedBy: "(")
                    tempAry.remove(at: tempAry.count - 1)
                    for item in tempAry{
                        strShou = strShou + item + "、"
                    }
                    
                }
                strShou.remove(at: strShou.index(before: strShou.endIndex))
                //收件人
                fromNameLB.text = strShou
                
            }else {
                if model.SHOU! == "" {
                    return
                }
                
                //只有一个收件人的时候
                var tempAry = model.SHOU!.components(separatedBy: "(")
                tempAry.remove(at: tempAry.count - 1)
                //收件人
                self.fromNameLB.text = tempAry[0]
            }
            
        }
        //附件数量
        if model.Attachments?.count == 0 {
            attachmentCount.isHidden = true
        }else{
            attachmentCount.isHidden = false
            let cont:String =  (model.Attachments?.count.string)!
            attachmentCount.setTitle(cont, for: .normal)
        }
        
        var timeStr = " "
        //时间 2018/5/23 11:49:00
        let ary = model.SENT?.components(separatedBy: " ")
        let dateAry = ary![0].components(separatedBy: "/")
        // 转成两位数的月 日
        let month = NSString.init(format:"%02d",dateAry[1].intValue)
        let day = NSString.init(format:"%02d",dateAry[2].intValue)
        
        if ary?.count != 0 {
            let timeAry = ary?.last!.components(separatedBy: ":")
             let nowTime =  DateFormatTools.instance.getNowYearMonthDay()
            
            if nowTime == (dateAry[0] + "/" + (month as String) + "/" + (day as String)){
                // 今日显示 12:12
                timeStr = timeStr + timeAry![0] + ":" + timeAry![1]
            }else {
                
                timeStr = (month as String) + "/" + (day as String)
            }
        }
        
        self.timeLB.text = timeStr
        //主题
        self.ttittleLB.text = model.SUBJECT
        //内容
        self.concetextLB.text = model.MCONTENT
        if model.MCONTENT == "" {
            self.concetextLB.text = "(无内容)"
            self.concetextLB.font = UIFont.systemFont(ofSize: 13)
            self.concetextLB.textColor = RGBA(r: 152, g: 152, b: 156, a: 1)
        }
        
//        do{
//            let attrStr = try NSAttributedString(data: model.HTMLCONTENT!.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//
//            self.concetextLB.attributedText = attrStr
//        }catch let error as NSError {
//            print(error.localizedDescription)
//        }
    }
    
}
