//
//  MainTabarController.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit

class MainTabarController: UITabBarController {
    
    lazy var vcs = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //添加子控制器
        addChildController()
        //设置tabBar
        setupTabBar()
        //设置tabBarItem的文字属性
        setUpTabbarItemTextAttributes()
        
        selectedIndex = 0
    }
    
    fileprivate func addChildController() {
        let arr = TaBarModel.comfirmTabarInformationArray()
        let childvcs = TaBarModel.comfirmTabarControllerArray()
        for index in 0..<arr.count {
            let model = arr[index]
            let vc = childvcs[index]
            vc.tabBarItem.title = model.title
            vc.tabBarItem.image = LoadImage(model.normalImageName).withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = LoadImage(model.selectImageName).withRenderingMode(.alwaysOriginal)
            addChildViewController(vc)
        }
        
    }
    fileprivate func setupTabBar() {
        //tabbar backgroundColor
        UITabBar.appearance().barTintColor = RGBA(r: 255, g: 255, b: 255, a: 0.9)
        //tabbar的分割线的颜色
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        dropShadow(Offset: CGSize.init(width: 0, height: -0.4), radius: 2, color: RGBA(r: 0, g: 0, b: 0, a: 0.25), opacity: 1.0)
        
    }
    
    fileprivate func dropShadow(Offset offset:CGSize, radius:CGFloat, color:UIColor, opacity:CGFloat) {
        let pathRef = CGMutablePath.init()
        pathRef.addRect(self.tabBar.bounds)
        tabBar.layer.shadowPath = pathRef;
        pathRef.closeSubpath()
        
        tabBar.layer.shadowColor = color.cgColor
        tabBar.layer.shadowOffset = offset
        tabBar.layer.shadowRadius = radius
        tabBar.layer.shadowOpacity = Float(opacity)
        tabBar.clipsToBounds = false
        
    }
    
    //设置tabBarItem的文字属性
    fileprivate func setUpTabbarItemTextAttributes() {
        //普通状态下的文字属性
        var normalAttrs: [NSAttributedStringKey: Any] = [NSAttributedStringKey: Any]()
        normalAttrs[kCTForegroundColorAttributeName as NSAttributedStringKey] = COLOR(red: 152, green: 152, blue: 156)
        normalAttrs[kCTFontAttributeName as NSAttributedStringKey] = UIFont.init(fontName: kRegFont, size: 10)
        //选中状态下的文字属性
        var selectedAttrs: [NSAttributedStringKey: Any] = [NSAttributedStringKey: Any]()
        normalAttrs[kCTForegroundColorAttributeName as NSAttributedStringKey] = BlueColor
        normalAttrs[kCTFontAttributeName as NSAttributedStringKey] = UIFont.init(fontName: kRegFont, size: 10)
        
        
        let tabbarItem = UITabBarItem.appearance()
        tabbarItem.setTitleTextAttributes(normalAttrs, for:.normal)
        tabbarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

class TaBarModel: NSObject{
    var title: String = ""
    var normalImageName: String = ""
    var selectImageName: String = ""
    //初始化
    class func comfirmModel(Title title: String, normalImage normalImageName: String, selectImageName selectImage: String) -> TaBarModel {
        let model = self.init()
        model.title = title
        model.normalImageName = normalImageName
        model.selectImageName = selectImage
        return model
    }
    //tabar 信息
    class func comfirmTabarInformationArray() -> [TaBarModel]{
        let message = TaBarModel.comfirmModel(Title: "消息", normalImage: "iconSqaureDefault", selectImageName: "iconSqaureDefaultPre")
        let work = TaBarModel.comfirmModel(Title: "工作区", normalImage: "iconTabbarShopping", selectImageName: "iconTabbarShoppingPre")
        let mine = TaBarModel.comfirmModel(Title: "我的", normalImage: "iconTabbarMine", selectImageName: "iconTabbarMinePre")
        return [message,work,mine]
    }
    //tabar Controller
    class func comfirmTabarControllerArray() -> [MainNavigationController]{
        let message = MainNavigationController.init(rootViewController: MessageViewController())
        let work = MainNavigationController.init(rootViewController: WorkViewController())
        let mine = MainNavigationController.init(rootViewController: MineViewController())
        return [message,work,mine]
    }
}
