//
//  MessageViewController.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import SGPagingView
import MJRefresh


class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let MsgApplyTcellID = "MsgApplyTcellID"
    let MsgDailyTCellID = "MsgDailyTCellID"
    let MsgOrderTCellID = "MsgOrderTCellID"
    let MsgNoDataTCellID = "MsgNoDataTCellID"
    let naviHeight: CGFloat = 42
    let titleViewHeight: CGFloat = 36
    let moreBtnWidth: CGFloat = 44
    let TableFromTitleViewH: CGFloat = 10.5
    
    
    
    
    //下属列表
    var subPersonArr = [personModel]()
    var NoSubPerson: Bool = true{
        didSet{
            if NoSubPerson{
                self.titleArr = ["我的"]
            }
        }
    }
    //当前加载的人员Model
    var person: personModel!
    //SGTITLEVIEW的标题数组
    var titleArr: [String]!
    
    //申请数组
    var ApplyArr: [String] = [String]()
    //日志数组
    var  LogArr: [HomeLogModel] = [HomeLogModel]()
    //指挥数组
    var  OrderArr: [AddCommandModel] = [AddCommandModel]()
    
    
    
    lazy var naviView: WorkDateView = {
        let view = Bundle.main.loadNibNamed("WorkDateView", owner: nil, options: nil)?.first as! WorkDateView
        view.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: naviHeight + KStatusBarH)
        view.seperator.isHidden = true
        return view
    }()
    
    lazy var peopleView: MsgPeopleView = {
        let peopleView = Bundle.main.loadNibNamed("MsgPeopleView", owner: nil, options: nil)?.first as! MsgPeopleView
        peopleView.size = CGSize.init(width: KWidth, height: KHeight)
        return peopleView
    }()
    
    var pageTitleView:YUSegment!
    
    lazy var morePersonBtn: UIButton = {
        let moreBtn = UIButton.init(frame: CGRect.init(x: KWidth - 44, y: self.naviView.y + naviHeight + KStatusBarH, width: moreBtnWidth, height: titleViewHeight), image: LoadImage("iconPersonList"), highlightedImage: LoadImage("iconPersonList"))
        moreBtn.addTarget(self, action: #selector(morePerson), for: .touchUpInside)
        return moreBtn
    }()
    
    lazy var Table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: self.pageTitleView.y + self.pageTitleView.height + TableFromTitleViewH, width: KWidth, height: KHeight - KTabBarH - self.naviView.y - self.naviView.height - titleViewHeight - TableFromTitleViewH))
        table.register(UINib.init(nibName: "MsgApplyTcell", bundle: nil), forCellReuseIdentifier: MsgApplyTcellID)
        table.register(UINib.init(nibName: "MsgDailyTCell", bundle: nil), forCellReuseIdentifier: MsgDailyTCellID)
        table.register(UINib.init(nibName: "MsgOrderTCell", bundle: nil), forCellReuseIdentifier: MsgOrderTCellID)
        table.register(UINib.init(nibName: "MsgNoDataTCell", bundle: nil), forCellReuseIdentifier: MsgNoDataTCellID)
        table.estimatedRowHeight = 120.0
        table.estimatedSectionFooterHeight = 0.0
        table.estimatedSectionHeaderHeight = 0.0
        table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
        LoadSubPerson()
        
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        naviView.frame = CGRect.init(x: 0, y: 0, width: KWidth, height: naviHeight + KStatusBarH)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Method
    
    fileprivate func fullScreen() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func initUI() {
        view.backgroundColor = COLOR(red: 242, green: 242, blue: 246)
        //当前加载我自己
        person = creatMine()
        //加载只有“我的”
        NoSubPerson = true
        view.addSubview(morePersonBtn)
        resetTitleView()
        view.addSubview(naviView)
        view.addSubview(Table)
    }
    
    fileprivate func resetTitleView() {

    
        let titleView = YUSegment.init(titles: titleArr)
        titleView.frame = CGRect.init(x: 0, y: self.naviView.y + naviHeight + KStatusBarH, width: KWidth, height:titleViewHeight)
        titleView.font = UIFont.init(fontName: kRegFont, size: 15)
        titleView.textColor = GrayTitleColor
        titleView.selectedTextColor = BlueColor
        titleView.indicator.backgroundColor = BlueColor
        titleView.selectedIndex = 0
        titleView.segmentWidth = 80
        titleView.addTarget(self, action: #selector(onSegmentChange), for: .valueChanged)
        var hasTitleView: Bool = false
        for view in view.subviews{
            if view.isKind(of: YUSegment.self){
                hasTitleView = true
            }
        }
        if hasTitleView {
            pageTitleView.removeFromSuperview()
        }
        
        pageTitleView = titleView
        view.addSubview(pageTitleView)
        
        
    }
    
    @objc fileprivate func onSegmentChange() {
        let index = pageTitleView.selectedIndex
        reLoad(index: Int(index))
        //提供给peopleView
        for person in subPersonArr{
            person.isSelete = false
        }
        
        if index != 0{
            let model = subPersonArr[Int(index) - 1]
            model.isSelete = true
        }
    }
    
    fileprivate func reLoad(index: Int) {
        if index == 0 {
            person = creatMine()
        }
        else{
            person = subPersonArr[index - 1]
        }
        loadData()
    }
    
    fileprivate func creatMine() -> personModel {
        let per = personModel()
        per.EIOID = MyOid()
        per.EINAME = MyName()
        return per
    }
    
    
    
    
    @objc fileprivate func loadData() {
        self.Table.mj_header.endRefreshing()
        //更新红点
        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName_ReloadSendEmailList), object: nil)
        
        //日志
        var isSub: Bool = false
        //加载我收到的
        if person.EIOID != MyOid(){
            isSub = true
        }
        
        HomeVM.askHomeLogList(isSub:isSub, Oid:person.EIOID!, sucBlock: { (LogList) in
            self.LogArr.removeAll()
            if LogList != nil{
                self.LogArr  = LogList!
            }
            self.Table.reloadData()
        }) { (resFail) in }
        
        //指挥
        CommandModel.receiveTop3CommantListRequest(OID:person.EIOID!, successBlock: { (OrderList) in
            self.OrderArr.removeAll()
            if OrderList != nil{
                for model in OrderList!{
                    if model.num == "0"{
                        self.OrderArr.append(model)
                    }
                }
            }
            self.Table.reloadData()
        }) { (resFail) in }
        //审批
    }
    
    
    fileprivate func LoadSubPerson() {
        //加载下属列表
        HomeVM.GetKeyPeopleList(sucBlock: { (personArr) in
            if let personArrs = personArr{
                if personArrs.count == 0{
                    self.subPersonArr = [personModel]()
                    self.NoSubPerson = true
                }
                else{
                    self.subPersonArr = personArrs
                    //重置为只有“我的”
                    self.titleArr = ["我的"]
                    for model in self.subPersonArr{
                        self.titleArr.append(model.EINAME!)
                    }
                }
                
            }
            else{
                self.subPersonArr = [personModel]()
                self.NoSubPerson = true
            }
            //前
            self.resetTitleView()
            //后
            if self.subPersonArr.count >= 5{
                
                self.view.bringSubview(toFront: self.morePersonBtn)
                self.pageTitleView.width = KWidth - self.moreBtnWidth
            }
            self.peopleView.data = self.subPersonArr
            self.Table.mj_header.endRefreshing()
        }) { (failRes) in
            self.Table.mj_header.endRefreshing()
        }
    }
    
    
    @objc fileprivate func morePerson() {
        
        peopleView.seletedBlock = {[weak self] (data, index) in
            self?.subPersonArr = data
            self?.person = data[index]
            let oldIndex = self?.pageTitleView.selectedIndex
            self?.pageTitleView.selectedIndex = UInt(index+1)
            self?.pageTitleView.moveIndicator(from: oldIndex!, to: UInt(index+1), widthShouldChange: true)
        }
        peopleView.data = subPersonArr
        peopleView.show()
        if subPersonArr.count == 0 {
            LoadSubPerson()
        }
        
        
    }
    
    
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ApplyArr.count == 0 && LogArr.count == 0 && OrderArr.count == 0 {
            return 1
        }
        else{
            switch section {
            case 0:
                return ApplyArr.count
            case 1:
                return LogArr.count
            default:
                return OrderArr.count
            }
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if ApplyArr.count == 0 && LogArr.count == 0 && OrderArr.count == 0 {
            return 1
        }
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ApplyArr.count == 0 && LogArr.count == 0 && OrderArr.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MsgNoDataTCellID, for: indexPath) as! MsgNoDataTCell
            cell.selectionStyle = .none
            return cell
        }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MsgApplyTcellID, for: indexPath) as!  MsgApplyTcell
            if  person.EIOID == MyOid() {
                cell.isMine = true
            }
            cell.selectionStyle = .gray
            return cell
            
        case 1:
            let model = LogArr[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: MsgDailyTCellID, for: indexPath) as!  MsgDailyTCell
            cell.selectionStyle = .gray
            cell.logModel = model
            return cell
        case 2:
            let model = OrderArr[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: MsgOrderTCellID, for: indexPath) as!  MsgOrderTCell
            cell.selectionStyle = .gray
            cell.model = model
            return cell
           
        default:
            return UITableViewCell.init()
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//             if ApplyArr.count == 0 && LogArr.count == 0 && OrderArr.count == 0{
//                return KHeight - KStatusBarH - KNaviBarH - titleViewHeight - KTabBarH - TableFromTitleViewH
//            }
//            return 68
//        case 1:
//            return 168
//        case 2:
//            return 123
//        default:
//            return 0
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        //审批
        case 0:
            DPrint("哈哈哈")
        //日志
        case 1:
            let model = LogArr[indexPath.row]
            let vc:WorkJournalDateilController = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "WorkJournalDateil") as! WorkJournalDateilController
            vc.OID = model.OID
            navigationController?.pushViewController(vc, animated: true)
        //指挥
        case 2:
            let model = OrderArr[indexPath.row]
            let vc:WorkCommandDateilController = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "WorkCommandDateil") as! WorkCommandDateilController
            vc.oid = model.pk_id
            vc.userid = model.userid
            navigationController?.pushViewController(vc, animated: true)
        default:
            DPrint("哈哈哈")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && ApplyArr.count == 0{
            return 0.1
        }
        if section == 1 && LogArr.count == 0{
            return 0.1
        }
        if section == 2 && OrderArr.count == 0{
            return 0.1
        }
        return 36
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && ApplyArr.count == 0{
            return nil
        }
        if section == 1 && LogArr.count == 0{
            return nil
        }
        if section == 2 && OrderArr.count == 0{
            return nil
        }
        let headview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 36))
        headview.backgroundColor = UIColor.white
        var headerName = ""
        switch section {
        case 0:
            headerName = "申请审批"
        case 1:
            headerName = "工作日志"
        case 2:
            headerName = "指挥信息"
        default:
            print("")
        }
        let label = UILabel.init(frame: CGRect.init(x: 16, y: 11, width: 72, height: 25), text: headerName, font: UIFont.init(fontName: kRegFont, size: 18), color: DarkTitleColor, alignment: .left, lines: 1)
        headview.addSubview(label)
        let separ = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 0.25), backgroundColor: GrayTitleColor)
        headview.addSubview(separ)
        //只有是我的时候才可以查看全部
