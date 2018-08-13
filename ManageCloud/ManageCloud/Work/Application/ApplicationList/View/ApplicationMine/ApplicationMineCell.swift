//
//  ApplicationMineCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

let ApplicationMineCellHeight = 52

class ApplicationMineCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowHeight: NSLayoutConstraint!
    
    var dateSource:[(section:String, list:[ApplicationMineModel])] = [(section:String, list:[ApplicationMineModel])]()
    
    @IBOutlet weak var changeBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = CGFloat(ApplicationMineCellHeight)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        setTableView()
        addNotification()
        changeBtn.setTitle(MineWorkFlowType, for: .normal)
    }

    func setTableView() {
        
        self.tableView.register(UINib.init(nibName: "ApplicationFlowMineCell", bundle: nil), forCellReuseIdentifier: "ApplicationFlowMineCell")
        
        self.tableView.register(UINib.init(nibName: "ApplicationFlowMineSection", bundle: nil), forHeaderFooterViewReuseIdentifier: "ApplicationFlowMineSection")
        
    }
    
    /// 选择类型
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dateSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dateSource[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ApplicationFlowMineCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationFlowMineCell") as! ApplicationFlowMineCell
        let model = self.dateSource[indexPath.section]
        let smodel = model.list[indexPath.row]
        cell.setViewValue(model: smodel)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell:ApplicationFlowMineSection = tableView.dequeueReusableCell(withIdentifier: "ApplicationFlowMineSection") as! ApplicationFlowMineSection
         let model = self.dateSource[section]
         let dateAry =  model.section.components(separatedBy: "/")
        
        
        let vc:ApplicationFlowMineSection = UIView.loadFromNib(named: "ApplicationFlowMineSection") as! ApplicationFlowMineSection
        
         vc.dayLB.text =  dateAry[2]
         vc.monthLB.text = "/" + dateAry[1] + "月"
        if section == 0 {
            vc.line.isHidden = true
        }else{
            vc.line.isHidden = false
        }
        return vc
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        
        return 43
    }
    
    /// 赋值
    func setViewValue(model:[(section:String, list:[ApplicationMineModel])],oldModel: [ApplicationMineModel]) {
        
        self.dateSource = model
        // 计算高度:  + count * ApplicationFlowMineCellHeight + 多少个 * ApplicationFlowMineSectionHeight
        self.tableViewHeight.constant =  CGFloat(oldModel.count * ApplicationMineCellHeight + model.count * ApplicationFlowMineSectionHeight)
        self.shadowHeight.constant = self.tableViewHeight.constant + 52
        
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
