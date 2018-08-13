//
//  MyAddCommandController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class MyAddCommandController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    lazy var dataArray:NSMutableArray = {
        
        let array = NSMutableArray()
        
        array.addObjects(from: AddCommandInit.sendList() as! [Any])
        
        return array
    }()
    
    var selectedDate: Date = Date()
    
    lazy var selectedArr: NSMutableArray = {
        
        let arr = NSMutableArray()
        
        return arr
    }()
    
    @IBOutlet weak var table: UITableView!
    
    let SendTitleCellID = "SendTitleCellID"
    let SendTextCellID = "SendTextCellID"
    var selectedPersonStr : String? = ""
    var state : String? = "重要并紧急"
    var perform_title : String? = ""
    var perform_content : String? = ""
    var isReply : String? = "是"
    var end_time : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "指挥"
        setTableView()
        setNavItem()
        NotificationCenter.default.rac_addObserver(forName: "textViewDidChange", object: nil).subscribeNext { (noti) in
            
            self.table.reloadData()
        }
    }
    
    func setTableView() {
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 50))
        
        self.table.register(UINib.init(nibName: "SendTitleCell", bundle: nil), forCellReuseIdentifier: SendTitleCellID)
        self.table.register(UINib.init(nibName: "SendTextCell", bundle: nil), forCellReuseIdentifier: SendTextCellID)
    }
    
    func setNavItem() {
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.setTitle("添加", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        rightButton.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView:rightButton )
        
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    @objc func sendRequest() {
        
        self.view.endEditing(false)
        
        self.perform_title = self.commandTT(indexS: 1, indexR: 0)
        self.perform_content = self.commandTT(indexS: 2, indexR: 0)
        
        if self.selectedPersonStr == "" ||  self.state == "" || self.isReply == "" || self.end_time == ""||self.perform_title == "请输入执行的事情" || self.perform_content == "请输入具体的事项"{
            
            HUD.flash(.label("请填写完整资料"), delay: 2)
            return
        }
        
        
        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
        CommandModel.addCommantRequest(pk_id: 0, userid: MyOid(), accepts: self.selectedPersonStr!, state: self.state!, perform_title: self.perform_title!, perform_content: self.perform_content!, isReply: self.isReply!, end_time: self.end_time!, successBlock: { (strUid) in
            HUD.hide()
            HUD.flash(.success, onView: UIApplication.shared.keyWindow, delay: 2, completion: { (isbool) in
                
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "commandJournal"), object: strUid, userInfo: nil))
            })
            
        }) { (error) in
            HUD.hide()
            HUD.flash(.label(error.remark), delay: 2)
        }
        
    }
    
    func commandTT(indexS:NSInteger,indexR:NSInteger) -> String {
        
        let conentList:NSArray = self.dataArray[indexS] as! NSArray
        let conentModel:AddCommandInit = conentList[indexR] as! AddCommandInit
        
        return conentModel.conent!
        
    }
}

extension MyAddCommandController {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 45
        }
        
        let list:NSMutableArray = self.dataArray[indexPath.section] as! NSMutableArray
        let model:AddCommandInit = list[indexPath.row] as! AddCommandInit
        return model.conentH!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let array:NSArray = self.dataArray[section] as! NSArray
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let array:NSArray = self.dataArray[indexPath.section] as! NSArray
        let model:AddCommandInit = array[indexPath.row] as! AddCommandInit
        
        if indexPath.section == 0 {
            
            let cell:SendTitleCell = tableView.dequeueReusableCell(withIdentifier: SendTitleCellID, for: indexPath) as! SendTitleCell
            cell.addModel = model
            return cell
        }
        
        let cell:SendTextCell = tableView.dequeueReusableCell(withIdentifier: SendTextCellID, for: indexPath) as! SendTextCell
        cell.indexpath = indexPath as NSIndexPath
        cell.sendType = 1
        cell.addModel = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let array:NSArray = self.dataArray[indexPath.section] as! NSArray
        let model:AddCommandInit = array[indexPath.row] as! AddCommandInit
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let vc = SelectVC()
                vc.type = .multi
                vc.personType = .subPerson
                vc.selectedArr = self.selectedArr as! [personModel]
                vc.finishSelectBlock = { (list) in
                    self.selectedArr.removeAllObjects()
                    self.selectedArr.addObjects(from: list)
                    self.selectedPersonStr = ""
                    model.conent = "未选择"
                    for pmodel:personModel in list {
                        
                        if self.selectedPersonStr == "" {
                            
                            model.conent = String(format:"%@",pmodel.EINAME!)
                            self.selectedPersonStr = String(format:"%@(%@)",pmodel.EINAME!,pmodel.EIOID!)
                        }else {
                            
                            model.conent = String(format:"%@,%@",model.conent!,pmodel.EINAME!)
                            self.selectedPersonStr = String(format:"%@,%@(%@)",self.selectedPersonStr!,pmodel.EINAME!,pmodel.EIOID!)
                        }
                    }
                    
                    self.table.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1 {
                
                self.tapDate(model: model)
            }else if indexPath.row == 2{
                
                let model1 = CustomModel.initCustom(title: "需回复", oid: "1")
                let model2 = CustomModel.initCustom(title: "仅通知", oid: "2")
                
                let list:NSArray = [model1,model2]
                
                
                CustomPickerView.initPickerView(view: UIApplication.shared.keyWindow!, dataSource: [list]) { (pmodel) in
                    
                    model.conent = pmodel.title
                    if pmodel.title == "需回复"{
                        self.isReply = "是"
                    }else {
                        self.isReply = "否"
                    }
                    
                    self.table.reloadData()
                }
            }else if indexPath.row == 3{
                
                let model1 = CustomModel.initCustom(title: "不重要不紧急", oid: "1")
                let model2 = CustomModel.initCustom(title: "紧急不重要", oid: "2")
                let model3 = CustomModel.initCustom(title: "重要并紧急", oid: "3")
                let model4 = CustomModel.initCustom(title: "重要不紧急", oid: "4")
                
                let list:NSArray = [model1,model2,model3,model4]
                
                
                CustomPickerView.initPickerView(view: UIApplication.shared.keyWindow!, dataSource: [list]) { (pmodel) in
                    
                    model.conent = pmodel.title
                    self.state = pmodel.title
                    self.table.reloadData()
                }
            }
        }
    }
    
    @objc fileprivate func tapDate(model:AddCommandInit) {
        var pickerSetting = DatePickerSetting.init()
        pickerSetting.date = self.selectedDate
        pickerSetting.minimumDate = NSDate.init() as Date
        UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
            self.selectedDate = date
            model.conent = date.dateString(format: "yyyy-MM-dd", locale: "en_US_POSIX")
            self.end_time = model.conent
            self.table.reloadData()
        }
    }
}
