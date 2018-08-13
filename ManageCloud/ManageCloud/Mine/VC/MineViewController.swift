//
//  MineViewController.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import MJRefresh

class MineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let MineTCellID = "MineTCellID"
    
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var headerShdow: UIView!
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var heagImgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var depLB: UILabel!
    @IBOutlet weak var signLB: UILabel!
    
    @IBOutlet weak var Table: UITableView!
    var mineVM: PersonInfoVM = PersonInfoVM()
    
    @IBOutlet weak var tableTopToSelfView: NSLayoutConstraint!
    
    lazy var dataSource: [[String:String]] = {
//        let row1 = ["img":"iconApply","name":"我的申请"]
        let row2 = ["img":"iconSign","name":"我的签到"]
        let row3 = ["img":"iconDaily","name":"我的日志"]
        let row4 = ["img":"iconOrder","name":"我的指挥"]
        let row5 = ["img":"iconHistry","name":"我的邮件"]
        var data = [[String:String]]()
//        data.append(row1)
        data.append(row2)
        data.append(row3)
        data.append(row4)
        data.append(row5)
        return data
    }()
    
    var model:PersonInfoModel = PersonInfoModel(){
        didSet{
            nameLB.text = model.Name
            if let gongsi = HSInstance.share.userInfo?.SuoSuGongSiName {
                if let bumen = HSInstance.share.userInfo?.DNAME{
                    depLB.text = gongsi + "-" + bumen
                }
                else{
                    depLB.text = gongsi
                }
            }
            else{
                if let bumen = HSInstance.share.userInfo?.DNAME{
                    depLB.text = bumen
                }
                else{
                    depLB.text = "无所属部门资料"
                }
            }
            
            signLB.text = (model.Descr?.isEmpty)! ? "给自己添加一条简介吧~" : model.Descr
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullScreen()
        self.tableTopToSelfView.constant = -KStatusBarH
        loadDetail()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
 
    }
    
    // MARK: - Custom Method
    
    @objc fileprivate func loadDetail() {
        mineVM.askForPersonInfo({ [weak self](smodel) in
            self?.Table.mj_header.endRefreshing()
            if smodel.count > 0{
                self?.model = smodel[0]
                
            }
        }) {
            self.Table.mj_header.endRefreshing()
        }
    }
    
    fileprivate func initUI() {
        view.backgroundColor = UIColor.white
        nameLB.textColor = DarkTitleColor
        depLB.textColor = GrayTitleColor
        signLB.textColor = GrayTitleColor
        nameLB.font = UIFont.init(fontName: kRegFont, size: 18)
        depLB.font = UIFont.init(fontName: kRegFont, size: 14)
        signLB.font = UIFont.init(fontName: kRegFont, size: 12)
        headerShdow.layer.shadowRadius = 10
        headerShdow.layer.shadowColor = RGBA(r: 35, g: 55, b: 91, a: 0.24).cgColor
        headerShdow.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        headerShdow.layer.shadowOpacity = 1
        headerShdow.clipsToBounds = false
        headerContainer.layer.cornerRadius = 10
        headerContainer.layer.masksToBounds = true
        
        Table.register(UINib.init(nibName: "MineTCell", bundle: nil), forCellReuseIdentifier: MineTCellID)
        Table.estimatedRowHeight = 0.0
        Table.estimatedSectionFooterHeight = 0.0
        Table.estimatedSectionHeaderHeight = 0.0
        Table.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        Table.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadDetail))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableHeaderView.height = (KWidth - 16 * 2) / 343 * (130 + 16 * 2) + 10
        Table.tableHeaderView = tableHeaderView
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func fullScreen() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- UITableView Delegate / DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource.count
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineTCellID, for: indexPath) as! MineTCell
        let model = dataSource[indexPath.row]
        cell.nameLB.text = model["name"]
        cell.imgV.image = LoadImage(model["img"]!)
        cell.selectionStyle = .gray
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 3{//邮件
            let myEmail = MyEmailViewController()
            self.navigationController?.pushViewController(myEmail, animated: true)
            
        }
        else if indexPath.row == 1 {
            let vc:WorkJournalController = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "WorkJournal") as! WorkJournalController
            vc.journalEnter = .mySelf
            vc.oid = MyOid()
            self.navigationController?.pushViewController(vc, animated: true)
//            let vc = UIStoryboard.init(name: "Approval", bundle: nil).instantiateViewController(withIdentifier: "ApprovalDetails")
//
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            let vc:WorkCommandController = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "WorkCommand") as! WorkCommandController
            vc.commandEnter = .mySelf
            vc.oid = MyOid()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 0 {
            let vc = SignInHomeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 62.5
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 17
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "退出登录", message: nil, defaultActionButtonTitle: "取消", tintColor: nil)
        alert.addAction(title: "退出", style: .default) { (action) in
            HSInstance.share.newUserInfo = nil
            HSInstance.share.userInfo = nil
            AppDelegate.share().configLaunchVC()
        }
        alert.show(animated: true, vibrate: true, completion: nil)
    }
    
    @IBAction func selectHeader(_ sender: Any) {
        
        let setVC = MySettingViewController()
        self.navigationController?.pushViewController(setVC, animated: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
