//
//  AddFromVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

let FlowFieldTCellID = "FlowFieldTCellID"
let FlowSFieldTCellID = "FlowSFieldTCellID"
let FlowMFieldTCellID = "FlowMFieldTCellID"
let FlowPickerTCellID = "FlowPickerTCellID"
let FlowCountTCellID = "FlowCountTCellID"
let FlowChoiceTCellID = "FlowChoiceTCellID"


class AddFromVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH))
        table.register(UINib.init(nibName: "FlowFieldTCell", bundle: nil), forCellReuseIdentifier: FlowFieldTCellID)
        table.register(UINib.init(nibName: "FlowSFieldTCell", bundle: nil), forCellReuseIdentifier: FlowSFieldTCellID)
        table.register(UINib.init(nibName: "FlowMFieldTCell", bundle: nil), forCellReuseIdentifier: FlowMFieldTCellID)
        table.register(UINib.init(nibName: "FlowPickerTCell", bundle: nil), forCellReuseIdentifier: FlowPickerTCellID)
        table.register(UINib.init(nibName: "FlowCountTCell", bundle: nil), forCellReuseIdentifier: FlowCountTCellID)
        table.register(UINib.init(nibName: "FlowChoiceTCell", bundle: nil), forCellReuseIdentifier: FlowChoiceTCellID)
        
        table.estimatedRowHeight = 0.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, KWidth/2.0, 0, KWidth/2.0)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.keyboardDismissMode = .onDrag
        table.register(UITableViewCell.self, forCellReuseIdentifier: normalCellID)
        return table
    }()
    
    //记录每个分类首个checkbox的位置
    var checkBoxNameArr: [String] = []
    
    
    //自定义表单类型编号
    var BTid = ""
    
    //表单编码
    var tid: String = ""
    //审批流程编号
    var bpftid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
    }
    //控件数据源
    var controlData = [FormControlModel]()
    
    var sourceModel: FormInputModel = FormInputModel()
    
    
    // MARK: - Custom Method
    
    fileprivate func initUI() {
        title = "自定义表单"
        view.backgroundColor = UIColor.white
        view.addSubview(Table)
        let saveBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 20))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: saveBtn)
    }
    
    fileprivate func loadData() {
        HUD.show(.labeledProgress(title: nil, subtitle: "加载中"), onView: self.view)
        WorkFlowVM.loadFlowInput(WithBTid: BTid, sucBlock: { (model) in
            self.sourceModel = model
            for listModel in model.Controls!{
                if listModel.EFIELDNAME == "TID" || listModel.EFIELDNAME == "BTID" || listModel.EFIELDNAME == "MAKEREID" || listModel.EFIELDNAME == "EINAME" || listModel.EFIELDNAME == "BDATE" || listModel.EFIELDNAME == "BPFTID" || listModel.EFIELDNAME == "DTID" || listModel.EFIELDNAME == "DNAME" || listModel.EFIELDNAME == "STATE"{
                    if listModel.EFIELDNAME == "TID"{
                        self.tid = listModel.Value!
                    }
                    
                }
                else{
                    //处理年月日的value值
                    if listModel.ControlType == "年月日"{
                        listModel.Value = listModel.Value?.components(separatedBy: " ").first
                    }
                    let controlType = listModel.ControlType
                    switch controlType {
                    case "text":
                        //单行输入框
                        listModel.cellHeight = 83
                    case "label","number","年","年月","年月日","年月日时分秒":
                        //标签,数值,时间选择
                        listModel.cellHeight = 50
                    case "textarea":
                        //多行文本
                        listModel.cellHeight = 183
                    case "select":
                        //下拉列表
                        listModel.cellHeight = 50
                        
                    default:
                        listModel.cellHeight = 0
                    }
                    
                    //处理checkbox
                    if listModel.ControlType == "checkbox"{
                        let category = listModel.ControlName?.components(separatedBy: "-").first
                        if self.checkBoxNameArr.contains(category!){
                            listModel.isFirst = false
                            listModel.cellHeight = 50
                        }
                        else{
                            listModel.isFirst = true
                            self.checkBoxNameArr.append(category!)
                            listModel.cellHeight = 83
                        }
                    }
                    
                    
                    self.controlData.append(listModel)
                }
            }
            for optionModel in model.Options!{
                if optionModel.ControlName == "BPFTID"{
                    self.bpftid = optionModel.Value!
                }
                else{
                    for listModel in model.Controls!{
                        if listModel.ControlName == optionModel.ControlName{
                            if !(optionModel.Selected?.isEmpty)!{
                                listModel.selectedIndex = listModel.dataSource.count
                            }
                            listModel.dataSource.append(optionModel.Value!)
                            break
                        }
                    }
                }
            }
            HUD.hide()
            self.Table.reloadData()
        }) { (resFail) in
            HUD.hide()
        }
    }
    
    @objc fileprivate func save() {
        
        let vc = FlowPeopleSelectVC()
        vc.tid = tid
        vc.BTid = BTid
        vc.bpftid = bpftid
        navigationController?.pushViewController(vc, animated: true)
        
        
//        WorkFlowVM.save(WithTID: BTid, controls: controlData, isModify: false, sucBlock: {
//
//        }) { (resFail) in
//
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.controlData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.controlData[indexPath.section]
        
        switch model.ControlType {
        case "text":
            //单行输入框
            let cell = tableView.dequeueReusableCell(withIdentifier: FlowSFieldTCellID, for: indexPath) as! FlowSFieldTCell
            cell.model = model
            cell.selectionStyle = .none
            cell.inputBlock = { (text) in
                model.Value = text
            }
            return cell
        case "label":
            //标签
            let cell = tableView.dequeueReusableCell(withIdentifier: FlowFieldTCellID, for: indexPath) as! FlowFieldTCell
            cell.model = model
            cell.selectionStyle = .none
            cell.inputBlock = { (text) in
                model.Value = text
            }
            return cell
        case "textarea":
            //多行文本
            let cell = tableView.dequeueReusableCell(withIdentifier: FlowMFieldTCellID, for: indexPath) as! FlowMFieldTCell
            cell.model = model
            cell.selectionStyle = .none
            cell.inputBlock = { (text) in
                model.Value = text
            }
            cell.heightBlock = { (height) in
//                model.cellHeight = height + 43
//                self.reloadSection(section: indexPath.section)
            }
            return cell
        case "select","年","年月","年月日","年月日时分秒":
            //下拉列表
            let cell = tableView.dequeueReusableCell(withIdentifier: FlowPickerTCellID, for: indexPath) as! FlowPickerTCell
            cell.model = model
            cell.selectionStyle = .none
            cell.selectBlock = {
                self.view.endEditing(true)
                DPrint("hahh")
                if model.ControlType == "select"{
                    UsefulPickerView.showSingleColPicker("", data: model.dataSource, defaultSelectedIndex: model.selectedIndex, doneAction: { (selectedIndex, selectedValue) in
                        model.selectedIndex = selectedIndex
                        model.Value = selectedValue
                        self.Table.reloadData()
                    })
                }
                else {
                    if model.ControlType == "年"{
                        DatePickerTool.init(pickType: .Year, seletedString: model.selectedDateString, doneAction: { (index, selectedString) in
                            model.selectedDateString = selectedString.first!
                            self.Table.reloadData()
                        })
                    }
                    else if model.ControlType == "年月"{
                        DatePickerTool.init(pickType: .YearMonth, seletedString: model.selectedDateString, doneAction: { (index, selectedString) in
                            model.selectedDateString = selectedString.first! + "-" + selectedString.last!
                            self.Table.reloadData()
                        })
                    }
                    else if model.ControlType == "年月日"{
                        var pickerSetting = DatePickerSetting.init()
                        pickerSetting.date = model.selectedDate
                        UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
                            model.selectedDate = date
                            model.selectedDateString = date.dateString(format: "yyyy/M/d", locale: "en_US_POSIX")
                            self.Table.reloadData()
                        }
                    }
                    else{
                        var pickerSetting = DatePickerSetting.init()
                        pickerSetting.date = model.selectedDate
                        pickerSetting.dateMode = UIDatePickerMode.dateAndTime
                        UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
                            model.selectedDate = date
                            model.selectedDateString = date.dateString(format: "yyyy/M/d HH:mm:ss", locale: "en_US_POSIX")
                            self.Table.reloadData()
                        }
                    }
                    
                }
            }
            return cell
        case "number":
            //数值
            let cell = tableView.dequeueReusableCell(withIdentifier: FlowCountTCellID, for: indexPath) as! FlowCountTCell
            cell.model = model
            cell.selectionStyle = .none
            cell.inputBlock = { (text) in
                model.Value = text
            }
            return cell
        case "checkbox":
            //单选多选
            let cell = tableView.dequeueReusableCell(withIdentifier: FlowChoiceTCellID, for: indexPath) as! FlowChoiceTCell
            cell.model = model
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell.init()
        }
        
        
        
    }
    
    
    fileprivate func reloadSection(section: Int) {
        self.Table.reloadRows(at: [IndexPath.init(row: 0, section: section)], with: .bottom)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.controlData[indexPath.section]
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.controlData[indexPath.section]
        if model.ControlType == "checkbox"{
            model.isSelected = !model.isSelected
            if model.isSelected{
                model.Value = "true"
            }
            else{
                model.Value = "false"
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    
    

}
