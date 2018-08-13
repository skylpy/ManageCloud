//
//  ApprovalDetailsController.swift
//  ManageCloud
//
//  Created by aaron on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import Alamofire
import UITableView_FDTemplateLayoutCell

class ApprovalDetailsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var table: UITableView!
    
    let ApprovalTopCellID = "ApprovalTopCellID"
    let ApprovalDetailTCellID = "ApprovalDetailTCellID"
    let ApprovalDetailedCellID = "ApprovalDetailedCellID"
    let ApprovalProgressCellID = "ApprovalProgressCellID"
    
    var formCell: ApprovalDetailTCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
    }
    
    func setTableView() -> Void {
        title = "审批详情"
        self.table.delegate = self
        self.table.dataSource = self
        self.table.register(UINib.init(nibName: "ApprovalTopCell", bundle: nil), forCellReuseIdentifier: ApprovalTopCellID)
        self.table.register(UINib.init(nibName: "ApprovalDetailTCell", bundle: nil), forCellReuseIdentifier: ApprovalDetailTCellID)
        self.table.register(UINib.init(nibName: "ApprovalDetailedCell", bundle: nil), forCellReuseIdentifier: ApprovalDetailedCellID)
        self.table.register(UINib.init(nibName: "ApprovalProgressCell", bundle: nil), forCellReuseIdentifier: ApprovalProgressCellID)

        table.reloadData()
        
    }
}

extension ApprovalDetailsController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:

            return 72
        case 1:
            return tableView.fd_heightForCell(withIdentifier: ApprovalDetailTCellID) { (cell) in
                let newCell = cell as! ApprovalDetailTCell
                newCell.data = ["登记费季度实际爱疯ID旧爱房基金","几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就","几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就"];
            }
           
        case 2:

            return 150
        default:

            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0.01
        case 3:
            return 60
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 3 {
            
            return ApprovalHeaderView.initRegister()
        }
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ApprovalTopCellID, for: indexPath) as! ApprovalTopCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ApprovalDetailTCellID, for: indexPath) as! ApprovalDetailTCell
            cell.data = ["登记费季度实际爱疯ID旧爱房基金","几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就","几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就几点飞机就是地府记得架飞机低价覅及防静电旧爱飞机飞碟说骄傲覅就"];
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ApprovalDetailedCellID, for: indexPath) as! ApprovalDetailedCell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ApprovalProgressCellID, for: indexPath) as! ApprovalProgressCell
            
            return cell
        }
        
    }
}
