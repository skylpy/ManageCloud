//
//  FixPassWordsViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD

class FixPassWordsViewController: UIViewController {

    @IBOutlet weak var oldWords: UITextField!
    @IBOutlet weak var newWords: UITextField!
    @IBOutlet weak var newWords2: UITextField!
    
    var vm:FixPassWordsVM = FixPassWordsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改密码"
    }

    /// 修改密码事件
    @IBAction func fixAction(_ sender: Any) {
        
        let oldWordStr = MCSave.getDataWithKey(key: MCSave().SavePassWords) as! String
        
        if  (oldWords.text?.isEmpty)! {
            HUD.flash(.label("请输入原密码"), delay: 1.0)
            return
        }
        
        
        if oldWordStr != oldWords.text {
            HUD.flash(.label("原密码有误"), delay: 1.0)
            return
        }
        
        if newWords.text != newWords2.text {
            HUD.flash(.label("两次密码不一致"), delay: 1.0)
            return
        }
        
        if newWords.text == "" ||  newWords2.text == "" {
            HUD.flash(.label("新密码不能为空"), delay: 1.0)
            return
        }
        
        self.vm.askForPassWork(wordStr: newWords2.text!) { (code, remark) in
            
            if code  == "200" {
                MCSave.saveData(Basic: self.newWords2.text!, withKey: MCSave().SavePassWords)

                HUD.flash(.label(remark), delay: 1.0) {_ in
                    self.navigationController?.popViewController()
                }
            }else{
                HUD.flash(.label(remark), delay: 1.0)
            }
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
