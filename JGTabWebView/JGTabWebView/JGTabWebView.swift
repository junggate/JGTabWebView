//
//  JGTabWebView.swift
//  JGTabWebView
//
//  Created by JungMoon MacPro on 16/04/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit

open class JGTabWebView: NSObject {
    public override init() {
        WKWebView.swizzle_uiDelegate
        WKWebView.swizzle_nvigationDelegate
    }
    
    open func newTabWebView() -> WKWebView {
        let webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        return webView
    }
}
