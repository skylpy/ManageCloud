//
//  ApplicationVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/8.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class ApplicationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom Method
    fileprivate func initUI() {
        title = "申请审批"
        view.backgroundColor = UIColor.white
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 30), title: "已审批")
        button.addTarget(self, action: #selector(ToApprovedList), for: .touchUpInside)
        var rightItem = UIBarButtonItem.init(customView: button)
        navigationItem.rightBarButtonItem = rightItem
        
        
    }
    
    @objc func ToApprovedList(){
        let vc = FlowListVC()
        navigationController?.pushViewController(vc, animated: true)
    }

}
