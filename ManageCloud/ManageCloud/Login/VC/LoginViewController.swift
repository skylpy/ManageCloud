//
//  LoginViewController.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var RightNameTips: UILabel!
    @IBOutlet weak var RightPassWordTips: UILabel!
    @IBOutlet weak var passFiled: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "金蓝盟管控云平台"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.init(fontName: kMedFont, size: 19)]
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(color:UIColor.white), for: .default)
        
        nameField.rac_textSignal().subscribeNext { [weak self] (text) in
            self?.RightNameTips.isHidden = true
        }
        
        passFiled.rac_textSignal().subscribeNext { [weak self] (text) in
            self?.RightPassWordTips.isHidden = true
        }
        
        
    }
    
    @IBAction func Login(_ sender: UIButton) {
        view.endEditing(true)
        guard !(nameField.text?.isEmpty)! else{
            self.RightNameTips.isHidden = false
            return
        }
        guard !(passFiled.text?.isEmpty)! else{
            self.RightPassWordTips.isHidden = false
            return
        }
        var dict = paramDic()
        dict["AccountName"] = nameField.text
        dict["Password"] = passFiled.text
        HUD.show(.labeledProgress(title: nil, subtitle: "登录中..."), onView: self.view)
        NetTool.request(type: .POST, urlSuffix: LoginIn, paramters: dict, successBlock: { (responseSuc) in
            HUD.hide()
            let userinfo = HSUserInfo.deserialize(from: responseSuc.result as! [String: Any])
            HSInstance.share.newUserInfo = userinfo
            HUD.flash(.labeledSuccess(title: "登录成功", subtitle: nil), onView: self.view, delay: 0.6, completion: { (finish) in
                MCSave.saveData(Model: true, withKey: MCSave().isLogin)
                MCSave.saveData(Basic: self.passFiled.text!, withKey: MCSave().SavePassWords)
                AppDelegate.share().configLaunchVC()
            })
        }) { (responseFail) in
            HUD.hide()
            if responseFail.scode == "603"{
                
                self.RightNameTips.isHidden = false
            }
            else if responseFail.scode == "604"{
                self.RightPassWordTips.isHidden = false
            }
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
