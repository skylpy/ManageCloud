//
//  CusHomeVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/17.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import WebKit
import PKHUD
import IQKeyboardManager



class CusHomeVC: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler ,PickerToolDelegate{
    
    var cusAuthority: HomeAuthorityModel? = nil
    
    var pickTool: PickerTool? = nil
    var selectedPhoto: [UIImage] = [UIImage]()
    
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView.init(frame: CGRect.init(x: 0, y: KStatusBarH, width: KWidth, height: 2))
        progress.progressTintColor = BlueColor
        progress.trackTintColor = BgColor
        return progress
    }()
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        //只有在设置y为KStatusBarH且webview.scrollView.bounces = false的时候，导航栏视图才不会因为滚动而偏移。
        let webview = WKWebView.init(frame: CGRect.init(x: 0, y: KStatusBarH, width: KWidth, height: KHeight - KStatusBarH), configuration: configuration)
        webview.scrollView.bounces = false
        webview.navigationDelegate = self
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webview
    }()
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = (change![NSKeyValueChangeKey.newKey] as! NSNumber).floatValue
            progressView.progress = progress
            if progress == 1.0{
                progressView.removeFromSuperview()
                DPrint("____________________加载完毕")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
//        webView.keyboardRequiresUserInteraction = true
        webView.evaluateJavaScript("navigator.userAgent") { (any, error) in
            let oldAgent = any as! String
        }
        view.addSubview(progressView)
        view.backgroundColor = BlueColor
        load()
        
    
    }
    
    
    
    fileprivate func deleteCache() {
        //删除wkwebview本身的默认缓存
        //这里不能删除WKWebsiteDataTypeSessionStorage，会影响H5页面传值
        let websiteDataTypes = Set.init(arrayLiteral: WKWebsiteDataTypeCookies,
                                        WKWebsiteDataTypeDiskCache,
                                        WKWebsiteDataTypeMemoryCache,
                                        WKWebsiteDataTypeLocalStorage,
                                        WKWebsiteDataTypeWebSQLDatabases,
                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                        WKWebsiteDataTypeIndexedDBDatabases,
                                        WKWebsiteDataTypeWebSQLDatabases)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: Date.init(timeIntervalSince1970: 0)) {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullScreen()
        webView.configuration.userContentController.add(self, name: "back")
        webView.configuration.userContentController.add(self, name: "dail")
        webView.configuration.userContentController.add(self, name: "takephoto")
//        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "back")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "dail")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "takephoto")
//        IQKeyboardManager.shared().isEnabled = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Method
    fileprivate func fullScreen() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func load() {
        var addString = ""
        if let add = MCSave.getDataWithKey(key: "Adds"){
            addString = add as! String
        }
        
        var editString = ""
        if let edit = MCSave.getDataWithKey(key: "Edit"){
            editString = edit as! String
        }
        let url = CusH5URL() + "&ADD=\(addString.lowercased())&EDIT=\(editString.lowercased())"
        webView.load(URLRequest.init(url: URL.init(string:url)!))
        
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        deleteCache()
    }
    
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "back"{
            navigationController?.popViewController()
        }
        else if message.name == "dail"{
            let number = message.body as! String
            UIApplication.shared.openURL(URL.init(string: "tel://\(number)")!)
        }
        else if message.name == "takephoto"{
            if pickTool == nil{
                pickTool = PickerTool.init(MaxCount: 3, selectedAssets: [AnyObject]())
                pickTool?.delegate = self
                pickTool?.allowPickingVideo = false
            }
            pickTool?.selectedAssets = [AnyObject]()
            present((pickTool?.imagePickerVcC)!, animated: true) {}
        }
    }
    
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.view.endEditing(false)
//    }
    
    func didPickedPhotos() {
        selectedPhoto.removeAll()
        selectedPhoto += (pickTool?.selectedPhotos)!
        var jsonArr = [[String: String]]()
        for image in selectedPhoto{
            var dic = [String: String]()
            dic["name"] = Date().dateString()
            dic["base64"] = image.base64StrForImg()
            jsonArr.append(dic)
        }
        do{
            let json = try jsonArr.json()
            self.webView.evaluateJavaScript("renderImg('\(json)')") { (any, error) in
                
            }
        }
        catch{}
        
    }
    
    
    
    

}
