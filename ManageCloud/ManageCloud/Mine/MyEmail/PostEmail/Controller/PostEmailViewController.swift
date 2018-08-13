//
//  PostEmailViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import GrowingTextView
import AssetsLibrary
import Photos
import PKHUD
import TZImagePickerController


class PostEmailViewController: UIViewController,GrowingTextViewDelegate,PickerToolDelegate {
    
    /// 收件人
    @IBOutlet weak var shouPersonLB: UILabel!
    /// 收件人点击区域
    @IBOutlet weak var shouPersonBnt: UIButton!
    ///内容
    @IBOutlet weak var  contentView:GrowingTextView!
    
    var selectedAssets: [PHAsset] = [PHAsset]()
    var selectedPhotos: [UIImage] = [UIImage]()
    var selectedVideos: [PHAsset] = [PHAsset]()
    
    var pickTool: PickerTool? = nil
    ///主题
    @IBOutlet weak var titleView:GrowingTextView!

    ///附件bar距离底部
    @IBOutlet weak var attachmentViewBottom: NSLayoutConstraint!
    /// 用于确定tableview的frame
    @IBOutlet weak var tableContentView: UIView!
    var tableview:AttachmentTableView!
    /// 附件model 数组
    var tableDateSource:[AttachmentInfo] = [AttachmentInfo]()
    /// 高度 用于动态计算tableView
    @IBOutlet weak var tableViewContentViewHeight: NSLayoutConstraint!
    
    /// 当有附件的时候显示一条线
    @IBOutlet weak var lineView: UIView!
    /// 收件人高度
    @IBOutlet weak var shoujianHeight: NSLayoutConstraint!
    /// 主题高度
    @IBOutlet weak var zhutiHeight: NSLayoutConstraint!
    /// 内容高度
    @IBOutlet weak var neirongHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewMaxHeight: NSLayoutConstraint!
    
    var vm:PostEmailVM = PostEmailVM()
    var model:PostEmailModel = PostEmailModel()
    
    var shouPersonAry = [personModel]()
    
//    @IBOutlet weak var viewMaxBottom: NSLayoutConstraint!
    @IBOutlet weak var scView: UIScrollView!
    //    var scView:UIScrollView!
    
    /// 发邮件or回复邮件
    var titleStr = "发邮件"
    var TIDStr = "0"
    var zhutiStr = ""
    var shoujianren = ""
    var shoujianrenID = " "
    
    
    
    
//    override func loadView() {
//
//        self.scView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight))
//        self.view = self.scView
//
//    }
    override func viewDidLayoutSubviews() {
//        self.scView.contentSize = CGSize.init(width: 0, height: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化没有附件的高度
        tableViewContentViewHeight.constant = 0;
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.setTitle("发送", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .highlighted)
        rightButton.setTitleColor(UIColor.white, for: .selected)
        rightButton.titleLabel?.font = UIFont.init(fontName: kRegFont, size: 17)
        rightButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView:rightButton )
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.title = titleStr

        
        
        if self.titleStr == "回复邮件" {
            self.titleView.text = self.zhutiStr
            self.contentView.becomeFirstResponder()
//            self.titleView.isUserInteractionEnabled = false
            self.shouPersonLB.text = self.shoujianren
            self.model.SHOU = self.shoujianren + "(" + self.shoujianrenID + ")"
            self.shouPersonBnt.isUserInteractionEnabled = false
            
        }else{

            self.titleView.becomeFirstResponder()
//            self.titleView.isUserInteractionEnabled = true
        }
        
        self.titleView.placeholder = "请输入主题(不超过60个字)"
        self.titleView.tag = 100
        self.titleView.font = UIFont.systemFont(ofSize: 16)
        self.titleView.delegate = self
        self.contentView.placeholder = "请输入邮件正文"
        self.contentView.tag = 200
        self.contentView.delegate = self
        self.contentView.font = UIFont.systemFont(ofSize: 16)
        
        self.tableview = AttachmentTableView()
        self.tableview.frame = self.tableContentView.bounds
        self.tableview.width = KWidth
        self.tableview.tabviewHeight = self.tableViewContentViewHeight
        self.tableContentView.addSubview(self.tableview)
        
        self.tableview.postDelPhotoBlock = {(asset,photos)in
            
            // 刷新附件的资源
            self.selectedAssets.removeAll()
            self.selectedAssets = asset
            self.selectedPhotos.removeAll()
            self.selectedPhotos = photos
            if self.selectedAssets.count == 0 {
                self.lineView.isHidden = true
            }
        }
        
