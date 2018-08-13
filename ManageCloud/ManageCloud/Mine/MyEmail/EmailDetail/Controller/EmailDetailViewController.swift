//
//  EmailDetailViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
import MJRefresh

class EmailDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var vm:EmailDetailVM = EmailDetailVM()
    var postVM:PostEmailVM = PostEmailVM()
//    var model:[MailModel] = [MailModel]()
    var strTID:String? = ""
    var strEIOID:String? = ""
    var strEINAME:String? = ""
    
    var dateSource:[MyEmailModel] = [MyEmailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "邮件详情"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_point"), style: .done, target: self, action: #selector(moreaAtion))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.setTabaleView()
        
        self.initDate()
        
    }
    
    //MARK: 网络请求
    func initDate() {
        
        self.strEIOID = MyOid()
        self.strEINAME = MyEINAME()
        self.vm.askForEmailDetailList(strTID: self.strTID!, EIOID: self.strEIOID!, EINAME: self.strEINAME!) { (modelAry) in
            
            self.dateSource = modelAry
            self.tableView.reloadData()
            
            //发送通知 邮件已读
            
            //            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
            //            NotificationCenter.default.post(name: notificationName, object: self,
            //                                            userInfo: nil)
            //
            EmailListShowType = [EmailListShowType[0],EmailListShowType[1]]
        }
        
//        self.vm.askForEmailDetailList(strTID: self.strTID!) { (modelAry) in
//            self.dateSource = modelAry
//            self.tableView.reloadData()
//
//            //发送通知 邮件已读
//
////            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
////            NotificationCenter.default.post(name: notificationName, object: self,
////                                            userInfo: nil)
////
//             EmailListShowType = [EmailListShowType[0],EmailListShowType[1]]
//
//        }
    }
    
    @objc func moreaAtion(){
        
        let alert =  UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(title: "回复邮件", style: .default, isEnabled: true) { (action) in
            
            self.answerEmail()
        }
        //删除
        let delAction = UIAlertAction(title: "删除邮件", style: .default) { (action) in
            
            self.showDelAlert()
        }
        delAction.setValue(RGBA(r: 255, g: 59, b: 48, a: 0.9), forKey: "titleTextColor")
        
        //取消
        let action = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        action.setValue(RGBA(r: 51, g: 51, b: 51, a: 0.9), forKey: "titleTextColor")

        let cancelStr = NSMutableAttributedString.init(string: "取消")
        cancelStr.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: UIFont.systemFont(ofSize: 20), range: NSRange.init(location:0, length: cancelStr.length))

        //         action.setValue(cancelStr, forKey: "attributedTitle")
        
        alert.addAction(delAction)
        alert.addAction(action)
        alert.show()
    }
    
    func setTabaleView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "EmailDetailCell", bundle: nil), forCellReuseIdentifier: "EmailDetailCell")
        self.tableView.register(UINib.init(nibName: "EmailReceivedCell2", bundle: nil), forCellReuseIdentifier: "EmailReceivedCell2")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    }
    
    //MARK: UITableViewDelegate,UITableViewDataSource
    //组
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.dateSource.count != 0 {
            let model:MyEmailModel = self.dateSource[0]
            if model.ReplyMail?.count != 0{
                return  (model.ReplyMail?.count)!

            }else{
                return self.dateSource.count
            }
        }
        
        
        return self.dateSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let vc = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 15))
        vc.backgroundColor = UIColor.white

        if self.dateSource.count != 0 {
            let model:MyEmailModel = self.dateSource[0]
            if model.ReplyMail?.count != 0{
                vc.backgroundColor = RGBA(r: 242, g: 242, b: 246, a: 1)
            }
        }
        return vc
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:MyEmailModel = self.dateSource[0]
        if model.ReplyMail?.count == 0 {
            
            let cell:EmailDetailCell = tableView.dequeueReusableCell(withIdentifier: "EmailDetailCell") as! EmailDetailCell
            cell.setViewValue(model: model)
              self.tableView.backgroundColor = UIColor.white
            return cell
            
        }else {
            
            let mModel:MailModel = model.ReplyMail![indexPath.section]
//            if mModel == model.ReplyMail?.last{
//                let cell:EmailDetailCell = tableView.dequeueReusableCell(withIdentifier: "EmailDetailCell") as! EmailDetailCell
//                cell.setViewValue(model: model)
//                return cell
//                
//            }else{
           
                //回复样式
                let cell:EmailReceivedCell2 = tableView.dequeueReusableCell(withIdentifier: "EmailReceivedCell2") as! EmailReceivedCell2
            cell.setViewValue(model: model,SUBJECT: mModel.SUBJECT!)
            self.tableView.backgroundColor = RGBA(r: 242, g: 242, b: 246, a: 1)
                return cell
//            }

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        cell?.setSelected(false, animated: false)
        
    }
    
    
    /// 删除框
    func showDelAlert() {
        
        let alert = UIAlertController.init(title: "删除邮件", message: nil, preferredStyle: .alert)
        alert.addAction(title: "取消", style: .cancel, isEnabled: true) { (action) in
            
        }
        alert.addAction(title: "删除", style: .default, isEnabled: true) { (action) in
            
            
            self.vm.askForDelEmailDetail(TID: self.dateSource[0].TID ?? "", { (code, remark) in
                
                if code == "200" {
                    HUD.flash(.label(remark), delay: 1.5){_ in
                        
                        self.navigationController?.popViewController()
                        
                        //
                        let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
                        NotificationCenter.default.post(name: notificationName, object: self,
                                                        userInfo:["type":EmailListShowType[0], "cound" : EmailListShowType[1]])
                    }
                }else {
                    HUD.flash(.label(remark), delay: 1.5)
                }
                
            })
        }
        
        alert.show()
        
    }
    
    
    /// 回复
    func answerEmail() {
        
        let vc:PostEmailViewController = PostEmailViewController()
        vc.titleStr = "回复邮件"
        vc.TIDStr = self.dateSource[0].TID!
        vc.zhutiStr = self.dateSource[0].SUBJECT!
        vc.shoujianren = self.dateSource[0].FromName!
        vc.shoujianrenID = self.dateSource[0].FROM!
        self.navigationController?.pushViewController(vc, animated: true)
        

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
