//
//  WKWebView+WKUIDelegate.swift
//  JGTabWebView
//
//  Created by JungMoon MacPro on 17/04/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit

public extension WKWebView {
    static let swizzle_uiDelegate: Void = {
        swizzle_jgUiDelegate
    }()
    
    static let swizzle_jgUiDelegate: Void = {
        let originalSelector = #selector(setter: WKWebView.jgUiDelegate)
        let swizzledSelector = #selector(swizzled_jgUiDelegate)
        NSObject.swizzlingForClass(WKWebView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    @objc func swizzled_jgUiDelegate(_ delegate: WKUIDelegate) {
        let uiDelegateProxy = WKUIDelegateProxy(delegate)
        self.uiDelegateProxy = uiDelegateProxy
        self.uiDelegate = uiDelegateProxy
    }
}