        self.tableview.postDelVideoBlock = {(asset,videos)in
            
            // 刷新附件的资源
            self.selectedAssets.removeAll()
            self.selectedAssets = asset
            self.selectedVideos.removeAll()
            self.selectedVideos = videos
            if self.selectedAssets.count == 0 {
                self.lineView.isHidden = true
            }
        }
        
        
        self.addNotification()
    }

    /// 发送 数据请求
    @objc func sendAction() {
        
        //发送
//        let notificationName = Notification.Name(rawValue: NotificationName_PostEmailState)
//        NotificationCenter.default.post(name: notificationName, object: self,
//                                        userInfo: ["controller":self])
        
        self.view.endEditing(false)

        if self.model.SHOU == "" {
            HUD.flash(.label("请选择收件人"),delay:1.5)
            return
        }
        
        //如果没有附件就直接发送
        if self.selectedPhotos.count == 0 && self.selectedVideos.count == 0 {
            
            // 发送邮件
            self.sendeEmail(type: 0)
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
    
    /// 发送邮件的接口
    /// type: 0 没有 1图片 2视频
    func sendeEmail(type:Int) {
        
        if self.titleView.text == "" {
            HUD.flash(.label("请输入主题"),delay:1.5)
            return;
        }
        if self.contentView.text == "" {
             HUD.flash(.label("请输内容"),delay:1.5)
        }
        
        if type == 0 {//有没有附件
            self.model.ATTACHMENT =  [AttachmentInfo]()
            
            self.model.TID = "0"
            self.model.SUBJECT =  self.titleView.text

            if self.titleStr == "回复邮件" {
                self.model.TID = self.TIDStr
                self.model.SUBJECT =   self.titleView.text
            }
            self.model.MCONTENT = self.contentView.text

            self.model.FROM = MyOid()
        }
        
        if self.model.SHOU == "" {
            HUD.flash(.label("请选择收件人"),delay:1.5)
            return
        }
        
        
        /// 发送
        self.vm.askForPostEmail(postM: self.model) {(code, remark)in
            
            if code == "200"{
                HUD.flash(.label(remark), delay: 1.5){_ in
                    
                    if self.titleStr == "回复邮件"{
                        self.navigationController?.popViewController()
                        
                        let aryController = self.navigationController?.viewControllers
                        for item in aryController!{
                            if item is MyEmailViewController {
                                self.navigationController?.popToViewController(item, animated: true)
                            }
                        }

                    }else {
                        self.navigationController?.popViewController()
                    }
                    
                    /// 发送通知
//                    let notificationName = Notification.Name(rawValue: NotificationName_PostEmailBack)
//                    NotificationCenter.default.post(name: notificationName, object: self,userInfo: nil)
                    EmailListShowType = ["发件箱","全部邮件"]
                }
                
            }else {
                HUD.flash(.label(remark), delay: 1.5)
            }
        }

    }
    
    @IBAction func selectContextFirst(_ sender: UIButton) {
        self.contentView.becomeFirstResponder()
    }
    
    /// 点击收件人区域
    @IBAction func SHUOAction(_ sender: UIButton) {
        
        let vc:SelectVC =  SelectVC()
        vc.type = .multi
        vc.personType = .AllPerson
        vc.selectedArr = self.shouPersonAry
        vc.finishSelectBlock = {(personAry) in
            
            self.shouPersonAry = personAry
            self.setShuo()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 收件人赋值
    func setShuo() {
        var strUI = ""
        var SHOUModelStr:String = ""
        
        for index in self.shouPersonAry {
            
            let model:personModel = index
            strUI =  strUI +  model.EINAME! + "、"
            //"SHOU":"用户管理员(2),测试人员(3)"
            var SHOU:String = ""
            SHOU =  "(" + model.EIOID! + ")" + ","
            SHOU =   model.EINAME! + SHOU
            SHOUModelStr = SHOUModelStr + SHOU
        }
        // 处理收件人UI 、
        if strUI != ""{
            strUI.remove(at: strUI.index(before: strUI.endIndex))
        }
        self.shouPersonLB.text = strUI
        self.shouPersonLB.textColor = UIColor.black
        // 处理请求数据
        self.model.SHOU = SHOUModelStr //"用户管理员(2),测试人员(3)"
        if self.model.SHOU == "" {
            self.shouPersonLB.text = "未选择"
            self.shouPersonLB.textColor = RGBA(r: 152, g: 152, b: 156, a: 1)
        }
        
    }
    
    /// 选择附件
    @IBAction func upLoadFile(_ sender: UIButton) {
        
//        if pickTool == nil{
            pickTool = PickerTool.init(MaxCount: 999, selectedAssets: self.selectedAssets)
            pickTool?.delegate = self
            pickTool?.allowPickingVideo = true
            
//        }
//        pickTool?.selectedAssets = self.selectedAssets
        present((pickTool?.imagePickerVcC)!, animated: true) {}
        
    }
    
    // MARK: - PickerToolDelegate 选中图片
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
            //文件大小
            let date:Data = UIImagePNGRepresentation(photo)!
            model.FileLen =  FileTools.stringWithFileSize(size: Double(date.count))
//            if date.count > 1024 * 1024 * 5 {
//                HUD.flash(.label("单个文件不能大于5M"), delay: 1.0)
//                self.selectedPhotos.remove(photo)
//                self.selectedAssets.remove(asset)
//                return
//            }
            
            tableDateSource.append(model)
            
        }
        self.tableview.cellIonType = .deleteType
        self.tableview.setViewValue(model: tableDateSource)

        lineView.isHidden = false
        
        self.tableview.selectedPhotos = self.selectedPhotos
        self.tableview.selectedAssets = self.selectedAssets
//        self.tableViewContentViewHeight.constant = self.tableview.height
        let maxHeight = self.tableview.tabviewHeight.constant  +  self.zhutiHeight.constant + self.neirongHeight.constant + self.shoujianHeight.constant
        
        self.scView.contentSize = CGSize.init(width: 1, height: maxHeight + KStatusBarH + KNaviBarH + 80)
        self.viewMaxHeight.constant =  self.scView.contentSize.height
//        self.viewMaxHeight.constant =  self.scView.contentSize.height + CGFloat((selectedAssets.count * AttachmentCellRowHeight))
       self.view.layoutIfNeeded()
    }
    
    // MARK: - PickerToolDelegate 选中视频
    func didPickedVedio(WithCoverImage coverImage: UIImage, asset:AnyObject){
        
        self.selectedAssets += pickTool?.selectedAssets as! [PHAsset]
        let tempAsset:PHAsset = asset as! PHAsset
        let fileName:String = tempAsset.value(forKey: "filename") as! String
            print(fileName)
        let model:AttachmentInfo = AttachmentInfo()
        model.FileName = fileName as? String
        model.DisplayName = fileName as? String
        //文件大小
        let videoPath:String = tempAsset.value(forKey: "pathForOriginalFile") as! String
        let fileSize = FileTools.getFileSize(patch: videoPath)
        model.FileLen = fileSize
        
//         let aSize = FileTools.getFileSizeNotKB(patch: videoPath)
//        if aSize > 1024 * 1024 * 5 {
//            HUD.flash(.label("单个文件不能大于5M"), delay: 1.0)
//            self.selectedAssets.remove(tempAsset)
//            return
//        }
        
        self.selectedVideos.append(tempAsset)
        tableDateSource.append(model)
       
        self.tableview.cellIonType = .deleteType
        self.tableview.setViewValue(model: tableDateSource)
        self.tableview.selectedVideos = self.selectedVideos

        lineView.isHidden = false
        
        let maxHeight = self.tableview.tabviewHeight.constant  +  self.zhutiHeight.constant + self.neirongHeight.constant + self.shoujianHeight.constant
        
        self.scView.contentSize = CGSize.init(width: 1, height: maxHeight + KStatusBarH + KNaviBarH + 80)
        self.viewMaxHeight.constant = self.scView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    
    //MARK: 上传图片类型的附件
    func postIMG() {
        
        if self.model.SHOU == "" {
            HUD.flash(.label("请选择收件人"),delay:1.5)
            return
        }
       var maxSize = 0
        
        for (index,item) in self.selectedPhotos.enumerated() {
              let aModel:AttachmentInfo = self.tableDateSource[index]
             let date:Data = UIImagePNGRepresentation(item)!
            maxSize = date.count + maxSize
        }
        if maxSize > 1024 * 1024 * 50  {
            
            HUD.flash(.label("附件大小不能超过50M"), delay: 1.0)
            return;
        }
        
        /// 当等于上传的个数 就进行发送
        var successCount = 0
        
        /// 上传附件 (图片类型)
        for (index,item) in self.selectedPhotos.enumerated() {
            
            HUD.show(.progress, onView: self.view)
            
            
            self.vm.askForUpdateFile(file: item as AnyObject, PurposeFileName: ".Jpg", URL: MailUpdateFileURL, { (code, remark,uuid) in
                
                successCount += 1
                
                let aModel:AttachmentInfo = self.tableDateSource[index]
                aModel.OID = "0"
                aModel.WFTID = "0"
                aModel.FileName = uuid 
                aModel.IsDelete = "0"
                aModel.URL = " "
                //文件大小
                let date:Data = UIImagePNGRepresentation(item)!
                aModel.FileLen =  FileTools.stringWithFileSize(size: CDouble(date.count))
                //                aModel.DisplayName =
                
                // 发送通知
                
                //如果最后一个附件上传完
                if successCount == self.selectedPhotos.count{
                    
                    // 上传完成 关闭UHD
                    HUD.hide()
                    
                    self.model.TID = "0"
                    self.model.SUBJECT = self.titleView.text
                    self.model.IsReply = false
                    self.model.P_TID = self.model.TID
                    
                    if self.titleStr == "回复邮件" {
                        self.model.TID = self.TIDStr
                        self.model.SUBJECT =  self.titleView.text
                        self.model.IsReply = true
                        self.model.P_TID = self.TIDStr
                    }
                    
                    self.model.MCONTENT = self.contentView.text
                    self.model.FROM = MyOid()
                    self.model.ATTACHMENT = self.tableDateSource
                    
                    
                    // 开始发送
                    self.sendeEmail(type: 1)
                }
                
            },{
                //失败
                
                HUD.flash(.label("上传失败,请检查网络"), delay: 1.5)
            })
            
        }
    }
    
    //MARK: 上传Video类型
    func postVideo() {
        
        var maxSize = 0
        for (index,item) in self.selectedVideos.enumerated() {
            let aModel:AttachmentInfo = self.tableDateSource[index]
           let asset =  item as! PHAsset
            TZImageManager.default().getVideoWithAsset(asset) { (playerItem, info) in
                
                // 获取文件路劲
                let pathary:String = info!["PHImageFileSandboxExtensionTokenKey"] as!String;
                print("\(pathary)")
                let path =  pathary.components(separatedBy: ";").last
                
                var videoData = NSData(contentsOfFile: path!)
                videoData = videoData?.base64EncodedData(options: [NSData.Base64EncodingOptions(rawValue: 0)]) as! NSData
                maxSize = (videoData?.length)! + maxSize
            }
           
        }
        if maxSize > 1024 * 1024 * 50  {
            
            HUD.flash(.label("附件大小不能超过50M"), delay: 1.0)
            return;
        }
        
        /// 当等于上传的个数 就进行发送
        var successCount = 0
        
        /// 上传附件 (图片类型)
        for (index,item) in self.selectedVideos.enumerated() {
            
            HUD.show(.progress, onView: self.view)
            
            
            self.vm.askForUpdateFile(file: item as AnyObject, PurposeFileName: ".MP4", URL: MailUpdateFileURL, { (code, remark,uuid) in
                
                successCount += 1
                
                let aModel:AttachmentInfo = self.tableDateSource[index]
                aModel.OID = "0"
                aModel.WFTID = "0"
                aModel.FileName = uuid
                aModel.IsDelete = "0"
                aModel.URL = " "
                let videoPath:String = item.value(forKey: "pathForOriginalFile") as! String
                let fileSize = FileTools.getFileSize(patch: videoPath)
                aModel.FileLen = fileSize
                
                //                aModel.DisplayName =
                
                // 发送通知
                
                //如果最后一个附件上传完
                if successCount == self.selectedVideos.count{
                    
                    // 上传完成 关闭UHD
                    HUD.hide()
                    
                    self.model.TID = "0"
                    self.model.SUBJECT =  self.titleView.text

                    self.model.IsReply = false
                    self.model.P_TID = self.model.TID
                    
                    if self.titleStr == "回复邮件" {
                        self.model.TID = self.TIDStr
                        self.model.SUBJECT =  self.titleView.text
                        self.model.IsReply = true
                        self.model.P_TID = self.TIDStr
                    }
                    
                    self.model.MCONTENT = self.contentView.text
                    self.model.FROM = MyOid()
                    self.model.ATTACHMENT = self.tableDateSource
                    
                    // 开始发送
                    self.sendeEmail(type: 2)
                }
                
            },{
                //失败
                
                HUD.flash(.label( "上传失败,请检查网络"), delay: 1.5)
            })
            
        }
    }
    
    /// 监听键盘
    func addNotification() {
        

        
//        NotificationCenter.default.addObserver(self, selector: #selector(textViewNotifitionAction:), name: UITextViewTextDidChangeNotification, object: nil)
        
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
            self.attachmentViewBottom.constant = deltaY
            let test = self.titleView.selectedRange.location
            if self.titleView.text != "" && self.titleView.isFirstResponder == true {
                self.scView.setContentOffset(CGPoint.init(x: 0.00, y: self.scView.contentOffset.y + 50), animated: true)
                
            }
            
            if self.contentView.text != ""  && self.contentView.isFirstResponder == true{
                self.scView.setContentOffset(CGPoint.init(x: 0.00, y: self.scView.contentOffset.y + 50), animated: true)

            }
//            if self.contentView.text != "" {
//
//                self.scView.setContentOffset(CGPoint.init(x: 0.00, y:self.viewMaxHeight.constant - KHeight + deltaY), animated: true)
//            }
            
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
            self.attachmentViewBottom.constant = 2
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    
    deinit {
        // 删除键盘监听
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //点击空白区
        self.view.endEditing(false)
    }
    
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        
        if textView.tag == 100 {
            self.zhutiHeight.constant = height
        }else {
            self.neirongHeight.constant = height + 50
        }
        
        let maxHeight = self.tableview.tabviewHeight.constant  +  self.zhutiHeight.constant + self.neirongHeight.constant + self.shoujianHeight.constant
        
        self.scView.contentSize = CGSize.init(width: 1, height: maxHeight + KStatusBarH + KNaviBarH + 80)
        self.scView.contentOffset =  CGPoint.init(x: 0, y:  self.scView.contentOffset.y + 10)
         self.viewMaxHeight.constant = self.scView.contentSize.height
//        self.viewMaxHeight.constant = self.zhutiHeight.constant + self.neirongHeight.constant
        self.view.layoutIfNeeded()
    }

    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.tag == 100 {
            
            if textView.text.characters.count > 60 {
                
                //获得已输出字数与正输入字母数
                let selectRange = textView.markedTextRange
                
                //获取高亮部分 － 如果有联想词则解包成功
                if let selectRange = selectRange {
                    let position =  textView.position(from: (selectRange.start), offset: 0)
                    if (position != nil) {
                        return
                    }
                }
                
                let textContent = textView.text
                let textNum = textContent?.characters.count
                
                //截取60个字
                if textNum! > 60 {
                    let index = textContent?.index((textContent?.startIndex)!, offsetBy: 60)
                    let str = textContent?.substring(to: index!)
                    textView.text = str
                    HUD.flash(.label("主题不能超过60个字"), onView: nil, delay: 1.0)
                }
            }
            
        }
        
        
        
        //self.textNum = textView.text.characters.count
        //self.numLabel.text =  "(\(self.textNum)/\(TOTAL_NUM))"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        
        return true
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let firstTouch:UITouch = touches.first!
//        let firstPoint = firstTouch.location(in: self.view)
//        let x:CGFloat = firstPoint.x
//        let y:CGFloat = firstPoint.y
//
//    }
    
    /// 再返回邮件列表的时候 邮件列表收到通知会手动调用方法
    //    func postInitDate(_ scuBlock:@escaping(_ code:Bool)->(),_ failBlock:@escaping(_ fail:String)->()) {
    //
    
    //        /// 上传附件
    //        for (index,item) in self.selectedPhotos.enumerated() {
    //
    //            self.vm.askForUpdateFile(file: item as AnyObject, PurposeFileName: ".Jpg", URL: MailUpdateFileURL, { (code, remark,uuid) in
    //
    //                let aModel:AttachmentInfo = self.tableDateSource[index]
    //                aModel.OID = "0"
    //                aModel.WFTID = "0"
    //                aModel.FileName = uuid
    //                //                aModel.DisplayName =
    //
    //                // 发送通知
    //
    //                //如果最后一个附件上传完
    //                if index == self.selectedPhotos.count{
    //
    //                    self.model.TID = "0"
    //                    if self.titleStr == "回复邮件" {
    //                        self.model.TID = self.TIDStr
    //                    }
    //                    self.model.SUBJECT = self.titleView.text
    //                    self.model.MCONTENT = self.contentView.text
    //                    self.model.FROM = MyOid()
    //                    self.model.ATTACHMENT = self.tableDateSource
    //
    //                    /// 发送
    //                    self.vm.askForPostEmail(postM: self.model) {(code, remark)in
    //
    //                        if code == "200"{
    //                            HUD.flash(.label(remark), delay: 1.5){_ in
    //                               // self.navigationController?.popViewController()
    //                                scuBlock(true)
    //                            }
    //
    //                        }else {
    //                            HUD.flash(.label(remark), delay: 1.5)
    //                            failBlock(remark)
    //                        }
    //                    }
    //                }
    //
    //            },{
    //                //失败
    //
    //
    //            })
    //
    //
    //
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
