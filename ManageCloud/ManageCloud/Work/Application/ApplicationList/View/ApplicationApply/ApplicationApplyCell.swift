//
//  ApplicationApplyCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

let ApplyCellHeight = 60

class ApplicationApplyCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    
    /// tableView的动态高度
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shadowHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var dateSource:[ApplicationModel] = [ApplicationModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = CGFloat(ApplyCellHeight)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        setTableView()
    }

    func setTableView() {
        
        tableView.register(UINib.init(nibName: "ApplyTableViewCell", bundle: nil), forCellReuseIdentifier: "ApplyTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dateSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model =  self.dateSource[indexPath.row]
        let cell:ApplyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApplyTableViewCell") as! ApplyTableViewCell
        cell.setViewValue(model: model)
        return cell
    }
    
    
    func setViewValue(model:[ApplicationModel]) {
        self.dateSource = model
        // 计算高度:  + count * ApplyCellHeight
        self.tableViewHeight.constant = CGFloat( model.count * ApplyCellHeight)
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
        self.shadowHeight.constant = self.tableViewHeight.constant + 50
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
