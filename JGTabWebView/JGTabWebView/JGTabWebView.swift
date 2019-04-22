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
 
    open var openPopup: ((_ index: Int, _ webView: JGWebView)->Void)?
    open var closePopup: ((_ index: Int, _ webView: JGWebView)->Void)?
    open var longPressEvent: ((Dictionary<String, String>)->Void)?

    private var webViews: [JGWebView] = []
    
    open func newTabWebView(_ configuration: WKWebViewConfiguration = WKWebViewConfiguration()) -> JGWebView {
        let webView = JGWebView(frame: CGRect.zero, configuration: configuration)
        webViews.append(webView)
        setWebViewClosure(webView: webView)
        return webView
    }
    
    // MARK: - Private
    func setWebViewClosure(webView: JGWebView) {
        webView.openPopup = { [weak self] (webView) in
            if let popupWebview = self?.webViews.first(where: { (object) -> Bool in
                return object.id == webView.parentId
            }), let index = self?.webViews.firstIndex(of: popupWebview) {
                self?.webViews.insert(webView, at: index+1)
                self?.openPopup?(index+1, webView)
            }
        }
        
        webView.closePopup = { [weak self] (webView) in
            if let index = self?.webViews.firstIndex(of: webView) {
                self?.webViews.remove(at: index)
                self?.closePopup?(index+1, webView)
            }
        }
        
        webView.longPressEvent = { [weak self] (jsonString) in
            if let jsonData = (jsonString?.data(using: .utf8)) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData,
                                                                      options : .allowFragments) as? Dictionary<String, String> {
                    self?.longPressEvent?(jsonObject)
                }
            }
        }
    }
}
