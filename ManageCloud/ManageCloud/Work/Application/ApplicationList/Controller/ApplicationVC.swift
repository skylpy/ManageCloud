//
//  ApplicationVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh
import PKHUD

//iPhone 6设计图 高度适配
func AdaptedHeight(h:CGFloat) -> CGFloat {
    let AW =  ceilf(Float(h)) *  Float( KHeight/667.0)
    return CGFloat(AW)
}

/// 根据类型刷新我的工作流
let NotificationName_ReloadMineWorkFlow = "NotificationName_ReloadMineWorkFlow"

var MineWorkFlowType = "全部"{
    didSet{
        
        //发送通知
        let notificationName = Notification.Name(rawValue: NotificationName_ReloadMineWorkFlow)
        
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: ["type":MineWorkFlowType])
        
        //发送通知  刷新有数据的工作流cell和无工作流的cell的类型显示
        let notificationName2 = Notification.Name(rawValue: NotificationName_ShareMineWorkType)
        NotificationCenter.default.post(name: notificationName2, object: nil,
                                        userInfo: nil)
    }
}

class ApplicationVC: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    /// 审批列表数据
    var applicationSource:[ApplicationModel] = [ApplicationModel]()
    
    /// 我的工作流列表数据
    var mineFlowSource:[(section:String, list:[ApplicationMineModel])] = [(section:String, list:[ApplicationMineModel])]()
    /// 我的工作流列表数据(未处理的数据)
    var mineFlowOldSource = [ApplicationMineModel]()
    
    
    /// 弹性View
//    var interestingV:UIView!
    /// 半圆背景图
    var imgbackV:UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initDate(type: MineWorkFlowType)
        initUI()
        setTableView()
        addNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTableView() {
        
        HUD.show(.progress,onView: self.view)
        
        //无待审批cell
        tableView.register(UINib.init(nibName: "ApplicationLisNotApplyCell", bundle: nil), forCellReuseIdentifier: "ApplicationLisNotApplyCell")
        //无工作流cell
         tableView.register(UINib.init(nibName: "ApplicationLisNotMineCell", bundle: nil), forCellReuseIdentifier: "ApplicationLisNotMineCell")
        
        //待审批cell
        tableView.register(UINib.init(nibName: "ApplicationApplyCell", bundle: nil), forCellReuseIdentifier: "ApplicationApplyCell")
        //我的工作流cell
        tableView.register(UINib.init(nibName: "ApplicationMineCell", bundle: nil), forCellReuseIdentifier: "ApplicationMineCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 22))
        if KHeight > 667 {
            self.tableView.tableHeaderView?.height = 32
        }else if KHeight == 667{
            self.tableView.tableHeaderView?.height = 22
        }else{
            self.tableView.tableHeaderView?.height = 11
        }

    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "申请审批"
        view.backgroundColor = UIColor.white
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 30), title: "已审批")
        button.addTarget(self, action: #selector(ToApprovedList), for: .touchUpInside)
        var rightItem = UIBarButtonItem.init(customView: button)
        navigationItem.rightBarButtonItem = rightItem
        
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(color:BlueColor), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.backgroundColor = UIColor.white
        
        //设置tableView的背景
        self.imgbackV = UIImageView(image: UIImage.init(named: "Rectangle"))
        self.imgbackV.isUserInteractionEnabled = false
        self.imgbackV.frame = self.tableView.bounds
//        self.imgbackV.height = 667
        
//        interestingV = UIView.init(frame: CGRect.init(x: 0, y: -KHeight  , width: KWidth, height: KHeight))
//        interestingV.backgroundColor = BlueColor
//        self.tableView.addSubview(interestingV)

        self.tableView.backgroundView = imgbackV
//        self.view.addSubview(imgbackV)
        self.view.bringSubview(toFront: tableView)
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.initDate(type: MineWorkFlowType)
        })
        
        self.tableView.sendSubview(toBack: imgbackV)
        self.tableView.bringSubview(toFront: self.tableView.mj_header)
    }
    
    //MARK: 数据请求
    func initDate(type:String) {
        /// 审批请求结束标识
//        var appEnd = 0
        /// 我的工作流请求结束标识
//        var mineEnd = 0
        
        
        let vm = ApplicationVM()
        vm.askForApplicationList({ (modelAry) in
            
            self.applicationSource = modelAry
            
            vm.askForMineWorkList(type: type,{ (modelAry,oldModel) in
                
                self.mineFlowSource = modelAry
                self.mineFlowOldSource = oldModel
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                HUD.hide()
                
            }) { (fail) in
                self.tableView.mj_header.endRefreshing()
            }
            
        }) { (fail) in
            self.tableView.mj_header.endRefreshing()
        }
        

    }
    
    // 点击已审批
    @objc func ToApprovedList(){

//        let vc = FlowListVC()
//        let vc = UIStoryboard(name: "Approval", bundle: nil).instantiateViewController(withIdentifier: "ApprovalDetails") as! ApprovalDetailsController
//        navigationController?.pushViewController(vc, animated: true)

        
//        let vc = FlowListVC()
//        navigationController?.pushViewController(vc, animated: true)
        
        let endAppy = EndApplicationListViewController()
        self.navigationController?.pushViewController(endAppy, animated: true)

    }
    
    
    //MARK: TableViewDelegate/TableViewDataSoucrce
    
    //行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == 0 {// 待审批分组
//            if self.applicationSource.count == 0 {
//                return 1
//            }
//            
//            return self.applicationSource.count
//            
//        }else{// 我的工作流分组
//            
//            if self.mineFlowSource.count == 0 {
//                return 1
//            }
//            
//            return self.mineFlowSource.count
//        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if self.applicationSource.count == 0 {
                //无审批
                let cell:ApplicationLisNotApplyCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationLisNotApplyCell") as! ApplicationLisNotApplyCell
                return cell
            }
            
            //有审批
            let cell:ApplicationApplyCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationApplyCell") as! ApplicationApplyCell
            cell.setViewValue(model: self.applicationSource)

            return cell
        }
        if self.mineFlowSource.count == 0 {
            
            //无工作流
            let cell:ApplicationLisNotMineCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationLisNotMineCell") as! ApplicationLisNotMineCell

            return cell
        }
        
//        let model = mineFlowSource[indexPath.row]
        
        //有工作流
        let cell:ApplicationMineCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationMineCell") as! ApplicationMineCell
        cell.setViewValue(model: mineFlowSource , oldModel: self.mineFlowOldSource)
        return cell
    }
    
    //监听
    func addNotification() {
        
        let notificationName = Notification.Name(rawValue: NotificationName_ReloadMineWorkFlow)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(reloadMineWorkFlow(notification:)),
                                               name: notificationName, object: nil)
        
    }
    
    @objc func reloadMineWorkFlow(notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let value1 = userInfo["type"] as! String
        self.initDate(type: value1)
    }
    
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 弹性动画效果
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        self.interestingV.y =  self.interestingV.y + scrollView.contentOffset.y
//
//        self.imgbackV.y =  self.imgbackV.y + scrollView.contentOffset.y
    }

}
