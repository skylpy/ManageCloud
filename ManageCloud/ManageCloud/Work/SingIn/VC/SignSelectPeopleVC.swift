//
//  SignSelectPeopleVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class SignSelectPeopleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedBlock:((_ Oid: SignPersonListModel) -> ())?
    var data: [SignPersonListModel] = [SignPersonListModel]()
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH ))
        table.register(UINib.init(nibName: "SelectTCell", bundle: nil), forCellReuseIdentifier: SelectTCellID)
        table.estimatedRowHeight = 100
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择成员"
        view.addSubview(Table)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Method
    
    fileprivate func loadData() {
        SignInVM.LoadSignPersonList(sucBlock: {[weak self] (modelArr) in
            if let dataArr = modelArr{
                self?.data = dataArr
            }
            else{
                self?.data = [SignPersonListModel]()
            }
            self?.Table.reloadData()
        }) { (resFail) in
            HUD.flash(.labeledError(title: nil, subtitle: resFail.remark), delay: 1.0)
        }
    }
    
    //MARK:- UITableView Delegate / DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: SignPersonListModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTCellID, for: indexPath) as! SelectTCell
        cell.selectionStyle = .gray
        cell.signModel = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = data[indexPath.row]
        selectedBlock!(person)
        navigationController?.popViewController()
    }
    
    


}
