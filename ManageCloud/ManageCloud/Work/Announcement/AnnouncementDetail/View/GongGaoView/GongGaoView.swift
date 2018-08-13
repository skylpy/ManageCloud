//
//  GongGaoView.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class GongGaoView: UIView {

    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var tittleLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!

    
    override func awakeFromNib() {
        
    }
    
    /// 赋值
    func setViewValue(model: [AnnouncementModel], tableView:UITableView)  {
        
        let smodel:AnnouncementModel = model[0] 
        
        self.tittleLB.text = smodel._subject
        
        // 2018/5/25 16:28:12
        let ary = smodel._bdate?.components(separatedBy: " ")
        let dateAry = ary![0].components(separatedBy: "/")
        // 转成两位数的月 日
        let month = NSString.init(format:"%02d",dateAry[1].intValue)
        let day = NSString.init(format:"%02d",dateAry[2].intValue)
        
         let timeAry = ary?.last!.components(separatedBy: ":")
        
        let tempStr = NSString.init(format:"%@年%@月%@日 %@:%@",dateAry[0],month,day,timeAry![0],timeAry![1])
        self.timeLB.text = smodel._person! + "  " + (tempStr as String)
        self.contentLB.text = smodel.wContent
        
        ///计算高度  head:74 + 动态内容
        self.height = 74.0  +  self.contentLB.calculateHeight()
        tableView.tableHeaderView?.height = self.height + 20
        //tableView.reloadData()
    }

}
