//
//  MySendJournalController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
import MJRefresh

class MySendJournalController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    let MyJournalCellID = "MyJournalCellID"
    var oid:String!
    
    
    lazy var dataArray:NSMutableArray = {
        
        let array = NSMutableArray()
        
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        self.table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.requestLoad()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.table.mj_header.beginRefreshing()
    }
    
    func setTableView() {
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.separatorStyle = .none
        self.table.tableFooterView = UIView()
        
        self.table.register(UINib.init(nibName: "MyJournalCell", bundle: nil), forCellReuseIdentifier: MyJournalCellID)
    }
    
    func requestLoad() -> () {
        
        
        JournalModel.sendJournalListRequest(EIOID: self.oid, sucBlock: { (list) in
            
            self.table.mj_header.endRefreshing()
            self.dataArray.removeAllObjects()
            self.dataArray.addObjects(from: list)
            
            self.table.reloadData()
            
        }) { (resFail) in
            self.table.mj_header.endRefreshing()
        }
    }
}

extension MySendJournalController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model:SendJournalModel = self.dataArray[indexPath.row] as! SendJournalModel
        if model.REPLYCON == "" {
            
            return 70
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyJournalCell = tableView.dequeueReusableCell(withIdentifier: MyJournalCellID, for: indexPath) as! MyJournalCell
        let model:SendJournalModel = self.dataArray[indexPath.row] as! SendJournalModel
        cell.model = model
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let model:SendJournalModel = self.dataArray[indexPath.row] as! SendJournalModel
        let vc:WorkJournalDateilController = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "WorkJournalDateil") as! WorkJournalDateilController
        vc.OID = model.OID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
