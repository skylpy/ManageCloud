//
//  AppDelegate.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/7.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManager
import ReactiveObjC
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WKUIDelegate, WKNavigationDelegate {

    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        //只有在设置y为KStatusBarH且webview.scrollView.bounces = false的时候，导航栏视图才不会因为滚动而偏移。
        let webview = WKWebView.init(frame: CGRect.init(x: 0, y: KStatusBarH, width: KWidth, height: KHeight - KStatusBarH), configuration: configuration)
        webview.scrollView.bounces = false
        webview.navigationDelegate = self
        return webview
    }()
    
    var window: UIWindow?
    var mainTab: MainTabarController? = nil
    var netObserver: NetworkReachabilityManager!
    
    var rootNav: UINavigationController? {
        get{
            var navi:UINavigationController? = nil
            if (window?.rootViewController?.isKind(of: MainTabarController.self))! {
                let tabVC: MainTabarController  = window?.rootViewController! as! MainTabarController
                if (tabVC.selectedViewController?.isKind(of: MainNavigationController.self))!
                {
                    navi = tabVC.selectedViewController as? MainNavigationController
                }
            }
            return navi
        }
    }
    
    class func share() -> AppDelegate {
        return (UIApplication.shared.delegate) as! AppDelegate
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.isStatusBarHidden = false
        //导航栏颜色
        UIApplication.shared.statusBarStyle = .default
        //网路监听
        ObserveNetwork()
        //键盘位移
        configKeyboardManager()
        //高德地图
        AMapServices.shared().apiKey = amapAPIKey
        //监听登录
        observe()
        //登录
        configLaunchVC()
        //崩溃捕捉
//        #if DEBUG
//        #else
        setupExceptionLog()
//        #endif
        
        //版本更新
        HomeVM.checkupVersion(false)
        
        ////设置H5 UA
        configureH5UA()
        
        return true
    }
    
    
    fileprivate func configureH5UA() {
        webView.evaluateJavaScript("navigator.userAgent") { (any, error) in
            let info = Bundle.main.infoDictionary
            let oldAgent = any as! String
            let app_Name = Bundle.main.bundleIdentifier as! String
            let app_Version = info!["CFBundleShortVersionString"] as! String
            let newAgent = oldAgent + "/" + "IOS" + "_" + app_Version + "_" + "ControlCloud"
            let dict = ["UserAgent": newAgent]
            UserDefaults.standard.register(defaults: dict)
            UserDefaults.standard.setValue(newAgent, forKey: "UserAgent")
            UserDefaults.standard.synchronize()
        }
        let url = "http://192.168.2.147:8020/yt_app/views/customerInfo/customerList/customerList.html"
        webView.load(URLRequest.init(url: URL.init(string:url)!))
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - 监听网络
    func ObserveNetwork() {
        netObserver = NetworkReachabilityManager(host: "www.baidu.com")
        netObserver.startListening()
    }
    
    // MARK: - 键盘位移
    fileprivate func configKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared()
        keyboardManager.isEnabled = true    // 控制整个功能是否启用
        keyboardManager.shouldResignOnTouchOutside = true   // 控制点击背景是否收起键盘
        keyboardManager.shouldToolbarUsesTextFieldTintColor = true  // 控制键盘上的工具条文字颜色是否用户自定义
        keyboardManager.toolbarManageBehaviour = .bySubviews    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
        keyboardManager.isEnableAutoToolbar = false     // 控制是否显示键盘上的工具条
        keyboardManager.keyboardDistanceFromTextField = 50.0    // 输入框距离键盘的距离
        
    }
    
    // MARK: - 监听登录
    fileprivate func observe() {
        //监听登录的完成
//        NotificationCenter.default.rac_addObserver(forName: LoginSucceed, object: nil).subscribeNext { (noti) in
//            GeTuiSdk.setPushModeForOff(false)
//        }
//        HSInstance.share().rx.observe(HSUserInfo.self, "userInfo").subscribe(onNext: { (x) in
//            if x == nil{
                //解绑推送
//                GeTuiSdk.unbindAlias(HSSave.getDataWithKey("GeTuiCid") as? String, andSequenceNum: "seq-1", andIsSelf: true)
//                GeTuiSdk.setPushModeForOff(true)
//            }
//        })
    }
    
    // MARK: - 登录
    func configLaunchVC() {
        let userinfo = HSInstance.share.newUserInfo
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
//
        if userinfo != nil
        {
            mainTab = MainTabarController()
            window?.rootViewController = mainTab

        }
        else
        {
            let loginVC = LoginViewController()
            let nav = MainNavigationController.init(rootViewController: loginVC)
            window?.rootViewController = nav
        }
        window?.makeKeyAndVisible()
        
    }
    
    // MARK: - 崩溃日志
    fileprivate func setupExceptionLog() {
        crashHandle { (crashInfoArr) in
            for info in crashInfoArr{
                //这里添加对每一条crash信息的操作
                DPrint(info)
            }
        }
    }
    
    
    


}

