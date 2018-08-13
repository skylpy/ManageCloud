//
//  WorkCommandDateilController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class WorkCommandDateilController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    @IBOutlet weak var tableLayoutConstaintB: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var table: UITableView!
    var oid:String!
    var userid:String!
    
    let MyCommandDateilCellID = "MyCommandDateilCellID"
    let MyCommandInfoCellID = "MyCommandInfoCellID"
    let MyCommandThingCellID = "MyCommandThingCellID"
    let JournalCommentCellID = "JournalCommentCellID"
    let NoCommentCellID = "NoCommentCellID"
    
    lazy var commandModel:CommandDateilModel = {
        
        let model = CommandDateilModel()
        
        return model
    }()
    
    lazy var headerView:UIView = {
        
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 50))
        header.backgroundColor = UIColor.clear
        
        let boby = UIView.init(frame: CGRect(x: 0, y: 10, width: KWidth, height: 40))
        boby.backgroundColor = UIColor.white
        header.addSubview(boby)
        
        let label = UILabel.init(frame: CGRect(x: 15, y: 10, width: KWidth-30, height: 20))
        label.font = UIFont.init(name: kMedFont.rawValue, size: 18)
        label.text = "回复"
        boby.addSubview(label)
        
        let lineView = UIView.init(frame: CGRect(x: 10, y: 39, width: KWidth-10, height: 1))
        lineView.backgroundColor = COLOR(red: 235, green: 235, blue: 237)
        boby.addSubview(lineView)
        
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "指挥详情"
        self.setTableView()
        self.bottomView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestLoad()
    }
    
    func requestLoad() -> () {
        
        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
        CommandModel.commantDateilsRequest(TID: self.oid, userId: self.userid, successBlock: { (list) in
            
            HUD.hide()
            self.commandModel = list[0]

            if self.commandModel.isReply == "是" || self.commandModel.isReply == "需回复" || self.commandModel.isReply == "是：需回复" {
                self.tableLayoutConstaintB.constant = 50
                self.bottomView.isHidden = false
            }
            
            self.table.reloadData()
        }) { (error) in
            HUD.hide()
        }
        
    }
    
    func setTableView() {
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.backgroundColor = UIColor.color(string: "#F2F2F6")
        self.table.tableFooterView = UIView()
        self.table.separatorStyle = .none
        self.table.register(UINib.init(nibName: "MyCommandDateilCell", bundle: nil), forCellReuseIdentifier: MyCommandDateilCellID)
        self.table.register(UINib.init(nibName: "MyCommandInfoCell", bundle: nil), forCellReuseIdentifier: MyCommandInfoCellID)
        self.table.register(UINib.init(nibName: "MyCommandThingCell", bundle: nil), forCellReuseIdentifier: MyCommandThingCellID)
        self.table.register(UINib.init(nibName: "JournalCommentCell", bundle: nil), forCellReuseIdentifier: JournalCommentCellID)
        self.table.register(UINib.init(nibName: "NoCommentCell", bundle: nil), forCellReuseIdentifier: NoCommentCellID)
    }
    
    @IBAction func replyAction(_ sender: UIButton) {
        
        let vc:ReplyCommandController = UIStoryboard.init(name: "MyCommand", bundle: nil).instantiateViewController(withIdentifier: "ReplyCommand") as! ReplyCommandController
        vc.oid = self.oid.intValue
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension WorkCommandDateilController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //&& (self.commandModel.Reply?.count)! > 0
        if section == 2 {
            
            if self.commandModel.isReply == "是" || self.commandModel.isReply == "需回复" || self.commandModel.isReply == "是：需回复" {
                return 50
            }else {
                return 0.01
            }
            
        }
        if section == 1 {
            
            return 10
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //&& (self.commandModel.Reply?.count)! > 0
        if section == 2 {
            
            if self.commandModel.isReply == "是" || self.commandModel.isReply == "需回复" || self.commandModel.isReply == "是：需回复" {
                
                return self.headerView
            }else {
                
                return UIView()
            }
            
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            
            return 123
        }
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                return 77
            }else if indexPath.row == 1 {
                
                return self.commandModel.perform_titlecellHeight!
            }else {
                
                return self.commandModel.perform_contentcellHeight!
            }
        }
        if self.commandModel.Reply == nil || self.commandModel.Reply?.count == 0 {
            
            if self.commandModel.isReply == "是" || self.commandModel.isReply == "需回复" || self.commandModel.isReply == "是：需回复" {
                return 100
            }else {
                return 0.01
            }
        }
        let model:ReplyModel = self.commandModel.Reply![indexPath.row]
        return model.cellHeight!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            
            return 3
        }
        if section == 2 {
            
            if self.commandModel.Reply == nil || self.commandModel.Reply?.count == 0{
                
                return 1
            }
            return (self.commandModel.Reply?.count)!
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell:MyCommandDateilCell = tableView.dequeueReusableCell(withIdentifier: MyCommandDateilCellID, for: indexPath) as! MyCommandDateilCell
            cell.model = self.commandModel
            
            return cell
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
               
                let cell:MyCommandInfoCell = tableView.dequeueReusableCell(withIdentifier: MyCommandInfoCellID, for: indexPath) as! MyCommandInfoCell
                cell.model = self.commandModel
                return cell
            }else {
                
                let cell:MyCommandThingCell = tableView.dequeueReusableCell(withIdentifier: MyCommandThingCellID, for: indexPath) as! MyCommandThingCell
                cell.indexPath = indexPath as NSIndexPath
                cell.model = self.commandModel
                return cell
            }
        }
        if self.commandModel.Reply == nil || self.commandModel.Reply?.count == 0 {
            
            let cell:NoCommentCell = tableView.dequeueReusableCell(withIdentifier: NoCommentCellID, for: indexPath) as! NoCommentCell
            return cell
            
        }
        let cell:JournalCommentCell = tableView.dequeueReusableCell(withIdentifier: JournalCommentCellID, for: indexPath) as! JournalCommentCell
        let model:ReplyModel = self.commandModel.Reply![indexPath.row]
        cell.cmodel = model
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
