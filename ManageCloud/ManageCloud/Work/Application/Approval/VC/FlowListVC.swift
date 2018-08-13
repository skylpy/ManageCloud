//
//  FlowListVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh

class FlowListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let normalCellID = "normalCellID"
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH))
        table.estimatedRowHeight = 0.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: normalCellID)
        table.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "选择工作流"
        view.backgroundColor = UIColor.white
        view.addSubview(Table)
    }
    
    @objc fileprivate func loadData() {
        
    }
    
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: normalCellID, for: indexPath)
        cell.textLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        cell.textLabel?.textColor = DarkTitleColor
        cell.textLabel?.text = "噢噢噢噢噢噢噢噢"
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
