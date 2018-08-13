//
//  EndApplicationListViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh

class EndApplicationListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // 列表数据
    var applicationSource:[ApplicationModel] = [ApplicationModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "已审批"
        setTableView()
        
        self.initDate()
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.initDate()
        })
        
        self.tableView.tableFooterView = UIView()
    }
    
    //MARK: 数据请求
    func initDate() {
        
        let vm = EndApplicationVM()
        vm.askForEndApplicationList({ (modelAry) in
            
            self.applicationSource = modelAry
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            
        }) { (fail) in
            self.tableView.mj_header.endRefreshing()
            
        }
    }
    
    func setTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 113
        
        self.tableView.register(UINib.init(nibName: "EndApplicationListViewCell", bundle: nil), forCellReuseIdentifier: "EndApplicationListViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.applicationSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.applicationSource[indexPath.row]
        
        let cell:EndApplicationListViewCell = tableView.dequeueReusableCell(withIdentifier: "EndApplicationListViewCell") as! EndApplicationListViewCell
        cell.setViewValue(model: model)
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
