//
//  DailyReportViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/13.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class DailyReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var starDate:Date = Date()
    var endDate:Date = Date()
    // 显示和强求数据的时间格式
    var starDateUI = " "
    var endDateUI = " "
    /// 选择的账户
    var account:ReportAccountModel = ReportAccountModel()
    
    /// 报表信息数据
    var reportDateSource = [DailyReportModel]()
    
    /// 收入、支出数据
    var DailyReporTotalDateSource = DailyReporTotalModel()
    
    // 账户列表
    var ReportAccountListSource = [ReportAccountListModel]()
    //账户列表合计
    var ReportAccountListSum = 0.00
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "日报表"
        setTableView()
        
        self.initDate(first: true)
        
    }
    
    /// 数据请求
    func initDate(first:Bool) {
        
        let vm:DailyReportVM = DailyReportVM()
        vm.askForReportAccountList({ (AryModel) in
            
            if first == true{
                
                self.account = AryModel[0]
                //            self.tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.none)
                self.tableView.reloadData()
            }

            
            /// 报表信息请求
            vm.askForDailyReportList(BEGINDATE: self.starDateUI, ENDDATE: self.endDateUI, ZHTID: self.account.ZHTID!, { (aryModel) in
                
                self.reportDateSource = aryModel
                //                self.tableView.reloadSections(IndexSet.init(integer: 1), with: UITableViewRowAnimation.none)
                self.tableView.reloadData()
                
            }, { (fail) in
                
            })
            
            /// 收入合计请求
            vm.askForDailyReporTotal(BEGINDATE: self.starDateUI, ENDDATE: self.endDateUI, ZHTID: self.account.ZHTID!, { (model) in
                self.DailyReporTotalDateSource = model
                //                self.tableView.reloadSections(IndexSet.init(integer: 2), with: UITableViewRowAnimation.none)
                self.tableView.reloadData()
            }, { (fail) in
                
            })
            
            
            /// 账户信息请求
            vm.askForDailyReporAccount(BEGINDATE: self.starDateUI, ENDDATE: self.endDateUI, ZHTID: self.account.ZHTID!, { (aryModel) in
                
                self.ReportAccountListSource = aryModel
                
                for item in self.ReportAccountListSource {
                    
                    self.ReportAccountListSum =  self.ReportAccountListSum + item.ZHBALANCE!.double()!
                }
                
                self.tableView.reloadData()
                
            }) { (fail) in
                
            }
            
            
        }) { (fail) in
            
            
        }
    }
    
    func setTableView() {
        
        //开始日期
        tableView.register(UINib.init(nibName: "ReportStarTimeCell", bundle: nil), forCellReuseIdentifier: "ReportStarTimeCell")
        //结束日期
        tableView.register(UINib.init(nibName: "ReportEndTimeCell", bundle: nil), forCellReuseIdentifier: "ReportEndTimeCell")
        //选择账户
        tableView.register(UINib.init(nibName: "ReportChangeAccountCell", bundle: nil), forCellReuseIdentifier: "ReportChangeAccountCell")
        //报表数据
        tableView.register(UINib.init(nibName: "DailyReportCell", bundle: nil), forCellReuseIdentifier: "DailyReportCell")
        //合计
        tableView.register(UINib.init(nibName: "DailyReportMoneyCell", bundle: nil), forCellReuseIdentifier: "DailyReportMoneyCell")
        //账户信息
        tableView.register(UINib.init(nibName: "ReportAcountCell", bundle: nil), forCellReuseIdentifier: "ReportAcountCell")
        //账户余额合计
        tableView.register(UINib.init(nibName: "ReportAccountMoneyCell", bundle: nil), forCellReuseIdentifier: "ReportAccountMoneyCell")
        
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.5))
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 22))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { //开始日期、结束日期、账户选择
            return 3
        }else if section == 1{
            //报表信息
            return self.reportDateSource.count
        }else if section == 3{
            //账户信息
            return self.ReportAccountListSource.count
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.reportDateSource.count == 0 {
            return 1
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                //起始日期
                let cell:ReportStarTimeCell = tableView.dequeueReusableCell(withIdentifier: "ReportStarTimeCell") as! ReportStarTimeCell
                
                var tempAry =  self.starDate.string().components(separatedBy: " ")
                let timeAry = tempAry[0].components(separatedBy: "/")
                cell.timeLB.text = timeAry[2] + "-" + timeAry[1] + "-" + timeAry[0]
                self.starDateUI = cell.timeLB.text!
                return cell
                
            }else if indexPath.row == 1 {
                
                //结束日期
                let cell:ReportEndTimeCell = tableView.dequeueReusableCell(withIdentifier: "ReportEndTimeCell") as! ReportEndTimeCell
                
                var tempAry =  self.endDate.string().components(separatedBy: " ")
                let timeAry = tempAry[0].components(separatedBy: "/")
                cell.timeLB.text = timeAry[2] + "-" + timeAry[1] + "-" + timeAry[0]
                self.endDateUI = cell.timeLB.text!
                return cell
            }else{
                
                //选择账户
                let cell:ReportChangeAccountCell = tableView.dequeueReusableCell(withIdentifier: "ReportChangeAccountCell") as! ReportChangeAccountCell
                cell.accountLB.text = self.account.ZHNAME
                return cell
            }
        }else if indexPath.section == 1 {
            //报表信息
            let cell:DailyReportCell = tableView.dequeueReusableCell(withIdentifier: "DailyReportCell") as! DailyReportCell
            let model = reportDateSource[indexPath.row]
            
            cell.setViewValue(model: model)
            return cell
        }else if indexPath.section == 2{
            
            //收入、支出的合计
            let cell:DailyReportMoneyCell = tableView.dequeueReusableCell(withIdentifier: "DailyReportMoneyCell") as! DailyReportMoneyCell
            
            cell.setViewValue(model: self.DailyReporTotalDateSource)
            return cell
        }else if indexPath.section == 3 {
            
            //账户信息
            let cell:ReportAcountCell = tableView.dequeueReusableCell(withIdentifier: "ReportAcountCell") as! ReportAcountCell
            let model = self.ReportAccountListSource[indexPath.row]
            cell.setViewValue(model: model)
            
            return cell
        }else if indexPath.section == 4 {
            
            
            //账户信息余额合计
            let cell:ReportAccountMoneyCell = tableView.dequeueReusableCell(withIdentifier: "ReportAccountMoneyCell") as! ReportAccountMoneyCell
             let model = self.ReportAccountListSource[0]
            cell.setViewValue(money: self.ReportAccountListSum, company: model.DNAME!)
            
            return cell
        }
        
        //
        let cell:ApplicationMineCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationMineCell") as! ApplicationMineCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 3 {
            //最后一组有表头 （所有账户，账户余额）
            let view = UIView.loadFromNib(named: "ReportAllAcountLB")
            return view
        }
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 3 {
            //最后一组有表头 （所有账户，账户余额）
            return 94
        }
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            
            return 0.5
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 10), backgroundColor: UIColor.clear)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell:ReportStarTimeCell = tableView.cellForRow(at: indexPath) as! ReportStarTimeCell
                
                var pickerSetting = DatePickerSetting.init()
                pickerSetting.date = (cell.timeLB.text?.date!)!
                UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
                    let str = date.string()
                    var tempAry =  str.components(separatedBy: " ")
                    let timeAry = tempAry[0].components(separatedBy: "/")
                    cell.timeLB.text = timeAry[2] + "-" + timeAry[1] + "-" + timeAry[0]
                    self.starDateUI = cell.timeLB.text!
                    self.starDate = (cell.timeLB.text?.date!)!

                    if self.starDate > self.endDate{
                        
                        self.endDate = self.starDate
                        self.tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.none)
                        
                    }
                    self.initDate(first: false)

                }
                
            }else if indexPath.row == 1 {
                let cell:ReportEndTimeCell = tableView.cellForRow(at: indexPath) as! ReportEndTimeCell
                
                var pickerSetting = DatePickerSetting.init()
                pickerSetting.date = (cell.timeLB.text?.date!)!
                UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
                    let str = date.string()
                    var tempAry =  str.components(separatedBy: " ")
                    let timeAry = tempAry[0].components(separatedBy: "/")
                    cell.timeLB.text = timeAry[2] + "-" + timeAry[1] + "-" + timeAry[0]
                    self.endDateUI = cell.timeLB.text!
                    self.endDate = (cell.timeLB.text?.date!)!

                    if self.starDate > self.endDate{
                        
                        self.starDate = self.endDate
                        self.tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.none)
                    }
                    
                    self.initDate(first: false)

                }
                
            }else{
                
                let vm:DailyReportVM = DailyReportVM()
                HUD.show(.progress,onView: self.view)
                vm.askForReportAccountList({ (aryModel) in
                    HUD.hide()
                    let tempAry = NSMutableArray.init()
                    
                    for item in aryModel{
                        
                        tempAry.add(item.ZHNAME)
                    }
                    
                    UsefulPickerView.showSingleColPicker("", data: tempAry as! [String], defaultSelectedIndex: 0, doneAction: { (index, str) in
                        
                        for item in aryModel{
                            
                            if item.ZHNAME == str{
                                self.account = item
                            }
                        }
                        self.tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.none)
                        
                        self.initDate(first: false)
                    })
                    
                    
                }) { (fail) in
                    
                    
                }
                
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
