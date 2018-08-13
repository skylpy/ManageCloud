//
//  WorkViewController.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import iCarousel
import MJRefresh

struct WorkItem {
    var icon: String = ""
    var name: String = ""
}

let WorkAnounceTCellID = "WorkAnounceTCellID"
let WorkItemTCellID = "WorkItemTCellID"

class WorkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,WorkItemTCellDelegate, iCarouselDataSource, iCarouselDelegate{
    ////
    //轮播定时器
    var timer: Timer? = nil
    let carouselHeight: CGFloat = 154
    lazy var cardsArr: [String] = [String]()
    //公告
    var announce: String = ""
    
    var annouceData:[String] = ["暂无公告"]
    
    var cusAuthority: HomeAuthorityModel? = nil
    
    lazy var naviView: WorkDateView = {
        let view = Bundle.main.loadNibNamed("WorkDateView", owner: nil, options: nil)?.first as! WorkDateView
        view.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: 42 + KStatusBarH)
        return view
    }()
    
    
    lazy var carousel: iCarousel = {
        var carouselFake:iCarousel = iCarousel.init(frame: CGRect.init(x: 16, y: 15, width: KWidth - 30, height: carouselHeight))
        carouselFake.delegate = self
        carouselFake.dataSource = self
        carouselFake.type = .rotary
        carouselFake.bounces = false
        return carouselFake
    }()
    
    lazy var announceVM: AnnouncementVM = AnnouncementVM()
    
    
    
    
    lazy var headerView: UIView = {
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 30 + carouselHeight))
        backView.addSubview(self.carousel)
        return backView
    }()
    
    
    
    lazy var itemData: [[WorkItem]] = {
        var data = [[WorkItem]]()
        var row1 = [WorkItem]()
        let item1 = WorkItem.init(icon: "iconRing", name: "公告管理")
        let item3 = WorkItem.init(icon: "iconSign", name: "考勤签到")
        let item4 = WorkItem.init(icon: "iconDaily", name: "工作日志")

        let item2 = WorkItem.init(icon: "iconOrder", name: "指挥信息")
        row1.append(item1)
        row1.append(item2)
        row1.append(item3)
        row1.append(item4)
        var row2 = [WorkItem]()
        let item5 = WorkItem.init(icon: "iconApply", name: "申请审批")
//        let item6 = WorkItem.init(icon: "iconRead", name: "审批管理")
//        let item7 = WorkItem.init(icon: "iconOrder", name: "指挥信息")
//        let item6 = WorkItem.init(icon: "iconRead", name: "审批管理")
//        let item8 = WorkItem.init(icon: "iconProvider", name: "供应商")
        row2.append(item5)
//        row2.append(item6)
//        row2.append(item7)
//        row2.append(item8)
        var row3 = [WorkItem]()
//        let item9 = WorkItem.init(icon: "iconNotice", name: "库存信息")
        let item10 = WorkItem.init(icon: "iconExamine", name: "日报表")
        let item11 = WorkItem.init(icon: "iconCustomer", name: "支出周报")
        let item12 = WorkItem.init(icon: "iconPlace", name: "收入周报")
//        row3.append(item9)
        row3.append(item10)
        row3.append(item11)
        row3.append(item12)
        data.append(row1)

        data.append(row2)
        data.append(row3)
        return data
    }()
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.naviView.y + self.naviView.height, width: KWidth, height: KHeight - KTabBarH - self.naviView.y - self.naviView.height))
        table.register(UINib.init(nibName: "WorkAnounceTCell", bundle: nil), forCellReuseIdentifier: WorkAnounceTCellID)
        table.register(UINib.init(nibName: "WorkItemTCell", bundle: nil), forCellReuseIdentifier: WorkItemTCellID)
        table.estimatedRowHeight = 0.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        table.tableFooterView = UIView()
        table.tableHeaderView = self.headerView
        table.delegate = self
        table.dataSource = self
        table.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addTimer()
        loadData()
        loadAuthority()
    }
    
    fileprivate func loadAuthority() {
        HomeVM.GetAuthority(sucBlock: { (authorArr) in
            for item in authorArr{
                if item.Name == "客户信息管理"{
                    self.cusAuthority = item
                    if item.Sel == "True"{
                        MCSave.saveData(Basic: item.Adds, withKey: "Adds")
                        MCSave.saveData(Basic: item.Edit, withKey: "Edit")
                        var row2 = [WorkItem]()
//                        var row2 = self.itemData[1]
                        let item7 = WorkItem.init(icon: "iconCus", name: "客户列表")
                        row2.append(item7)
//                        self.itemData[1] = row2
                        self.itemData.append(row2)
                        self.Table.reloadData()
                    }
                }
            }
        }) { (resFail) in
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        naviView.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: 42 + KStatusBarH)
    }
    
    
    deinit {
        removeTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullScreen()
        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName_ReloadSendEmailList), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Custom Method
    
    @objc fileprivate func loadData() {
        //更新红点
        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName_ReloadSendEmailList), object: nil)
        //更新公告轮播
