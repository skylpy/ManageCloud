 //
//  MyEmailViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import SGPagingView

/// 发送邮件返回
let NotificationName_PostEmailBack = "NotificationName_PostEmailBack"

class MyEmailViewController: UIViewController,SGPageTitleViewDelegate,SGPageContentViewDelegate {
    
    var segment:SGPageTitleView!
    var flipView:SGPageContentView!
    var configure:SGPageTitleViewConfigure!
    var opActionView:EmailListOptionsView!
    var controllerAry:[Any]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
       
        self.title = "邮件"
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.setTitle("发邮件", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .highlighted)
        rightButton.setTitleColor(UIColor.white, for: .selected)
        rightButton.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        rightButton.addTarget(self, action: #selector(writeEmail), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView:rightButton )
//        let rightBtn = UIBarButtonItem.init(title: "发邮件", style: .done, target: self, action: #selector(writeEmail))
        self.navigationItem.rightBarButtonItem = rightItem
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.initFlipTableView()
        self.initListOptions()
        self.addNotification()

    }
    /// 写邮件
    @objc func writeEmail() {
        let postVC = PostEmailViewController(nibName: "PostEmailViewController", bundle: nil)
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
    func initFlipTableView() {

        self.configure = SGPageTitleViewConfigure()
        self.configure.indicatorScrollStyle = SGIndicatorScrollStyleEnd
//        self.configure.indicatorAdditionalWidth = 2
        self.configure.titleFont = UIFont.systemFont(ofSize: 18)
        self.configure.titleSelectedColor = RGBA(r: 57, g: 152, b: 245, a: 1)
        self.configure.indicatorColor = self.configure.titleSelectedColor
        
        self.segment = SGPageTitleView(frame: CGRect(x: 0, y: 0, width: KWidth, height: 50), delegate: self, titleNames: ["收件箱","发件箱","",""], configure: self.configure)
        //self.segment.isUserInteractionEnabled = false
        
        self.view.addSubview(self.segment)
        
        let vc1:EmailReceiptViewController = EmailReceiptViewController()
        let vc2:EmailReceiptViewController = EmailReceiptViewController()
        let bottom = self.segment.y + self.segment.height
        self.flipView = SGPageContentView.init(frame: CGRect(x: 0, y:bottom, width: KWidth, height: KHeight - bottom - KStatusBarH - KNaviBarH), parentVC: self, childVCs: [vc1,vc2])
        self.flipView.delegatePageContentView = self
        self.view.addSubview(self.flipView)
    }
    
    func initListOptions() {
        let opView:UIView = UIView.init(frame: CGRect(x: KWidth/2 , y: 0, width: KWidth/2 , height: 49))
        opView.backgroundColor = UIColor.clear
        
        self.opActionView = UIView.loadFromNib(named: "EmailListOptionsView", bundle: nil)! as! EmailListOptionsView
        opActionView.frame = opView.bounds
        opView.addSubview(opActionView)
        
        self.view.addSubview(opView)

        
    }
    //MARK: SGPageTitleView 代理方法
    func pageTitleView(_ pageTitleView: SGPageTitleView!, selectedIndex: Int) {
        
        if selectedIndex > 1 {
            return
        }
        
       // self.postDate(selectedIndex: selectedIndex)
        self.flipView.setPageContentViewCurrentIndex(selectedIndex)
        
    }
    
    func pageContentView(_ pageContentView: SGPageContentView!, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        
        self.segment.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
         self.postDate(selectedIndex: targetIndex)
        
    }
    
    func postDate(selectedIndex:Int)  {
        
        
        
        if selectedIndex == 1 {
            self.opActionView.changeBtn.isHidden = true
            //发送通知刷新发件箱List NotificationName_ReloadSendEmailList
//            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
//            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"发件箱", "cound" : "全部邮件"])
            /// 保存类型 用于下拉刷新
            EmailListShowType = ["发件箱","全部邮件"]
        }else{
//            self.opActionView.changeBtn.isHidden = false
//            let notificationName = Notification.Name(rawValue: NotificationName_ReloadSendEmailList)
//            NotificationCenter.default.post(name: notificationName, object: self, userInfo:["type":"收件箱", "cound" : self.opActionView.changeBtn.currentTitle!])
            /// 保存类型 用于下拉刷新
            EmailListShowType = ["收件箱",self.opActionView.changeBtn.currentTitle] as! [String]
            self.opActionView.changeBtn.isHidden = false
        }
    }
    
    //监听
    func addNotification() {
        
        let notificationName = Notification.Name(rawValue: NotificationName_PostEmailBack)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(changePostList(notification:)),
                                               name: notificationName, object: nil)
        
    }
    
    @objc func changePostList(notification: Notification) {
        
        self.pageTitleView(self.segment, selectedIndex: 1)
//         self.flipView.setPageContentViewCurrentIndex(1)
    }

    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
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
