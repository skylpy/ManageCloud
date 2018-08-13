//
//  AttachmentJournalCell.swift
//  ManageCloud
//
//  Created by Mr.Aaron on 2018/5/16.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class AttachmentJournalCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconButton: UIButton!
    var vm:EmailDetailVM = EmailDetailVM()
    
    @IBAction func iconAction(_ sender: UIButton) {
        
        if self.model.FileName != "" {
            
            self.didStringButton!(self.model.FileName!,self.iconButton,self.model,self.bgView)
            
            
        }else {
            self.didButton!(self.indexPath)
        }
        
    }
    var didButton : ((_ index:NSIndexPath)->())?
    var didStringButton : ((_ name:String,_ button:UIButton,_ model:AttachinfoModel,_ bgView:UIView)->())?
    var indexPath: NSIndexPath!
    
    //日志详情附件数据
    var model = AttachinfoModel(){
        
        didSet {
            let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            
            if model.FileName != "" {
                let filePath = docuPath.appendingPathComponent(model.FileName!)
                let manager = FileManager.default
                let exist = manager.fileExists(atPath: filePath)
                if exist {
                    self.bgView.backgroundColor = UIColor.init(hex: "#DFE3ED")
                    self.iconButton.isHidden = true
                }else {
                    self.bgView.backgroundColor = UIColor.init(hex: "#EEEEEE")
                    self.iconButton.isHidden = false
                }
            }
            
            self.titleLabel.text = "附件:"+model.DisplayName!+"("+String(format: "%d", model.FileLen)+"KB)"
            
        }
    }
    
    //发表日志附件
    var amodel = AttachmentInfo(){
        
        didSet {
            
            self.titleLabel.text = String(format:"附件: %@(%@)",amodel.FileName!,amodel.FileLen!)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