//        HomeVM.GetHomeGongGao(sucBlock: { (string) in
//            self.Table.mj_header.endRefreshing()
//            self.announce = string
//            self.Table.reloadData()
//        }) { (failRes) in
//            self.Table.mj_header.endRefreshing()
//        }
        self.announceVM.askForAnnouncementList( {[weak self] (modelAry) in
            self?.annouceData.removeAll()
            self?.Table.mj_header.endRefreshing()
            for model in modelAry{
                self?.annouceData.append(model._subject!)
            }
            if modelAry.count == 0{
                self?.annouceData.append("暂无公告~")
            }
            self?.Table.reloadData()
        }){
            self.Table.mj_header.endRefreshing()
        }
        
        
        
    }
    
    fileprivate func addTimer() {
        timer = Timer.init(timeInterval: 2.0, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    fileprivate func removeTimer() {
        timer?.invalidate()
    }
    
    @objc fileprivate func nextImage() {
        //        DPrint("哈哈哈")
        var index = carousel.currentItemIndex + 1
        if index == self.cardsArr.count {
            index = 0
        }
        carousel.scrollToItem(at: index, animated: true)
    }
    

    
    
    fileprivate func initUI() {
        view.backgroundColor = UIColor.white
        cardsArr.append("banner")
        
        view.addSubview(self.naviView)
        view.addSubview(self.Table)
        
        
    }
    
    fileprivate func fullScreen() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - iCarouselDelegate
    func numberOfItems(in carousel: iCarousel) -> Int {
        return cardsArr.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if view == nil{
            let showImgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: carousel.width, height: carousel.height))
            let imgUrl = cardsArr[index]
            showImgV.image = LoadImage(imgUrl)
            showImgV.contentMode = .scaleToFill
            return showImgV
        }
        return view!
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.1
        }
        if option == .wrap {
            return 1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        removeTimer()
    }
    
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: WorkAnounceTCellID, for: indexPath) as! WorkAnounceTCell
            cell.selectionStyle = .none
            cell.data = annouceData
            return cell
        }
        else{
            let rowData: [WorkItem] = itemData[indexPath.row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: WorkItemTCellID, for: indexPath) as! WorkItemTCell
            cell.rowModel = rowData
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 39
        }
        else{
            return 113
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didSelectItemName(_ name: String) {
        if name == "公告管理" {
            DPrint(name)
            let vc = AnnouncementViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "申请审批" {
            DPrint(name)
            let vc = ApplicationVC()
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "考勤签到" {
            DPrint(name)
            let vc = SignInHomeVC()
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else if name == "工作日志" {
//            let vc = SelectVC()
//            vc.type = .multi
//            vc.personType = .AllPerson
//            vc.finishSelectBlock = {(personArr) in
//                
//            }
//            navigationController?.pushViewController(vc, animated: true)
            DPrint(name)
            let vc:WorkJournalController = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "WorkJournal") as! WorkJournalController
            vc.journalEnter = .mySelf
            vc.oid = MyOid()
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if name == "指挥信息" {
            DPrint(name)
            let vc:WorkCommandController = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "WorkCommand") as! WorkCommandController
            vc.commandEnter = .mySelf
            vc.oid = MyOid()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "审批管理" {
            DPrint(name)
        }
        else if name == "客户列表" {
            DPrint(name)
            let vc = CusHomeVC()
            vc.cusAuthority = self.cusAuthority
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "供应商" {
            DPrint(name)
        }
        else if name == "库存信息" {
            DPrint(name)
        }
        else if name == "日报表" {
            DPrint(name)
            let vc = DailyReportViewController()
            self.navigationController?.pushViewController(vc)
            
        }
        else if name == "支出周报" {
            DPrint(name)
            let vc = OutWeekReportViewController()
            self.navigationController?.pushViewController(vc)
            
        }
        else if name == "收入周报" {
            DPrint(name)
            let vc = WeekReportViewController()
            self.navigationController?.pushViewController(vc)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