//        if  person.EIOID == MyOid()  {
        
            let button = UIButton.init(frame: CGRect.init(x: KWidth - 16 - 56, y: 14, width: 56, height: 20), title: "查看全部")
            button.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 14)
            button.setTitleColor(BlueColor, highlightedColor: BlueColor)
            
            button.rac_signal(for: .touchUpInside).take(until: self.rac_willDeallocSignal()).subscribeNext { (x) in
                switch section {
                case 0:
                    print("0")
                    
                case 1:
                    print("1")
                    let vc:WorkJournalController = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "WorkJournal") as! WorkJournalController
                    if self.person.EIOID == MyOid(){
                        vc.journalEnter = .mySelf
                    }
                    else{
                        vc.journalEnter = .oterSelf
                    }
                    
                    vc.oid = self.person.EIOID
                    self.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let vc:WorkCommandController = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "WorkCommand") as! WorkCommandController
                    if self.person.EIOID == MyOid(){
                        vc.commandEnter = .mySelf
                    }
                    else{
                        vc.commandEnter = .oterSelf
                    }
                    vc.oid = self.person.EIOID
                    self.navigationController?.pushViewController(vc, animated: true)
                    print("2")
                default:
                    print("")
                }
            }
            headview.addSubview(button)
//        }
        
        
        
        return headview
        
        
        
    }

}
