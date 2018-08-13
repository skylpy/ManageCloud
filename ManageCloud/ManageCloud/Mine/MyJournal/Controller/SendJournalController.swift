//
//  SendJournalController.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/15.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
import AssetsLibrary
import Photos

class SendJournalController: UIViewController,UITableViewDataSource,UITableViewDelegate,PickerToolDelegate {

    lazy var dataArray:NSMutableArray = {
        
        let array = NSMutableArray()
        
        array.addObjects(from: SendJournalInit.sendList() as! [Any])
        
        return array
    }()
    
    lazy var selectArr:NSMutableArray = {
        
        let arr = NSMutableArray()
        
        return arr
    }()
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var bottomConstraintsLayout: NSLayoutConstraint!
    var selectedDate: Date = Date()
    var selectedAssets: [PHAsset] = [PHAsset]()
    var selectedPhotos: [UIImage] = [UIImage]()
    var selectedVideos: [PHAsset] = [PHAsset]()
    var pickTool: PickerTool? = nil
    var selectedPersonStr : String? = ""
    var tableDateSource:[AttachmentInfo] = [AttachmentInfo]()
    var vm:PostEmailVM = PostEmailVM()
    var model:PostEmailModel = PostEmailModel()
    
    let SendTitleCellID = "SendTitleCellID"
    let SendTextCellID = "SendTextCellID"
    let AttachmentJournalCellID = "AttachmentJournalCellID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavItem()
        self.addNotification()
        NotificationCenter.default.rac_addObserver(forName: "textViewDidChange", object: nil).subscribeNext { (noti) in
            
            self.table.reloadData()
        }
    }
    
    func setTableView() {
        
        self.table.delegate = self
        self.table.dataSource = self
     
        self.table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: KWidth, height: 50))
        
        self.table.register(UINib.init(nibName: "SendTitleCell", bundle: nil), forCellReuseIdentifier: SendTitleCellID)
        self.table.register(UINib.init(nibName: "SendTextCell", bundle: nil), forCellReuseIdentifier: SendTextCellID)
        self.table.register(UINib.init(nibName: "AttachmentJournalCell", bundle: nil), forCellReuseIdentifier: AttachmentJournalCellID)
    }
    
    func setNavItem() {
        
        self.title = "发日志"
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.setTitle("发送", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        rightButton.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView:rightButton )
        
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    @objc func sendRequest() {
        
        self.view.endEditing(false)
        
        let ReceiveEID = self.journalTT(indexS: 0, indexR: 0)
        let GDATE = self.journalTT(indexS: 0, indexR: 1)
        let TodayPlan = self.journalTT(indexS: 1, indexR: 0)
        let TomorrowPlan = self.journalTT(indexS: 2, indexR: 0)
        
        if ReceiveEID == "未选择" ||  GDATE == "未选择" || TodayPlan == "" || TomorrowPlan == "" || TodayPlan == "请输入今日完成的工作" || TomorrowPlan == "请输入明天计划的工作"{
            
            HUD.flash(.labeledError(title: "", subtitle: "请填写完整内容"), delay: 2)
            return
        }
        
        if self.selectedPhotos.count == 0 && self.selectedVideos.count == 0 {
            
            self.sendJournal(type: 0)
            return;
        }
        
        if self.selectedPhotos.count > 0 {
            
            /// 上传附件 (图片类型)
            self.postIMG()
            
        }else {
            /// 上传附件 (视频类型)
            self.postVideo()
        }
    }
    
    func sendJournal(type:NSInteger) -> () {
        
        let ReceiveEID = self.journalTT(indexS: 0, indexR: 0)
        let GDATE = self.journalTT(indexS: 0, indexR: 1)
        let TodayPlan = self.journalTT(indexS: 1, indexR: 0)
        let TomorrowPlan = self.journalTT(indexS: 2, indexR: 0)
        
        HUD.show(.progress, onView: UIApplication.shared.keyWindow)
        JournalModel.sendJournalRequest(ReceiveEID: self.selectedPersonStr!, GDATE: GDATE, TodayPlan: TodayPlan, TomorrowPlan: TomorrowPlan, CreateEID: MyOid(),array: tableDateSource, successBlock: { (list) in
            HUD.hide()
            HUD.flash(.labeledSuccess(title: "", subtitle: "发表成功"), onView: UIApplication.shared.keyWindow, delay: 2, completion: { (isbool) in
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "sendJournal"))); self.navigationController?.popViewController(animated: true)
            })
            
        }) { (error) in
            HUD.hide()
            HUD.flash(.labeledError(title: "", subtitle: "请求错误"), delay: 2)
        }
    }
    
    func journalTT(indexS:NSInteger,indexR:NSInteger) -> String {
        
        let conentList:NSArray = self.dataArray[indexS] as! NSArray
        let conentModel:SendJournalInit = conentList[indexR] as! SendJournalInit
        
        return conentModel.conent!
        
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        
        
        self.view.endEditing(false)
        
        if pickTool == nil{
            pickTool = PickerTool.init(MaxCount: 100, selectedAssets: self.selectedAssets)
            pickTool?.delegate = self
            pickTool?.allowPickingVideo = true
            
        }
        pickTool?.selectedAssets = self.selectedAssets
        present((pickTool?.imagePickerVcC)!, animated: true) {}
    }
    
    deinit {
        // 删除键盘监听
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SendJournalController {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableDateSource.count != 0 {
            
            if section == 1 {
                
                return 0
            }
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 45
            
        }else if indexPath.section == 1 {
            
            return 50
        }
        let list:NSMutableArray = self.dataArray[indexPath.section-1] as! NSMutableArray
        let model:SendJournalInit = list[indexPath.row] as! SendJournalInit
        return model.conentH!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataArray.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 2
        } else if section == 1 {
            
            if tableDateSource.count == 0 {
                
                return 0
            }
            return tableDateSource.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            
            let list:NSMutableArray = self.dataArray[indexPath.section] as! NSMutableArray
            let model:SendJournalInit = list[indexPath.row] as! SendJournalInit
            let cell:SendTitleCell = tableView.dequeueReusableCell(withIdentifier: SendTitleCellID, for: indexPath) as! SendTitleCell
            cell.model = model
            return cell
            
        }
        else if indexPath.section == 1{
            
            let cell:AttachmentJournalCell = tableView.dequeueReusableCell(withIdentifier: AttachmentJournalCellID, for: indexPath) as! AttachmentJournalCell
            cell.iconButton.setImage(UIImage.init(named: "icon_delete-1"), for: .normal)
            cell.indexPath = indexPath as NSIndexPath
            cell.amodel = self.tableDateSource[indexPath.row]
            cell.didButton = { (index) in
                
                self.tableDateSource.remove(at: index.row)
                self.selectedAssets.remove(at: index.row)
                self.table.reloadData()
            }
            return cell
        }
        let list:NSMutableArray = self.dataArray[indexPath.section-1] as! NSMutableArray
        let model:SendJournalInit = list[indexPath.row] as! SendJournalInit
        let cell:SendTextCell = tableView.dequeueReusableCell(withIdentifier: SendTextCellID, for: indexPath) as! SendTextCell
        cell.indexpath = indexPath as NSIndexPath
        cell.sendType = 0
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section != 0 {
            
            return
        }
        
        let list:NSMutableArray = self.dataArray[indexPath.section] as! NSMutableArray
        let model:SendJournalInit = list[indexPath.row] as! SendJournalInit
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let vc = SelectVC()
                vc.type = .multi
                vc.personType = .AllPerson
                vc.selectedArr = self.selectArr as! [personModel]
                vc.finishSelectBlock = { (list) in
                    
                    self.selectArr.removeAllObjects()
                    self.selectArr.addObjects(from: list)
                    self.selectedPersonStr = ""
                    model.conent = ""
                    for pmodel:personModel in list {
                        
                        if self.selectedPersonStr == "" {
                            
                            model.conent = String(format:"%@",pmodel.EINAME!)
                            self.selectedPersonStr = String(format:"%@(%@)",pmodel.EINAME!,pmodel.EIOID!)
                        }else {
                            
                            model.conent = String(format:"%@,%@",model.conent!,pmodel.EINAME!)
                            self.selectedPersonStr = String(format:"%@,%@(%@)",self.selectedPersonStr!,pmodel.EINAME!,pmodel.EIOID!)
                        }
                    }

                    self.table.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                
                self.tapDate(model: model)
            }
        }
    }
    
    @objc fileprivate func tapDate(model:SendJournalInit) {
        var pickerSetting = DatePickerSetting.init()
        pickerSetting.date = self.selectedDate
        UsefulPickerView.showDatePicker("选择日期", datePickerSetting:pickerSetting) { (date) in
            self.selectedDate = date
            model.conent = date.dateString(format: "yyyy-MM-dd", locale: "en_US_POSIX")
            
            self.table.reloadData()

        }
    }
    
    // MARK: - PickerToolDelegate
    func didPickedPhotos() {
        self.selectedPhotos = [UIImage]()
        self.selectedAssets = [PHAsset]()
        self.tableDateSource.removeAll()
        
        if pickTool?.selectedPhotos?.count == 0 {
            return
        }
        if (pickTool?.selectedPhotos?.count)!  > 0{
            let temp = pickTool!.selectedPhotos
            self.selectedPhotos += temp as! [UIImage]
            self.selectedAssets += pickTool?.selectedAssets as! [PHAsset]
        }
        
        for index in 0..<pickTool!.selectedPhotos!.count {
            let photo = self.selectedPhotos[index]
            let asset = self.selectedAssets[index]
            
            let model:AttachmentInfo = AttachmentInfo()
            
            let fileName = asset.value(forKey: "filename")
            model.FileName = fileName as? String
            model.DisplayName = fileName as? String
            let date:Data = UIImagePNGRepresentation(photo)!
            model.FileLen =  FileTools.stringWithFileSize(size: Double(date.count))
            tableDateSource.append(model)
            
        }

        self.table.reloadData()
    }
    
    func didPickedVedio(WithCoverImage coverImage: UIImage, asset:AnyObject){
        self.selectedAssets = [PHAsset]()
        self.selectedAssets += pickTool?.selectedAssets as! [PHAsset]
        let tempAsset:PHAsset = asset as! PHAsset
        let fileName:String = tempAsset.value(forKey: "filename") as! String
        print(fileName)
        let model:AttachmentInfo = AttachmentInfo()
        model.FileName = fileName as? String
        model.DisplayName = fileName as? String
        let videoPath:String = tempAsset.value(forKey: "pathForOriginalFile") as! String
        let fileSize = FileTools.getFileSize(patch: videoPath)
        model.FileLen = fileSize
        self.selectedVideos.append(tempAsset)
        self.selectedAssets.append(tempAsset)
        tableDateSource.append(model)
        
        self.table.reloadData()
        
    }
    
    //MARK: 上传图片类型的附件
    func postIMG() {
        
        /// 上传附件 (图片类型)
        for (index,item) in self.selectedPhotos.enumerated() {
            
            HUD.show(.progress, onView: self.view)
            
            
            self.vm.askForUpdateFile(file: item as AnyObject, PurposeFileName: ".Jpg", URL: WorkLogUpdateFile, { (code, remark,uuid) in
                
                let aModel:AttachmentInfo = self.tableDateSource[index]
                aModel.OID = "0"
                aModel.WFTID = "0"
                aModel.FileName = uuid
                aModel.IsDelete = "0"
                aModel.URL = " "
//                aModel.DisplayName = aModel.DisplayName
                let date:Data = UIImagePNGRepresentation(item)!
                aModel.FileLen =  FileTools.stringWithFileSize(size: CDouble(date.count))
                // 发送通知
                
                //如果最后一个附件上传完
                if (index + 1) == self.selectedPhotos.count{
                    
                    // 上传完成 关闭UHD
                    HUD.hide()
                    
                    // 开始发送
                    self.sendJournal(type: 1)
                }
                
            },{
                //失败
                
                HUD.flash(.label("上传失败"), delay: 1.5)
            })
            
        }
    }
    
    //MARK: 上传Video类型
    func postVideo() {
        
        /// 上传附件 (图片类型)
        for (index,item) in self.selectedVideos.enumerated() {
            
            HUD.show(.progress, onView: self.view)
         
            let videoPath:String = item.value(forKey: "pathForOriginalFile") as! String
            let fileSize = FileTools.getFileSize(patch: videoPath)
            let size = FileTools.getFileSizeNotKB(patch: videoPath)
            
//            if size > 50 * 1024*1024 {
//                HUD.hide()
//                HUD.flash(.label("文件总大小不能超过50MB"), delay: 2)
//
//                return
//            }
            self.vm.askForUpdateFile(file: item as AnyObject, PurposeFileName: ".MP4", URL: WorkLogUpdateFile, { (code, remark,uuid) in

                let aModel:AttachmentInfo = self.tableDateSource[index]
                aModel.OID = "0"
                aModel.WFTID = "0"
                aModel.FileName = uuid
                aModel.IsDelete = "0"
                aModel.URL = " "
                aModel.DisplayName = uuid
                aModel.FileLen = fileSize
                
                // 发送通知
                
                //如果最后一个附件上传完
                if (index + 1) == self.selectedVideos.count{
                    
                    // 上传完成 关闭UHD
                    HUD.hide()
                    
                    self.model.TID = "0"
//                    if self.titleStr == "回复邮件" {
//                        self.model.TID = self.TIDStr
//                    }
//                    self.model.SUBJECT = self.titleView.text
//                    self.model.MCONTENT = self.contentView.text
                    self.model.FROM = MyOid()
                    self.model.ATTACHMENT = self.tableDateSource
                    
                    // 开始发送
                    
                     self.sendJournal(type: 2)
                }
                
            },{
                //失败
                
                HUD.flash(.label("上传失败"), delay: 1.5)
            })
            
        }
    }
    
    /// 监听键盘
    func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.bottomConstraintsLayout.constant = deltaY
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    
    @objc func keyboardWillHidden(note: NSNotification) {
        let userInfo  = note.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.bottomConstraintsLayout.constant = 0
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //点击空白区
        self.view.endEditing(false)
    }
}
