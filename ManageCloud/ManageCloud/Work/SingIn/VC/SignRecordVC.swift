//
//  SignRecordVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/14.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class SignRecordVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: [SignListModel] = [SignListModel]()
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH ))
        table.register(UINib.init(nibName: "SignRecordTCell", bundle: nil), forCellReuseIdentifier: SignRecordTCellID)
        table.estimatedRowHeight = 100
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "签到记录"
        view.backgroundColor = UIColor.white
        view.addSubview(Table)
    }
    
    fileprivate func loadData() {
        HUD.show(.labeledProgress(title: nil, subtitle: "加载中"), onView: view)
        SignInVM.LoadAllSignList(sucBlock: {[weak self] (modelArr) in
            HUD.hide()
            if let dataArr = modelArr{
                self?.data = dataArr
            }
            else{
                self?.data = [SignListModel]()
            }
            self?.Table.reloadData()
        }) { (resFail) in
            HUD.hide()
            HUD.flash(.labeledError(title: nil, subtitle: resFail.remark), delay: 1.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UITableView Delegate / DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SignRecordTCellID, for: indexPath) as! SignRecordTCell
        cell.type = .MineAllSign
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 16)
        cell.myTodaySignModel = model
        return cell
    }
    

}
