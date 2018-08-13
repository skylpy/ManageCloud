//
//  WorkJournalDateilController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SKPhotoBrowser
import AssetsLibrary
import Photos
import PKHUD

class WorkJournalDateilController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var OID : String? 
    
    lazy var journalModel:JournalDateilModel = {
       
        let model = JournalDateilModel()
        
        return model
    }()
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableLayoutConstraintB: NSLayoutConstraint!
    var vm:EmailDetailVM = EmailDetailVM()
    
    let JournalTitleCellID = "JournalTitleCellID"
    let JournalPaneCellID = "JournalPaneCellID"
    let JournalCommentCellID = "JournalCommentCellID"
    let AttachmentJournalCellID = "AttachmentJournalCellID"
    let NoCommentCellID = "NoCommentCellID"
    
    lazy var headerView:UIView = {
        
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 50))
        header.backgroundColor = UIColor.color(string: "#F2F2F6")
        
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
        
        self.title = "日志详情"
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestload()
    }
    
    func requestload() -> () {
        
        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
        JournalModel.journalDateilRequest(OID: self.OID!, successBlock: { (model) in
            HUD.hide()
            self.journalModel = model

            self.table.reloadData()
            
        }) { (error) in
            HUD.hide()
        }
    }
    
    func setTableView() {
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.tableFooterView = UIView()
        self.table.separatorStyle = .none
        self.table.register(UINib.init(nibName: "JournalTitleCell", bundle: nil), forCellReuseIdentifier: JournalTitleCellID)
        self.table.register(UINib.init(nibName: "JournalPaneCell", bundle: nil), forCellReuseIdentifier: JournalPaneCellID)
        self.table.register(UINib.init(nibName: "JournalCommentCell", bundle: nil), forCellReuseIdentifier: JournalCommentCellID)
        self.table.register(UINib.init(nibName: "AttachmentJournalCell", bundle: nil), forCellReuseIdentifier: AttachmentJournalCellID)
        self.table.register(UINib.init(nibName: "NoCommentCell", bundle: nil), forCellReuseIdentifier: NoCommentCellID)
    }
    
    @IBAction func replyAction(_ sender: UIButton) {
        
        let vc:ReplyJournalController = UIStoryboard.init(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "ReplyJournal") as! ReplyJournalController
        vc.oid = self.OID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WorkJournalDateilController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.journalModel.Attachinfo?.count != 0 {
            if section == 2 {
                
                return 1
            }
            //&& (self.journalModel.RebackInfo?.count)! > 0
            if section == 3 {
                
                return 50
            }
        }else {
            //&& (self.journalModel.RebackInfo?.count)! > 0
            if section == 2 {
                
                return 50
            }
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
        
        if self.journalModel.Attachinfo?.count != 0  {
            if section == 2 {
                
                let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 1))
                headView.backgroundColor = UIColor.white
                
                let lineView = UIView.init(frame: CGRect(x: 15, y: 0, width: KWidth-15, height: 1))
                lineView.backgroundColor = UIColor.init(red: 238, green: 238, blue: 238)
                headView.addSubview(lineView)
                
                return headView
            }
            //&& (self.journalModel.RebackInfo?.count)! > 0
            if section == 3 {
                
                return self.headerView
            }
        }else {
            //&& (self.journalModel.RebackInfo?.count)! > 0
            if section == 2 {
                
                return self.headerView
            }
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.journalModel.Attachinfo?.count != 0  {
            
            switch indexPath.section {
            case 0:
                return 135
            case 1:
                return 50
            case 2:
                if indexPath.row == 0 {
                    return self.journalModel.TodaycellHeight!
                }
                return self.journalModel.TomorrowcellHeight!
            default:
                if self.journalModel.RebackInfo?.count == 0 || self.journalModel.RebackInfo == nil{
                    
                    return 100
                }
                let item:RebackInfoModel = self.journalModel.RebackInfo![indexPath.row]
                return item.cellHeight!
            }
        }

        switch indexPath.section {
        case 0:
            return 135
        case 1:
            if indexPath.row == 0 {
                
                return self.journalModel.TodaycellHeight!
            }
            return self.journalModel.TomorrowcellHeight!
        default:
            if self.journalModel.RebackInfo?.count == 0 || self.journalModel.RebackInfo == nil{
                
                return 100
            }
            
            let item:RebackInfoModel = self.journalModel.RebackInfo![indexPath.row]
            
            return item.cellHeight!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.journalModel.Attachinfo?.count != 0 {
            
            return 4
        }else {
            
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.journalModel.Attachinfo?.count != 0  {
            
            switch section {
            case 0:
                return 1
            case 1:
                return (self.journalModel.Attachinfo?.count)!
                
            case 2:
                return 2
            default:
                
                if self.journalModel.RebackInfo?.count == 0 || self.journalModel.RebackInfo == nil{
                    
                    return 1
                }
                return (self.journalModel.RebackInfo?.count)!
            }
        }
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            if self.journalModel.RebackInfo == nil {
                
                return 0
            }
            if self.journalModel.RebackInfo?.count == 0 || self.journalModel.RebackInfo == nil{
                
                return 1
            }
            return (self.journalModel.RebackInfo?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.journalModel.Attachinfo?.count != 0  {
            
            switch indexPath.section {
            case 0:
                let cell:JournalTitleCell = tableView.dequeueReusableCell(withIdentifier: JournalTitleCellID, for: indexPath) as! JournalTitleCell
                cell.model = self.journalModel
                return cell
            case 1:
                let cell:AttachmentJournalCell = tableView.dequeueReusableCell(withIdentifier: AttachmentJournalCellID, for: indexPath) as! AttachmentJournalCell
                cell.indexPath = indexPath as NSIndexPath
                cell.model = self.journalModel.Attachinfo![indexPath.row]
                cell.didStringButton = { (name,iconButton,model,bgView) in
                    HUD.show(.progress, onView: self.view)
                    self.vm.askForReadFile(URL:WorkLogReadFile, SourceFileName: name) { (ary) in
                        
                        HUD.hide()
                        self.downAction(str: ary[0] as! String,button: iconButton,amodel: model,bgView:bgView)
                    }
                }
                return cell
               
            case 2:
                let cell:JournalPaneCell = tableView.dequeueReusableCell(withIdentifier: JournalPaneCellID, for: indexPath) as! JournalPaneCell
                cell.indexPath = indexPath as NSIndexPath
                cell.model = self.journalModel
                return cell
            default:
                if self.journalModel.RebackInfo?.count == 0 || self.journalModel.RebackInfo == nil{
                    
                    let cell:NoCommentCell = tableView.dequeueReusableCell(withIdentifier: NoCommentCellID, for: indexPath) as! NoCommentCell
                    return cell
                }
                let cell:JournalCommentCell = tableView.dequeueReusableCell(withIdentifier: JournalCommentCellID, for: indexPath) as! JournalCommentCell
                let model:RebackInfoModel = self.journalModel.RebackInfo![indexPath.row]
                cell.model = model
                return cell
            }
        } else {
            
            switch indexPath.section {
            case 0:
                let cell:JournalTitleCell = tableView.dequeueReusableCell(withIdentifier: JournalTitleCellID, for: indexPath) as! JournalTitleCell
                cell.model = self.journalModel
                return cell
            case 1:
                let cell:JournalPaneCell = tableView.dequeueReusableCell(withIdentifier: JournalPaneCellID, for: indexPath) as! JournalPaneCell
                cell.indexPath = indexPath as NSIndexPath
                cell.model = self.journalModel
                return cell
            default:
                if self.journalModel.RebackInfo?.count == 0 || self.journalModel.RebackInfo == nil{
                    
                    let cell:NoCommentCell = tableView.dequeueReusableCell(withIdentifier: NoCommentCellID, for: indexPath) as! NoCommentCell
                    return cell
                }
                let cell:JournalCommentCell = tableView.dequeueReusableCell(withIdentifier: JournalCommentCellID, for: indexPath) as! JournalCommentCell
                let model:RebackInfoModel = self.journalModel.RebackInfo![indexPath.row]
                cell.model = model
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.journalModel.Attachinfo?.count != 0 {

            if indexPath.section == 1 {
                let model:AttachinfoModel = self.journalModel.Attachinfo![indexPath.row]
                let type = model.FileName!.components(separatedBy: ".").last?.uppercased()
                let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                
                let filePath = docuPath.appendingPathComponent(model.FileName!)
                
                let manager = FileManager.default
                let exist = manager.fileExists(atPath: filePath)
                if !exist {
                    
                    HUD.flash(.label("请先下载"), delay: 2)
                    return
                }
                
                //图片
                if type == "PNG" || type == "JPEG" || type == "GIF" || type == "JPG" {
                    //加载本地图片
                    var images = [SKLocalPhoto]()
                    let photo = SKLocalPhoto.photoWithImageURL(filePath)
                    images.append(photo)
                    
                    let browser = SKPhotoBrowser.init(photos: images)
                    browser.initializePageIndex(0)
                    self.present(browser, animated: true, completion: {})
                }
                else{
                    let fileURL = URL.init(fileURLWithPath: filePath)
                    let asset = AVURLAsset.init(url:fileURL, options: nil)
                    let videotracks = asset.tracks(withMediaType: .video)
                    let audioTracks = asset.tracks(withMediaType: .audio)
                    //视频
                    if audioTracks.count > 0 || videotracks.count > 0{
                        let player = AVPlayer.init(url: fileURL)
                        let playerVC = AVPlayerViewController.init()
                        playerVC.player = player
                        self.present(playerVC, animated: true, completion: {})
                        playerVC.player?.play()
                    }
                        //文档
                    else{
                        let vc = PreViewVC()
                        vc.fileName = model.DisplayName!
                        vc.filePath = fileURL
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    /// 下载附件
    func downAction(str:String,button:UIButton,amodel:AttachinfoModel,bgView:UIView)  {
        
        FileTools.createFile(name: amodel.FileName!, baseStr: str, { (code) in
            
            //写入成功
            if code == true {
                
                button.isHidden = true
                //计算文件大小
                let file = UrlForDocument[0].appendingPathComponent(amodel.FileName!)
                let fileSize = FileTools.getFileSize(patch: file.path)
                print(fileSize)
            }
        }) { (size) in
            
            // 已经存在
            let file = UrlForDocument[0].appendingPathComponent(amodel.FileName!)
            let fileSize = FileTools.getFileSize(patch: file.path)
            print(fileSize)
            //            self.titleLabel.text = self.model.WFTID! + "(" + fileSize + ")"
            bgView.backgroundColor = RGBA(r: 223, g: 227, b: 237, a: 1)
            button.isHidden = true
        }
        
    }
}
