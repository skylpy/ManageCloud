//
//  EmailDetailCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class EmailDetailCell: UITableViewCell {
    
/// 没有附件的时候 要隐藏
    @IBOutlet weak var lineView: UIView!
    /// 附件taleview
    var taleView:AttachmentTableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UIView!
    ///主题
    @IBOutlet weak var titleLB: UILabel!
    ///收件人
    @IBOutlet weak var receivederLB: UILabel!
    ///内容
    @IBOutlet weak var contextLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initTableView()
        selectionStyle = .none
        
    }

    func initTableView() {
        
        self.taleView = AttachmentTableView()
        taleView.frame = mainTableView.bounds
        taleView.width = KWidth
        /// 需要动态计算高度
        taleView.height = tableViewHeight.constant
        mainTableView.addSubview(taleView)
    }
    
    
    func setViewValue(model:MyEmailModel) {
        //主题
        self.titleLB.text = model.SUBJECT
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
            self.receivederLB.text = strShou
            
        }else {
            //只有一个收件人的时候
            var tempAry = model.SHOU!.components(separatedBy: "(")
            tempAry.remove(at: tempAry.count - 1)
            //收件人
            self.receivederLB.text = tempAry[0]
        }
        

        // 内容
        self.contextLB.text = model.MCONTENT
        if model.MCONTENT == "" {
            self.contextLB.text = "(无内容)"
            self.contextLB.font = UIFont.systemFont(ofSize: 13)
            self.contextLB.textColor = RGBA(r: 152, g: 152, b: 156, a: 1)
        }
        
        //附件
        let smodel:[AttachmentInfo] = model.Attachments!
        
        self.taleView.setViewValue(model: smodel)
        taleView.isHidden = false
        tableViewHeight.constant =  CGFloat(smodel.count * AttachmentCellRowHeight + 6)
        if smodel.count == 0 {
            tableViewHeight.constant = 0
            taleView.isHidden = true
            self.lineView.isHidden = true
        }
        self.layoutIfNeeded()
        //html 文本
        //        do{
//            let attrStr = try NSAttributedString(data: model.HTMLCONTENT!.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//
//            self.contextLB.attributedText = attrStr
//        }catch let error as NSError {
//            print(error.localizedDescription)
//        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
