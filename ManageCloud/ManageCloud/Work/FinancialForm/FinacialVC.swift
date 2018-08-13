//
//  FinacialVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/31.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import ReactiveObjC

let FCConditionTCellID = "FCConditionTCellID"
let FCResultTCellID = "FCResultTCellID"

struct FCItem {
    var iconImg: String? = ""
    var BtnImg: String? = ""
    var TFtext: String? = ""
    var TFHolder: String? = ""
    var LBtext: String? = ""
}

class FinacialVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedDate: Date = Date()
    //选择的日期
    var selectedDateString: String = ""
    //选择的子公司index
    var selectedIndex: Int = 0
    
    
    //分公司数据
    lazy var subCom: [String] = {
        let subArr = ["广州分公司","汉娜分公司","雷州分公司"]
        return subArr
    }()
    
    //条件选择
    lazy var data: [FCItem] = {
        var con1 = FCItem.init(iconImg:"house" , BtnImg: "arrowDown",TFtext:"", TFHolder:"", LBtext: "广州可乐可大幅软件科技发展有限公司")
        var con2 = FCItem.init(iconImg: "clock1", BtnImg: "arrowDown",TFtext:"", TFHolder:"", LBtext: "2018-05-23")
        var dataa = [FCItem]()
        dataa.append(con1)
        dataa.append(con2)
        return dataa
    }()
    
    
    
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH ))
        table.register(UINib.init(nibName: "FCResultTCell", bundle: nil), forCellReuseIdentifier: FCResultTCellID)
        table.register(UINib.init(nibName: "FCConditionTCell", bundle: nil), forCellReuseIdentifier: FCConditionTCellID)
        
        table.estimatedRowHeight = 0.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "财务报表"
        view.addSubview(Table)
    }
    
    fileprivate func loadData() {
        
    }
    
    //MARK:- UITableView Delegate / DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return data.count
        }
        else{
            return 10
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 55
        }
        else{
            if indexPath.row == 0{
                return 40
            }
            else{
                return 50.5
            }

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0{
            let model = data[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: FCResultTCellID, for: indexPath) as! FCResultTCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsetsMake(0, 54, 0, 0)
            cell.model = model
            cell.Btn.rac_signal(for: .touchUpInside).take(until: cell.rac_prepareForReuseSignal as! RACSignal<AnyObject>).subscribeNext { [weak self](x) in
                if indexPath.row == 0{
                    UsefulPickerView.showSingleColPicker("", data: (self?.subCom)!, defaultSelectedIndex: self?.selectedIndex, doneAction: { (selectedIndex, selectedValue) in
                        self?.selectedIndex = selectedIndex
                        var timeModel = self?.data[indexPath.row]
                        timeModel?.LBtext = selectedValue
                        self?.data[indexPath.row] = timeModel!
                        self?.Table.reloadData()
                    })
                }
                else{
                    var pickerSetting = DatePickerSetting.init()
                    pickerSetting.date = (self?.selectedDate)!
                    UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
                        self?.selectedDate = date
                        self?.selectedDateString = date.dateString(format: "yyyy-MM-dd", locale: "en_US_POSIX")
                        var timeModel = self?.data[indexPath.row]
                        timeModel?.LBtext = self?.selectedDateString
                        self?.data[indexPath.row] = timeModel!
                        self?.Table.reloadData()
                    }
                }
                
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FCConditionTCellID, for: indexPath) as! FCConditionTCell
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.selectionStyle = .none
            if indexPath.row == 0{
                
                cell.leftLB.textColor = GrayTitleColor
                cell.leftLB.font = UIFont.init(fontName: kRegFont, size: 14)
                cell.rightLB.textColor = GrayTitleColor
                cell.rightLB.font = UIFont.init(fontName: kRegFont, size: 14)
                cell.leftLB.text = "银行"
                cell.rightLB.text = "金额(元)"
                return cell
            }
            else{
                cell.selectionStyle = .gray
                cell.leftLB.textColor = DarkTitleColor
                cell.leftLB.font = UIFont.init(fontName: kRegFont, size: 16)
                cell.rightLB.textColor = DarkTitleColor
                cell.rightLB.font = UIFont.init(fontName: kRegFont, size: 16)
                cell.leftLB.text = "中国建设银行"
                cell.rightLB.text = "200,000"
                return cell
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 41), backgroundColor: BgColor)
        let text = section == 0 ? "查询条件":"查询结果"
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 41 - 6 - 20, width: 56, height: 20), text:text , font: UIFont.init(fontName: kRegFont, size: 14), color: GrayTitleColor, alignment: .left, lines: 1)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    
    
    
    

}
