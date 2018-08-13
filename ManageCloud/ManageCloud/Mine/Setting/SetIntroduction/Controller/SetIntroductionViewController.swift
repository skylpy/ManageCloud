//
//  SetIntroductionViewController.swift
//  ManageCloud
//
//  Created by dehui chen on 2018/5/12.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import GrowingTextView
import PKHUD

class SetIntroductionViewController: UIViewController {

    var model:PersonInfoModel? = PersonInfoModel()
    @IBOutlet weak var textView: UITextView!
    var vm:SetIntroductionVM = SetIntroductionVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "简介编辑"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(saveIntroduction))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        if model != nil {
        
            textView.text = model?.Descr
        }

    }

    @objc func saveIntroduction(){
        
        model?.Descr = textView.text
        self.vm.askForUpdateDescr(smodel: self.model!) { (code, remark) in
            
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
