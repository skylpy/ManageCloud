//
//  SettingNameViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/11.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import PKHUD
class SettingNameViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    var model:PersonInfoModel? = nil
    var vm = SettingNameVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "姓名编辑"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(saveName))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        if self.model != nil {
            nameText.text = self.model?.Name
        }
        
        self.nameText.becomeFirstResponder()
    }

    @objc func saveName(){
        self.model?.Name = nameText.text
        self.vm.askForUpdateName(smodel: self.model!) { (code,remark) in
            
            if code == "200"{
                
                HUD.flash(.label(remark), delay: 1.5){_ in
                    self.navigationController?.popViewController()
                }
                
            }else {
                
                HUD.flash(.label(remark), delay: 1.5)
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
