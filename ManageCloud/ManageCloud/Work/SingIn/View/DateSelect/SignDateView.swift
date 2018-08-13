//
//  SignDateView.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/29.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SignDateView: UIView {

    var selectedBlock: ((Date)->())!
    
    @IBOutlet weak var pickerBottom: NSLayoutConstraint!
    
    @IBOutlet weak var container: UIView!
    
    var picker: SignDatePicker!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker = Bundle.main.loadNibNamed("SignDatePicker", owner: nil, options: nil)?.first as! SignDatePicker
        container.addSubview(picker)
        picker.cancelBlock = {
            self.dismiss()
        }
        picker.selectedBlock = { (date) in
            self.selectedBlock!(date)
        }
        picker.frame = container.bounds
        
    }
    
    func show() {
        picker.initDate()
        self.alpha = 0.0
        MainWindow.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
        
    }
    
    func dismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { (done) in
            self.removeFromSuperview()
        }
    }

}
