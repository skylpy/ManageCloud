//
//  PreViewVC.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/5/18.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import WebKit

class PreViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate  {

    
    var fileName: String = ""
    var filePath: URL?
    
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: 2))
        progress.progressTintColor = BlueColor
        progress.trackTintColor = BgColor
        return progress
    }()
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        let webview = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: KWidth, height: KHeight - KStatusBarH - KNaviBarH), configuration: configuration)
        webview.navigationDelegate = self
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = fileName
        view.addSubview(webView)
        view.addSubview(progressView)
        load()
        
    }
    
    fileprivate func load() {
        let documentPath = URL.init(fileURLWithPath: DocumentPath)
        webView.loadFileURL(filePath!, allowingReadAccessTo: documentPath)
    }
    
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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
