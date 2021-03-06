//
//  OutWeekReportDetailViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/6/21.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class OutWeekReportDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var starDate:Date = Date()
    var endDate:Date = Date()
    // 显示和强求数据的时间格式
    var starDateUI = " "
    var endDateUI = " "
    
    /// 所选账户的编号
    var ZHTID = " "
    /// 科目编号
    var KMTID = " "
//    /// 开始时间
//    var starTime = " "
//    /// 结束时间
//    var endTime = " "
    
    
    
    
    /// 报表数据
    var reportListDateSource = [OutWeekReportDetailModel]()
    /// 合计数据
    var sum:InWeelReporTotalModel = InWeelReporTotalModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "支出周报明细"
        setTableView()
        
//        self.starDateUI = DateFormatTools.instance.getCurrentDateWithSubDay(count: 7)
        self.starDate = self.starDateUI.date!
        self.endDate = self.endDateUI.date!
        initDate(first: true)
    }
    
    func initDate(first:Bool) {
        
        let vm:OutWeekReportDetailVM = OutWeekReportDetailVM()
        vm.askForOutWeekReportDetailsList(BEGINDATE: starDateUI, ENDDATE: endDateUI, KMTID: self.KMTID, ZHTID: self.ZHTID, { (aryModel) in
            
            self.reportListDateSource = aryModel
            self.tableView.reloadData()
            
        }) { (fail) in
            
            
        }
        
        vm.askForInWeelReporTotal(BEGINDATE: starDateUI, ENDDATE: endDateUI, KMTID: self.KMTID, ZHTID: self.ZHTID, { (model) in
            self.sum = model
            self.tableView.reloadData()
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
        tableView.register(UINib.init(nibName: "OutWeekReportDetailCell", bundle: nil), forCellReuseIdentifier: "OutWeekReportDetailCell")
        //合计
        tableView.register(UINib.init(nibName: "WeekReportIncomeMoneyCell", bundle: nil), forCellReuseIdentifier: "WeekReportIncomeMoneyCell")
        
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.5))
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { //开始日期、结束日期、账户选择
            return 2
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
                
//                var tempAry =  self.starDate.string().components(separatedBy: " ")
//                let timeAry = tempAry[0].components(separatedBy: "/")
//                cell.timeLB.text = timeAry[2] + "-" + timeAry[1] + "-" + timeAry[0]
                cell.timeLB.text! = self.starDateUI
                return cell
                
            }else if indexPath.row == 1 {
                
                //结束日期
                let cell:ReportEndTimeCell = tableView.dequeueReusableCell(withIdentifier: "ReportEndTimeCell") as! ReportEndTimeCell
                
//                var tempAry =  self.endDate.string().components(separatedBy: " ")
//                let timeAry = tempAry[0].components(separatedBy: "/")
//                cell.timeLB.text = timeAry[2] + "-" + timeAry[1] + "-" + timeAry[0]
                cell.timeLB.text! = self.endDateUI
                return cell
            }
            
        }else if indexPath.section == 1 {
            
            //报表数据
            let cell:OutWeekReportDetailCell = tableView.dequeueReusableCell(withIdentifier: "OutWeekReportDetailCell") as! OutWeekReportDetailCell
            let model = self.reportListDateSource[indexPath.row]
            cell.setViewValue(model: model)
            return cell
            
        }else if indexPath.section == 2 {
            
            //合计
            let cell:WeekReportIncomeMoneyCell = tableView.dequeueReusableCell(withIdentifier: "WeekReportIncomeMoneyCell") as! WeekReportIncomeMoneyCell
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
