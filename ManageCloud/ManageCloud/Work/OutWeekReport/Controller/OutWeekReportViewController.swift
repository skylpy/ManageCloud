//
//  OutWeekReportViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class OutWeekReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var starDate:Date = Date()
    var endDate:Date = Date()
    // 显示和强求数据的时间格式
    var starDateUI = " "
    var endDateUI = " "
    /// 选择的账户
    var account:ReportAccountModel = ReportAccountModel()
    
    /// 报表数据
    var reportListDateSource = [OutWeekModel]()
    /// 合计数据
    var sum:OutWeekTotalEntiesModel = OutWeekTotalEntiesModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支出周报"
        setTableView()
        
        self.starDateUI = DateFormatTools.instance.getCurrentDateWithSubDay(count: 7)
        self.starDate = self.starDateUI.date!
        initDate(first: true)
    }
    /// 数据请求
    func initDate(first:Bool) {
        
        let vm:DailyReportVM = DailyReportVM()
        let vm2:OutReportViewModel = OutReportViewModel()
        
        
        vm.askForReportAccountList({ (AryModel) in
            
            if first == true {
                self.account = AryModel[0]
                //            self.tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.none)
                self.tableView.reloadData()

            }
            
            /// 请求报表列表
            vm2.askForOutWeekReportList(BEGINDATE: self.starDateUI, ENDDATE: self.endDateUI, ZHTID: self.account.ZHTID!, { (arModel) in
                self.reportListDateSource = arModel
                self.tableView.reloadData()
                
            }, { (fail) in
                
                
            })
            
            
            /// 请求合计
            vm2.askForOutWeelReporTotal(BEGINDATE: self.starDateUI, ENDDATE: self.endDateUI, ZHTID: self.account.ZHTID!, { (model) in
                self.sum = model
                self.tableView.reloadData()
                
            }, { (fail) in
                
                
            })

            
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
        tableView.register(UINib.init(nibName: "OutWeekReportCellTableViewCell", bundle: nil), forCellReuseIdentifier: "OutWeekReportCellTableViewCell")
        //合计
        tableView.register(UINib.init(nibName: "OutReportSumCell", bundle: nil), forCellReuseIdentifier: "OutReportSumCell")
        
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.5))
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { //开始日期、结束日期、账户选择
            return 3
        }else if section == 1{
            //报表信息
            return self.reportListDateSource.count
        }
        //合计
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.reportListDateSource.count == 0 {
            return 1
        }
        return 3
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
            
            //报表数据
            let cell:OutWeekReportCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OutWeekReportCellTableViewCell") as! OutWeekReportCellTableViewCell
            let model = self.reportListDateSource[indexPath.row]
            cell.setViewValue(model: model, starTime: self.starDateUI, endTime: self.endDateUI, accountID: self.account.ZHTID!)
            cell.nav = self.navigationController
            return cell
            
        }else if indexPath.section == 2 {
            
            //合计
            let cell:OutReportSumCell = tableView.dequeueReusableCell(withIdentifier: "OutReportSumCell") as! OutReportSumCell
            cell.setViewValue(model: self.sum)
            return cell
        }
        
        let cell:ApplicationMineCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationMineCell") as! ApplicationMineCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1 {
            
            return 0.5
        }
        return 10
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
