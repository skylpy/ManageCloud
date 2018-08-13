//
//  WorkCommandController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

enum CommandEnter {
    case mySelf
    case oterSelf
}

class WorkCommandController: UIViewController,UIScrollViewDelegate {
    
    //自己进入和别人查看区别
    var commandEnter:CommandEnter!
    //自己传MyOid() 别人传别人的ID
    var oid:String!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var workScrollView: UIScrollView!
    @IBOutlet weak var lineConstraintsX: NSLayoutConstraint!
    @IBOutlet weak var workCommandConstraints: NSLayoutConstraint!
    var myVc:MySendCommandController!
    var orVc:MyReceivedCommandController!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.workCommandConstraints.constant = KWidth*2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "指挥信息"
        self.setNavItem()
        
        NotificationCenter.default.rac_addObserver(forName: "commandJournal", object: nil).subscribeNext { (noti) in
            
            //添加指挥成功后跳转指挥详情
            let vc:WorkCommandDateilController = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "WorkCommandDateil") as! WorkCommandDateilController
            vc.oid = noti?.object as! String
            vc.userid = MyOid()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        
        for i in [1000,1001] {
            
            let button:UIButton = self.topView.viewWithTag(i) as! UIButton
            
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
    
    func setNavItem() {
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.setTitle("添加", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        rightButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView:rightButton )
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        let button:UIButton = self.topView.viewWithTag(1000) as! UIButton
        let button1:UIButton = self.topView.viewWithTag(1001) as! UIButton
        self.myVc = self.childViewControllers[0] as! MySendCommandController
        self.orVc = self.childViewControllers[1] as! MyReceivedCommandController
        self.myVc.oid = self.oid
        self.orVc.oid = self.oid
        self.myVc.requstLoad()
        self.orVc.requestLoad()
        
        if self.commandEnter == .mySelf {
            
            button.setTitle("我发的", for: .normal)
            button1.setTitle("收到的", for: .normal)
            rightButton.isHidden = false
        }else {
            button.setTitle("他发的", for: .normal)
            button1.setTitle("他收的", for: .normal)
            rightButton.isHidden = true
        }
        
        self.workScrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for i in [1000,1001] {
            
            let button:UIButton = self.topView.viewWithTag(i) as! UIButton
            
            button.isSelected = false
        }
        
        UIView.animate(withDuration: 0.25) {
            
            if scrollView.contentOffset.x >= KWidth {
                self.lineConstraintsX.constant = KWidth/2;
                let button:UIButton = self.topView.viewWithTag(1001) as! UIButton
                button.isSelected = true
            }else {
                self.lineConstraintsX.constant = 0;
                let button = self.topView.viewWithTag(1000) as! UIButton
                button.isSelected = true
            }
        }
    }
    
    @objc func nextPage() {
        
        let vc = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "MyAddCommand")
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
