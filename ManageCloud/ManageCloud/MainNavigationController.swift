//
//  MainNavigationController.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
    }
    
    fileprivate func setNavBar() {
        navigationBar.setBackgroundImage(UIImage.init(color:BlueColor), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.init(fontName: kMedFont, size: 19)]
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //返回按钮文字要显示出来
//        let backItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
//        viewController.navigationItem.backBarButtonItem = backItem
        //实际上在initWith跟控制器的时候下面会走一遍，这样默认再往下一个界面的backbutton就会读取上一个界面的backbutton名字
        if self.viewControllers.count < 1 {
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
        }
        else{
            
            viewController.hidesBottomBarWhenPushed = true
            navigationBar.backIndicatorImage = LoadImage("iconBack").withRenderingMode(.alwaysOriginal)
//            navigationBar.backIndicatorTransitionMaskImage = LoadImage("iconBack").withRenderingMode(.alwaysOriginal)
            //返回按钮文字的颜色
            navigationBar.tintColor = UIColor.white
            
            // 设置返回手势
            interactivePopGestureRecognizer?.isEnabled = true
            interactivePopGestureRecognizer?.delegate = self
            
        }
        super.pushViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
