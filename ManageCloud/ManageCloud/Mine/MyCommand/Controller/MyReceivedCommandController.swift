//
//  MyReceivedCommandController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
import MJRefresh

class MyReceivedCommandController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var oid:String!
    
    lazy var dataArray:NSMutableArray = {
        
        let array = NSMutableArray()
        
        return array
    }()
    
    let MyReceiveCommandCellID = "MyReceiveCommandCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        self.table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.requestLoad()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.table.mj_header.beginRefreshing()
    }
    
    func requestLoad() -> () {
        
        CommandModel.receiveCommantListRequest(OID: self.oid, successBlock: { (list) in
            self.table.mj_header.endRefreshing()
            self.dataArray.removeAllObjects()
            if list != nil{
                self.dataArray.addObjects(from: list!)
            }
            
            self.table.reloadData()
        }) { (error) in
            self.table.mj_header.endRefreshing()
        }
    }
    
    func setTableView() {
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.tableFooterView = UIView()
        self.table.backgroundColor = UIColor.color(string: "#F2F2F6")
        self.table.register(UINib.init(nibName: "MyReceiveCommandCell", bundle: nil), forCellReuseIdentifier: MyReceiveCommandCellID)
        
    }
}

extension MyReceivedCommandController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyReceiveCommandCell = tableView.dequeueReusableCell(withIdentifier: MyReceiveCommandCellID, for: indexPath) as! MyReceiveCommandCell
        let model:AddCommandModel = self.dataArray[indexPath.section] as! AddCommandModel
        cell.model = model
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:AddCommandModel = self.dataArray[indexPath.section] as! AddCommandModel
        let vc:WorkCommandDateilController = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "WorkCommandDateil") as! WorkCommandDateilController
        vc.oid = model.pk_id
        vc.userid = MyOid()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
