//
//  MKWebViewKeyBoard.swift
//  ManageCloud
//
//  Created by Pingzi on 2018/6/4.
//  Copyright © 2018年 张子恒. All rights reserved.
//

import UIKit
import WebKit

typealias ClosureType =  @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Any) -> Void

extension WKWebView{
    var keyboardRequiresUserInteraction: Bool {
        get {
            return false
        } set {
            if newValue == true {
                setKeyboardRequiresUserInteraction()
            }
        }
    }
    
    func setKeyboardRequiresUserInteraction() {
        let sel: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:")
        let WKContentView: AnyClass = NSClassFromString("WKContentView")!
        let method = class_getInstanceMethod(WKContentView, sel)
        let originalImp: IMP = method_getImplementation(method!)
        let original: ClosureType = unsafeBitCast(originalImp, to: ClosureType.self)
        let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Any) -> Void = {(me, arg0, arg1, arg2, arg3) in
            original(me, sel, arg0, true, arg2, arg3)
        }
        let imp: IMP = imp_implementationWithBlock(block)
        method_setImplementation(method!, imp)
    }
}
