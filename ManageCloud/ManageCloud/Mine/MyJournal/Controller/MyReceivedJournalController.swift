//
//  MyReceivedJournalController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
import MJRefresh

class MyReceivedJournalController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    lazy var dataArray:NSMutableArray = {
       
        let array = NSMutableArray()
        
        return array
    }()
    
    @IBOutlet weak var table: UITableView!
    let MyReceivedJournalCellID = "MyReceivedJournalCellID"
    var oid:String!
    
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
    //(HSInstance.share.userInfo?.EINAME)!
    func requestLoad() -> () {
        

        JournalModel.receivedJournalListRequest(EIOID: self.oid, EINAME: (HSInstance.share.userInfo?.EINAME)!, successBlock: { (list) in

            self.table.mj_header.endRefreshing()
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjects(from: list)
            
            self.table.reloadData()
            
        }) { (error) in
            
            self.table.mj_header.endRefreshing()
        }
    }
    
    func setTableView() {
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.separatorStyle = .none
        self.table.tableFooterView = UIView()
        
        self.table.register(UINib.init(nibName: "MyReceivedJournalCell", bundle: nil), forCellReuseIdentifier: MyReceivedJournalCellID)
        
    }
}

extension MyReceivedJournalController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 66
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 50))
        header.backgroundColor = UIColor.color(string: "#F2F2F6")
        
        let boby = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 50))
        boby.backgroundColor = UIColor.white
        header.addSubview(boby)
        let list:NSArray = self.dataArray[section] as! NSArray
        let dict:NSDictionary = list[0] as! NSDictionary
        
        let label = UILabel.init(frame: CGRect(x: 15, y: 10, width: KWidth-30, height: 30))
        label.font = UIFont.init(name: kMedFont.rawValue, size: 18)
        label.text = String(format: "%@月%@日", NSString.refreshMonth(dateString: dict["GDATE"] as! String),NSString.refreshDay(dateString: dict["GDATE"] as! String))
        boby.addSubview(label)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let list:NSArray = self.dataArray[section] as! NSArray
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyReceivedJournalCell = tableView.dequeueReusableCell(withIdentifier: MyReceivedJournalCellID, for: indexPath) as! MyReceivedJournalCell
        let list:NSArray = self.dataArray[indexPath.section] as! NSArray
        let model:NSDictionary = list[indexPath.row] as! NSDictionary
        
        cell.model = model
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let list:NSArray = self.dataArray[indexPath.section] as! NSArray
        let dict:NSDictionary = list[indexPath.row] as! NSDictionary
        let model:SendJournalModel = SendJournalModel.deserialize(from: dict)!
        let vc:WorkJournalDateilController = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "WorkJournalDateil") as! WorkJournalDateilController
        
        vc.OID = model.OID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
