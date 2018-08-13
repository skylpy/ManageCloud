//
//  AttachmentTableView.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/10.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SKPhotoBrowser
import AssetsLibrary
import Photos

/// 发送选中文件附件刷新数据
let NotificationName_AttachmentReload = "NotificationName_AttachmentReload"

enum AttachmentCellIonType {
    /// 下载
    case downType 
    /// 删除
    case deleteType
}

/// 附件Cell 高度
let AttachmentCellRowHeight = 66

class AttachmentTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    typealias delPhotoBlock = ([PHAsset],[UIImage]) -> Void
    typealias delVideoBlock = ([PHAsset],[PHAsset]) -> Void
    
    var postDelPhotoBlock:delPhotoBlock?
    var postDelVideoBlock:delVideoBlock?
    
    var dateSource:[AttachmentInfo] = [AttachmentInfo]()
    
    var selectedAssets: [PHAsset]? = [PHAsset]()
    var selectedPhotos: [UIImage]? = [UIImage]()
    var selectedVideos: [PHAsset]? = [PHAsset]()
    
    var cellIonType:AttachmentCellIonType = .downType
    
    /// self的父类高度
    var tabviewHeight:NSLayoutConstraint = NSLayoutConstraint()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
         super.init(frame: frame, style: style)
        
        self.bounces = false
        self.isScrollEnabled = false
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = CGFloat(AttachmentCellRowHeight)
        self.register(UINib.init(nibName: "AttachmentCell", bundle: nil), forCellReuseIdentifier: "AttachmentCell")
        self.dataSource = self
        self.delegate = self
        self.separatorStyle = .none
        self.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 6))
        tableHeaderView?.backgroundColor = UIColor.white
        self.tableHeaderView?.height = 6
        
        self.addNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /// 计算高度（删除附件需要再计算一下高度 ）
        if self.dateSource.count == 0 {
            tabviewHeight.constant = CGFloat(self.dateSource.count * AttachmentCellRowHeight)
        }else{
            tabviewHeight.constant = CGFloat(self.dateSource.count * AttachmentCellRowHeight + 6)
        }
        
        return self.dateSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:AttachmentInfo = self.dateSource[indexPath.row]
        
        let cell:AttachmentCell = tableView.dequeueReusableCell(withIdentifier: "AttachmentCell") as! AttachmentCell
        cell.selectedBackgroundView?.tintColor = UIColor.clear
        cell.SetCellType(type: self.cellIonType)
        cell.setViewValue(model: model, index:indexPath)
//        if self.cellIonType ==  .deleteType {
//            cell.Btn.setsImage(UIImage.init(named: "icon_delete"), for: .normal)
//        }else{
//            cell.Btn.setImage(UIImage.init(named: "icon_down"), for: .normal)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! AttachmentCell
        cell.selectionStyle = .none
        cell.setSelected(false, animated: false)
        if !cell.Btn.isHidden {return}
        let model:AttachmentInfo = self.dateSource[indexPath.row]
        
        let type = model.FileName!.components(separatedBy: ".").last?.uppercased()
        let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let filePath = docuPath.appendingPathComponent(model.FileName!)
        //图片
        if type == "PNG" || type == "JPEG" || type == "GIF" || type == "JPG" {
            //加载本地图片
            var images = [SKLocalPhoto]()
            let photo = SKLocalPhoto.photoWithImageURL(filePath)
            images.append(photo)
            
            let browser = SKPhotoBrowser.init(photos: images)
            browser.initializePageIndex(0)
            viewController?.present(browser, animated: true, completion: {})
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
                self.viewController?.present(playerVC, animated: true, completion: {})
                playerVC.player?.play()
            }
            //文档
            else{
                let vc = PreViewVC()
                vc.fileName = model.DisplayName!
                vc.filePath = fileURL
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    /// 赋值
    func setViewValue(model:[AttachmentInfo]) {
        
        self.dateSource = model
        self.height = CGFloat(self.dateSource.count * AttachmentCellRowHeight + 6)
        self.reloadData()

    }
    
    //监听 （发邮件删除附件会触发）
    func addNotification() {
        
        let notificationName = Notification.Name(rawValue: NotificationName_AttachmentReload)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(attachmentReload(notification:)),
                                               name: notificationName, object: nil)
        
    }
    
    @objc func attachmentReload(notification: Notification) {
        
        let index = notification.userInfo!["index"] as! IndexPath
        self.dateSource.remove(at: index.row)
        
        if self.selectedPhotos?.count != 0 {
            
            self.selectedPhotos!.remove(at: index.row)
            self.selectedAssets!.remove(at: index.row)
            
            if postDelPhotoBlock != nil {
                postDelPhotoBlock!(self.selectedAssets!,self.selectedPhotos!)
            }
        }
        
        if self.selectedVideos?.count != 0 {
            
            self.selectedVideos!.remove(at: index.row)
            if postDelVideoBlock != nil {
                postDelVideoBlock!(self.selectedAssets!,self.selectedVideos!)
            }
        }
        
        self.reloadData()
    }

    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
