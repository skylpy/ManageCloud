//
//  AnnouncementDetailVC.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import Tiercel
import AVFoundation
import AVKit
import SKPhotoBrowser
import PKHUD
import Alamofire

class AnnouncementDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var GongGaoV:GongGaoView!
//    var GGAttachmentV:GGAttachmentView!
    var scrollView: UIScrollView = UIScrollView.init()
    var strTid:String? = ""
    var vm:AnnouncementVM = AnnouncementVM()
    var rowDateSouce:[AttachmentModel] = [AttachmentModel]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    /// 标题
    @IBOutlet weak var titleLB: UILabel!
    /// 时间
    @IBOutlet weak var timeLB: UILabel!
    /// 内容
    @IBOutlet weak var ContentLB: UILabel!
    
    var req:DataRequest!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "公告"
        
        self.initTableView()

        let myEiOD = MyOid()
        //MARK:数据请求
        self.vm.askForAnnouncementDetail(strTID: self.strTid!, strEIOD: myEiOD) { (modelAry) in
            
            self.tableView.tableHeaderView = self.GongGaoV
            self.tableView.tableHeaderView?.height = self.GongGaoV.height
            
            self.GongGaoV.setViewValue(model: modelAry, tableView: self.tableView)
            let smodel:AnnouncementModel = modelAry[0]
            self.rowDateSouce =  smodel.thecontent ?? [AttachmentModel]()
            
            self.tableView.reloadData()
            
        }

    }

    func initTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "GGAttachmentViewCell", bundle: nil), forCellReuseIdentifier: "GGAttachmentViewCell")
//        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 50
        
        self.GongGaoV = UIView.loadFromNib(named: "GongGaoView", bundle: nil) as! GongGaoView
        self.tableView.tableHeaderView = UIView()
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "iconBack"), style: .done, target: self, action: #selector( backAction))
    }
    
    @objc func backAction(){
        
        
        req.cancel()
        self.navigationController?.popViewController()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GGAttachmentViewCell = tableView.dequeueReusableCell(withIdentifier: "GGAttachmentViewCell") as! GGAttachmentViewCell
        
        let rowModel:AttachmentModel = self.rowDateSouce[indexPath.section]
        cell.setViewValue(model: rowModel)
        
//         检测是否有下载
//        if rowModel.FileName != nil {
//            self.downAction(str: "", fileName: rowModel.FileName!, indexPath: indexPath)
//        }
//
        if FileTools.exist(name:rowModel.FileName!) {
            
            cell.stateLB.text = "点击打开附件"
        }else {
            cell.stateLB.text = "点击下载附件"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.rowDateSouce.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            
            return 20
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let rowModel:AttachmentModel = self.rowDateSouce[indexPath.section]
        
        if FileTools.exist(name: rowModel.FileName!) {
            
            let cell = tableView.cellForRow(at: indexPath) as! GGAttachmentViewCell
            cell.selectionStyle = .none
            cell.setSelected(false, animated: false)
            let model:AttachmentModel = rowModel
            
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
            return;
        }
        
       
        //let downUrl = rowModel.URL ?? "" + rowModel.FileName!
//        self.vm.askForGongGaoReadFile(strTID: <#T##String#>, <#T##scuBlock: ([AnnouncementModel]) -> ()##([AnnouncementModel]) -> ()#>)
        
        if  NetObserve.isReachableOnEthernetOrWiFi == false {
            
            let alert =  UIAlertController.init(title: nil, message: "当前非WiFi网络,是否继续下载", preferredStyle: .alert)
            alert.addAction(title: "取消", style: .cancel, isEnabled: true) { (action) in
                
                
            }
            
            alert.addAction(title: "下载", style: .default, isEnabled: true) { (action) in
                
                let filevM:EmailDetailVM = EmailDetailVM()
                HUD.show(.progress, onView:self.view)
                self.req = filevM.askForReadFile(URL: GongGaoReadFileURL, SourceFileName: rowModel.FileName!) { (ary) in
                    
                    HUD.hide()
                    self.downAction(str: ary[0] as! String, fileName:rowModel.FileName!,indexPath:indexPath)
                }
            }
            
            alert.show()

            
        }else{
            
            let filevM:EmailDetailVM = EmailDetailVM()
            HUD.show(.progress, onView:self.view)
            filevM.askForReadFile(URL: GongGaoReadFileURL, SourceFileName: rowModel.FileName!) { (ary) in
                
                HUD.hide()
                self.downAction(str: ary[0] as! String, fileName:rowModel.FileName!,indexPath:indexPath)
            }
            
        }
    }
    
    /// 下载附件
    func downAction(str:String,fileName:String,indexPath: IndexPath)  {
        
        let cell:GGAttachmentViewCell = self.tableView.cellForRow(at: indexPath) as! GGAttachmentViewCell
        
        FileTools.createFile(name: fileName, baseStr: str, { (code) in
            
            //写入成功
            if code == true{
                
               
                cell.stateLB.text = "点击附件打开"
            }
            
        }) { (size) in
            
             cell.stateLB.text = "点击附件打开"
        }
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
