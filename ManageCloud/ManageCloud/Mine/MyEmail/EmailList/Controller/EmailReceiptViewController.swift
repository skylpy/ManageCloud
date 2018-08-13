//
//  EmailReceiptViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh
import PKHUD

/// 刷新列表
let NotificationName_ReloadSendEmailList = "NotificationName_ReloadSendEmailList"
/// 刷新列表邮件状态 (暂时不做)
let NotificationName_PostEmailState = "NotificationName_PostEmailState"
/// 刷新某个cell的状态
let NotificationName_EmailCell = "NotificationName_EmailCell"

 /// 保存类型 用于下拉刷新、各种通知刷新列表
var EmailListShowType:[String] = ["收件箱","全部邮件"]{
    
    didSet{
        
        
        if EmailListShowType[0] == "发件箱" {
            let notificationName1 = Notification.Name(rawValue: NotificationName_PostEmailBack)
            NotificationCenter.default.post(name: notificationName1, object: nil,userInfo: nil)
            
            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo:["type":EmailListShowType[0], "cound" : EmailListShowType[1]])

        }else{
            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo:["type":EmailListShowType[0], "cound" : EmailListShowType[1]])
        }
    }
}


class EmailReceiptViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    var listVM:EmailListVM = EmailListVM()
    
    var dateSource:[MyEmailModel] = [MyEmailModel]()
    
    // 保存选中的cell 用于更新
    var saveSelectCell:EmailReceiptCell2 = EmailReceiptCell2()
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.initDate()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTableView()
        
//        self.initDate()
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.initDate()
        })
        
        self.tableView.mj_header.beginRefreshing()
        
        //监听点击了发件箱
        self.addNotification()

    }
    
    //MARK: 数据请求
    
    func initDate(){
        
//        HUD.show(.progress)
       // self.dateSource.removeAllObjects()
        self.tableView.reloadData()
        
        listVM.askForEmailList(listType: EmailListShowType[0], condType: EmailListShowType[1], { (modelAry) in
            HUD.hide()
            self.dateSource = modelAry
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        },{ (fail) in
//            HUD.hide()
            self.tableView.mj_header.endRefreshing()
        })
    }


    func setTableView() {
        
        self.tableView.register(UINib.init(nibName: "EmailReceiptCell2", bundle: nil), forCellReuseIdentifier: "EmailReceiptCell2")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()

    }
    
    //MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dateSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EmailReceiptCell2 = tableView.dequeueReusableCell(withIdentifier: "EmailReceiptCell2", for: indexPath) as! EmailReceiptCell2
        let model:MyEmailModel = self.dateSource[indexPath.row]
        cell.setViewValue(model: model)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveSelectCell = tableView.cellForRow(at: indexPath) as! EmailReceiptCell2
        
        let emailDetail = EmailDetailViewController()
        let model:MyEmailModel = self.dateSource[indexPath.row]
        emailDetail.strTID = model.TID
        self.navigationController?.pushViewController(emailDetail, animated: true)
    }
    
    // 通知
    func addNotification() {
        
        // 刷新列表
        let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
        NotificationCenter.default.addObserver(self,selector:#selector(loadList(notification:)),
                                               name: notificationName, object: nil)
        
        // 刷新记录点击发送邮件的 cell的发送状态
        let notificationPost = Notification.Name(rawValue: NotificationName_PostEmailState)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(loadListState(notification:)),
                                               name: notificationPost, object: nil)
        
        let notificationCell = Notification.Name(rawValue: NotificationName_EmailCell)
        NotificationCenter.default.addObserver(self,selector:#selector(RearchCell(notification:)),
                                               name: notificationCell, object: nil)
    }
    
    @objc func loadList(notification: Notification) {
        
        if notification.userInfo == nil {
            return;
        }
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        if userInfo.count == 0 {
            print("警告：发送通知刷新邮件的参数空了！！！")
            return;
        }
        let type = userInfo["type"] as! String
        let cond = userInfo["cound"] as! String
        
//      HUD.show(.progress)
//        self.dateSource.removeAllObjects()
//        self.tableView.reloadData()
        
        self.listVM.askForEmailList(listType: type, condType: cond, { (modelAry) in
            
            //self.dateSource.removeAllObjects()
            self.dateSource = modelAry;
            self.tableView.reloadData()
//            HUD.hide()
        },{ (fail) in
            
//            HUD.hide()
        })
    }
    
    /// 暂时不用
    @objc func loadListState(notification: Notification) {
        
//        let userInfo = notification.userInfo as! [String: PostEmailViewController]
//        let controller:PostEmailViewController = userInfo["controller"]!
//        controller.sendAction()
//        controller.postInitDate({ (isSuccess) in
//
//            if isSuccess == true {
//                self.saveSelectCell.timeLB.text = "发送中"
//                self.saveSelectCell.timeLB.textColor = RGBA(r: 245, g: 166, b: 35, a: 1)
//            }
//
//        }) { (fail) in
//
//
//        }
    }

    @objc func RearchCell(notification: Notification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let read = userInfo["read"] as! Bool
        if read {
            self.saveSelectCell.readCell()

        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationName_ReloadSendEmailList), object: nil)
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
