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
        super.init()
    }
 
    open var openPopup: ((_ url: URL, _ webView: JGWebView)->Void)?
    open var closePopup: ((JGWebView)->Void)?
    open var longPressEvent: ((CGPoint, Dictionary<String, String>)->Void)?
    open var webViews: [JGWebView] = []
    
    open func newTabWebView(_ configuration: WKWebViewConfiguration = WKWebViewConfiguration()) -> JGWebView {
        let webView = JGWebView(frame: CGRect.zero, configuration: configuration)
        webViews.append(webView)
        setWebViewClosure(webView: webView)
        return webView
    }

    open func getWebView(identifier: String) -> JGWebView? {
        let result = webViews.filter { (webView) -> Bool in
            return webView.id == identifier
        }
        return result.first
    }

    open func getParentWebView(childIdentifier: String) -> JGWebView? {
        let parent = webViews.filter { (webView) -> Bool in
            return webView.id == childIdentifier
        }.first
        if let parent = parent {
            return getWebView(identifier: parent.id)
        }
        return nil
    }

    open func removeWebView(identifier: String) {
        webViews.removeAll(where: { (webView) -> Bool in
            return webView.id == identifier
        })
    }
    
    // MARK: - Private
    func setWebViewClosure(webView: JGWebView) {
        webView.openPopup = { [weak self] (url, childWebView) in
            self?.webViews.append(childWebView)
            self?.openPopup?(url, webView)
        }
        
        webView.closePopup = { [weak self] (webView) in
            if let index = self?.webViews.firstIndex(of: webView) {
                self?.webViews.remove(at: index)
                self?.closePopup?(webView)
            }
        }
        
        webView.longPressEvent = { [weak self] (point, jsonString) in
            if let jsonData = (jsonString?.data(using: .utf8 )) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData,
                                                                      options : .allowFragments) as? Dictionary<String, String> {
                    self?.longPressEvent?(point, jsonObject)
                }
            }
        }
    }
}
