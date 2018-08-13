//
//  AttachmentCell.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/9.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class AttachmentCell: UITableViewCell {

    var model:AttachmentInfo = AttachmentInfo()
    var vm:EmailDetailVM = EmailDetailVM()
    var type:AttachmentCellIonType = .downType
    var index:IndexPath = IndexPath()
    
    
    /// 椭圆背景
    @IBOutlet weak var bgView: UIView!
    /// 附件1.2.3.
    @IBOutlet weak var rowNum: UILabel!
    /// 附件名称（0K）
    @IBOutlet weak var contentLB: UILabel!
    /// 按钮 icon_down下载样式  icon_delete删除样式
    @IBOutlet weak var Btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    
    @IBAction func btnAction(_ sender: UIButton) {
        print("点击了")
        
        if self.type == .deleteType {//删除
            
            //发送通知 刷新tableview
            let notificationName = Notification.Name(rawValue: NotificationName_AttachmentReload)
            NotificationCenter.default.post(name: notificationName, object: self,
                                            userInfo: ["index":self.index])
            
        }else {//下载
            
            if  NetObserve.isReachableOnEthernetOrWiFi == false {
                
                let alert =  UIAlertController.init(title: nil, message: "当前非WiFi网络,是否继续下载", preferredStyle: .alert)
                alert.addAction(title: "取消", style: .cancel, isEnabled: true) { (action) in
                    
                    
                }
                
                alert.addAction(title: "下载", style: .default, isEnabled: true) { (action) in
                    
                    HUD.show(.progress, onView:self.viewController?.view)
                    self.vm.askForReadFile(URL:MailReadFileURL, SourceFileName: self.model.FileName!) { (ary) in
                        
                        HUD.hide()
                        self.downAction(str: ary[0] as! String)
                    }
                }
                
                alert.show()
                
            }else {
                
                HUD.show(.progress,onView: viewController?.view)
                self.vm.askForReadFile(URL:MailReadFileURL, SourceFileName: self.model.FileName!) { (ary) in
                    
                    HUD.hide()
                    self.downAction(str: ary[0] as! String)
                }

            }
        }
        

    }
    
    /// 下载附件
    func downAction(str:String)  {
        
//        let str:String = "sK67pLu3vrOjrM7Ew/ez9tDQoaM="
        
        FileTools.createFile(name: self.model.FileName!, baseStr: str, { (code) in
            
            //写入成功
            if code == true{
                
                self.Btn.isHidden = true
                self.bgView.backgroundColor = RGBA(r: 223, g: 227, b: 237, a: 1)

                //计算文件大小
                let file = UrlForDocument[0].appendingPathComponent(self.model.FileName!)
                let fileSize = FileTools.getFileSize(patch: file.path)
                print(fileSize)
            }
        }) { (size) in
            
            // 已经存在
                let file = UrlForDocument[0].appendingPathComponent(self.model.FileName!)
                let fileSize = FileTools.getFileSize(patch: file.path)
                print(fileSize)
            self.contentLB.text = self.model.WFTID! + "(" + fileSize + ")"
            self.bgView.backgroundColor = RGBA(r: 223, g: 227, b: 237, a: 1)
            self.Btn.isHidden = true
        }

    }
    
    /// Cell的类型 (写邮件的时候是删除)
    func SetCellType(type:AttachmentCellIonType) {
        
        self.type = type
        if type ==  .deleteType {
            self.Btn.setImage(UIImage.init(named: "icon_delete2"), for: .normal)
        }else{
            self.Btn.setImage(UIImage.init(named: "icon_down"), for: .normal)
        }
        
    }
    
    /// Cell赋值
    func setViewValue(model:AttachmentInfo, index:IndexPath){
        self.index = index
        self.model = model
        self.rowNum.text = "附件" + (index.row + 1).string + ":"
        if model.FileLen!.contains("B") {
            //本地选择的
            self.contentLB.text = model.DisplayName!  +  "(" + model.FileLen! + ")"
        }else{
            //请求回来的
            //model.FileLen = model.FileLen?.replacingOccurrences(of: ["G","K","M","B"], with: "")
            let temp =  Double(Float(model.FileLen ?? "0.00")!)
            let fileSize = FileTools.DownFileWithSize(size: temp )
            self.contentLB.text = model.DisplayName!  +  "(" + fileSize  + ")"

        }
       
        
        self.Btn.isHidden = false
        self.bgView.backgroundColor = RGBA(r: 238, g: 238, b: 238, a: 1)
        
        let subPaths = FileManag.subpaths(atPath: UrlForDocument[0].path)
        print(subPaths as Any)
        
        if (subPaths?.count)! > 0 {
            //遍历沙盒有没有这个文件
            for index in  subPaths! {
                
                if self.model.FileName == index{
                    
                    self.Btn.isHidden = true
                    self.bgView.backgroundColor = RGBA(r: 223, g: 227, b: 237, a: 1)
                    //文件大小
                    let file = UrlForDocument[0].appendingPathComponent(self.model.FileName!)
                    let fileSize = FileTools.getFileSize(patch: file.path)
                    
                    self.contentLB.text = self.model.DisplayName! + "(" + fileSize + ")"
                }
            }
        }
        

//        downAction(str: <#T##String#>)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


/*
 let utf8EncodeData = str.data(using: String.Encoding.utf8, allowLossyConversion: true)
 // 将NSData进行Base64编码
 let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
 print("encodedString: \(base64String!)")
 
 
 let data = str.data(using: .utf8)!
 let bytes = data.withUnsafeBytes {
 [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
 }
  print(bytes)
 */
