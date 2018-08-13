//
//  FlowListVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh
let normalCellID = "normalCellID"

class FlowListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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

    var data:[FlowListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "选择工作流"
        view.backgroundColor = UIColor.white
        view.addSubview(Table)
        Table.mj_header.beginRefreshing()
    }
    
    @objc fileprivate func loadData() {
        WorkFlowVM.loadFlowList(sucBlock: { (listArr) in
            self.Table.mj_header.endRefreshing()
            self.data = listArr
            self.Table.reloadData()
        }) { (resFail) in
            self.Table.mj_header.endRefreshing()
        }
    }
    
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: normalCellID, for: indexPath)
        cell.textLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        cell.textLabel?.textColor = DarkTitleColor
        cell.textLabel?.text = data[indexPath.row].Name
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AddFromVC()
        vc.BTid = data[indexPath.row].Tid!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
