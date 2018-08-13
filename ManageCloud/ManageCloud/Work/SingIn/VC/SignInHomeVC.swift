//
//  SignInHomeVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import ReactiveObjC
import PKHUD

let SignRecordTCellID = "SignRecordTCellID"
let SignHomeHeaderTCellD = "SignHomeHeaderTCellD"

let refreshSignHome = "refreshSignHome"

class SignInHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var naviLB: UILabel!
    @IBOutlet weak var naviHeight: NSLayoutConstraint!
    @IBOutlet weak var tableTop: NSLayoutConstraint!
    @IBOutlet weak var naviView: UIView!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var signLB: UILabel!
    
    @IBOutlet weak var Table: UITableView!
    
    var data: [SignListModel] = [SignListModel]()
    /*** 上传的日期 ***/
    var dayCommitString: String = ""
    /*** 显示的日期 ***/
    var dayString: String = ""
    
    var timer: Timer!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        refreshTime()
        Table.reloadData()
        loadData()
        observe()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullScreen()
        creatTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        denitTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableTop.constant = -KStatusBarH
        naviHeight.constant = KStatusBarH + KNaviBarH
        headerView.height = KWidth / 375 * 150 + KStatusBarH + KNaviBarH
        Table.tableHeaderView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        signLB.textColor = BlueColor
        timeLB.textColor = BlueColor
        Table.register(UINib.init(nibName: "SignRecordTCell", bundle: nil), forCellReuseIdentifier: SignRecordTCellID)
        Table.register(UINib.init(nibName: "SignHomeHeaderTCell", bundle: nil), forCellReuseIdentifier: SignHomeHeaderTCellD)
        Table.tableFooterView = UIView()
        Table.estimatedRowHeight = 100.0
        Table.estimatedSectionFooterHeight = 0.0
        Table.estimatedSectionHeaderHeight = 0.0
        view.bringSubview(toFront: naviView)
        naviView.backgroundColor = RGBA(r: 57, g: 152, b: 245, a: 0.0)
        naviLB.alpha = 0.0
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
    }
    
    fileprivate func observe() {
        NotificationCenter.default.rac_addObserver(forName: refreshSignHome, object: nil).take(until: self.rac_willDeallocSignal()).subscribeNext {[weak self] (x) in
            self?.loadData()
        }
    }
    
    @objc fileprivate func refreshTime() {
        let date = Date.init(timeIntervalSinceNow: 0)
        let dateString = date.dateString(format: "yyyy-MM-dd HH:mm", locale: "en_US_POSIX")
        dayCommitString = dateString.components(separatedBy: " ").first!
        dayString = dayCommitString.replacingOccurrences(of: ["-"], with: ".")
        let hourString = dateString.components(separatedBy: " ").last!
        timeLB.text = hourString
    }
    
    fileprivate func loadData() {
        SignInVM.LoadPerDaySignList(withTid: MyOid(), date: dayCommitString, sucBlock: {[weak self] (modelArr) in
            if let dataArr = modelArr{
                self?.data = dataArr
            }
            else{
                self?.data = [SignListModel]()
            }
            self?.Table.reloadData()
        }) { (resFail) in
            HUD.flash(.labeledError(title: nil, subtitle: resFail.remark), delay: 1.0)
        }
    }
    
    fileprivate func creatTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(refreshTime), userInfo: nil, repeats: true)
    }
    
    fileprivate func denitTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    fileprivate func fullScreen() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func ToTrack(_ sender: UIButton) {
        let vc = SignTrackVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ToSignIn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SignInEditStory", bundle: nil).instantiateViewController(withIdentifier: "SignInEdit")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController()
    }
    
    //MARK:- UITableView Delegate / DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let model = data[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: SignRecordTCellID, for: indexPath) as! SignRecordTCell
            cell.selectionStyle = .none
            cell.type = .MineTodaySign
            cell.countLB.text = String(data.count - indexPath.row)
            cell.myTodaySignModel = model
            cell.separatorInset = UIEdgeInsetsMake(0, 70, 0, 16)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SignHomeHeaderTCellD, for: indexPath) as! SignHomeHeaderTCell
            cell.dayLB.text = "(\(dayString))"
            cell.selectionStyle = .none
            cell.moreBtn.rac_signal(for: .touchUpInside).take(until: cell.rac_prepareForReuseSignal as! RACSignal<AnyObject>).subscribeNext {[weak self] (x) in
                let vc = SignRecordVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        DPrint(scrollView.contentOffset.y )
        let percent = (scrollView.contentOffset.y + 20) / (240.0 - KStatusBarH - KNaviBarH)
        naviView.backgroundColor = RGBA(r: 57, g: 152, b: 245, a: percent)
        naviLB.alpha =  percent
    }

}
