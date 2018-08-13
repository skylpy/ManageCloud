//
//  WorkJournalController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

enum JournalEnter {
    case mySelf
    case oterSelf
}

class WorkJournalController: UIViewController,UIScrollViewDelegate {
    
    //自己进入和别人查看区别
    var journalEnter:JournalEnter!
    //自己传MyOid() 别人传别人的ID
    var oid:String!
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var workJournalConstraints: NSLayoutConstraint!
    @IBOutlet weak var lineConstraintsX: NSLayoutConstraint!
    @IBOutlet weak var workScrollView: UIScrollView!
    var myVc:MySendJournalController!
    var orVc:MyReceivedJournalController!
    
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.workJournalConstraints.constant = KWidth*2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "工作日志"
        setNavItem()
    }
    
    func setNavItem() {
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.setTitle("发日志", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        rightButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView:rightButton )
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        let button:UIButton = self.TopView.viewWithTag(1000) as! UIButton
        let button1:UIButton = self.TopView.viewWithTag(1001) as! UIButton
        self.myVc = self.childViewControllers[0] as! MySendJournalController
        self.orVc = self.childViewControllers[1] as! MyReceivedJournalController
        self.myVc.oid = self.oid
        self.orVc.oid = self.oid
        self.myVc.requestLoad()
        self.orVc.requestLoad()
        
        if self.journalEnter == .mySelf {
            
            button.setTitle("我发的", for: .normal)
            button1.setTitle("收到的", for: .normal)
            rightButton.isHidden = false
        }else {
            button.setTitle("他发的", for: .normal)
            button1.setTitle("他收的", for: .normal)
            rightButton.isHidden = true
        }
        
        self.workScrollView.delegate = self
        
        NotificationCenter.default.rac_addObserver(forName: "sendJournal", object: nil).subscribeNext { (noti) in
            
            self.workScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    
    @IBAction func selectAction(_ sender: UIButton) {
        
        for i in [1000,1001] {
            
            let button:UIButton = self.TopView.viewWithTag(i) as! UIButton
            
            button.isSelected = false
        }
        sender.isSelected = true
        
        if sender.tag == 1000 {
            
            UIView.animate(withDuration: 0.25) {
                self.lineConstraintsX.constant = 0
                self.workScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            
        }else {
            
            UIView.animate(withDuration: 0.25) {
                self.lineConstraintsX.constant = KWidth/2
                self.workScrollView.setContentOffset(CGPoint(x: KWidth, y: 0), animated: true)
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for i in [1000,1001] {
            
            let button:UIButton = self.TopView.viewWithTag(i) as! UIButton
            
            button.isSelected = false
        }
        UIView.animate(withDuration: 0.25) {

            if scrollView.contentOffset.x >= KWidth {

                let button:UIButton = self.TopView.viewWithTag(1001) as! UIButton
                button.isSelected = true
                self.lineConstraintsX.constant = KWidth/2
            }else  {
                let button = self.TopView.viewWithTag(1000) as! UIButton
                button.isSelected = true
                self.lineConstraintsX.constant = 0

            }
        }
        
    }
    
    @objc func nextPage() {
        
        let vc = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "SendJournal")
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
