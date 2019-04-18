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
    }
 
    open var openedPopup: ((JGWebView)->())?
    private var webViews: [JGWebView] = []
    
    open func newTabWebView(_ configuration: WKWebViewConfiguration = WKWebViewConfiguration()) -> JGWebView {
        let webView = JGWebView(frame: CGRect.zero, configuration: configuration)
        webViews.append(webView)
        return webView
    }
}
