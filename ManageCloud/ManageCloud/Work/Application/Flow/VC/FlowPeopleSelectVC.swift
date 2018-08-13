//
//  FlowMulSelectVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

let FlowPSelectTCellID = "FlowPSelectTCellID"

class FlowPeopleSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //表单编码
    var tid = ""
    //自定义表单类型编号
    var BTid = ""
    //审批流程编号
    var bpftid = ""
    
    
    //header Tips
    var headerTips = ""
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH))
        table.estimatedRowHeight = 0.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(UINib.init(nibName: "FlowPSelectTCell", bundle: nil), forCellReuseIdentifier: FlowPSelectTCellID)
        return table
    }()
    
    var selectedArr: [FlowStepPerson] = []
    
    var saveBtn: UIButton!
    
    var data: [FlowStepPerson] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "选择审批人"
        view.backgroundColor = UIColor.white
        view.addSubview(Table)
        
        saveBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 20))
        saveBtn.setTitle("确定", for: .normal)
        saveBtn.titleLabel?.textAlignment = .right
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: saveBtn)
        HUD.show(.labeledProgress(title:nil , subtitle: "加载中"), onView: self.view)
        WorkFlowVM.GetStep(WithTid: BTid, BTid: tid, bpftid: bpftid, sucBlock: {(tips, personArr) in
            HUD.hide()
            self.headerTips = tips
            self.data = personArr
            self.Table.reloadData()
        }) { (resFail) in
            HUD.hide()
        }
        
        
    }
    
    fileprivate func loadData() {
        
    }
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlowPSelectTCellID, for: indexPath) as! FlowPSelectTCell
        cell.personModel = data[indexPath.row]
        cell.selectionStyle = .none
        return cell      
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.row]
        model.isSelete = !model.isSelete
        if model.isSelete{
            selectedArr.append(model)
        }
        else{
            for (index, person) in selectedArr.enumerated(){
                if person.POid! == model.POid!{
                    selectedArr.remove(at: index)
                    break
                }
            }
            
        }
        refreshBtn()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 37))
        view.backgroundColor = UIColor.white
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 15, width: KWidth - 30, height: 22), text: self.headerTips, font: UIFont.init(fontName: kRegFont, size: 16), color: DarkGrayTitleColor, alignment: .left, lines: 1)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    fileprivate func refreshBtn() {
        saveBtn.width = 100
        saveBtn.setTitle("确定(\(selectedArr.count)/\(data.count))", for: .normal)
    }
    
    @objc fileprivate func save() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
