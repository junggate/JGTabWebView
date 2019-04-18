//
//  JGWebView.swift
//  JGTabWebView
//
//  Created by JungMoon MacPro on 17/04/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit

open class JGWebView: WKWebView, WKNavigationDelegate, WKUIDelegate {
    /// WebView 고유 ID
    open var `id`: String?
    
    /// Parent WebView의 ID
    open var parentId: String?
    
    open override var uiDelegate: WKUIDelegate? {
        set { originUIDelegate = uiDelegate; super.uiDelegate = self }
        get { return originUIDelegate }
    }
    
    open override var navigationDelegate: WKNavigationDelegate? {
        set { originNavigationDelegate = navigationDelegate; super.navigationDelegate = self }
        get { return originNavigationDelegate }
    }

    private var originUIDelegate: WKUIDelegate?
    private var originNavigationDelegate: WKNavigationDelegate?
    
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func initialize() {
        self.uiDelegate = self
        self.navigationDelegate = self
    }
}

// MARK: - WKNavigationDelegate
extension JGWebView {
    public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if originNavigationDelegate?.responds(to: #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)
            as ((WKNavigationDelegate) -> (WKWebView, WKNavigationAction, @escaping(WKNavigationActionPolicy) -> Void) -> Void)?)) ?? false {
            originNavigationDelegate?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if originNavigationDelegate?.responds(to: #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)
            as ((WKNavigationDelegate) -> (WKWebView, WKNavigationResponse, @escaping(WKNavigationResponsePolicy) -> Void) -> Void)?)) ?? false {
            originNavigationDelegate?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        originNavigationDelegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        originNavigationDelegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        originNavigationDelegate?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        originNavigationDelegate?.webView?(webView, didCommit: navigation)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        originNavigationDelegate?.webView?(webView, didFinish: navigation)
        getWebPageTitle(webView: webView)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        originNavigationDelegate?.webView?(webView, didFail: navigation, withError: error)
    }
    
    public func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if originNavigationDelegate?.responds(to: #selector(webView(_:didReceive:completionHandler:))) ?? false {
            originNavigationDelegate?.webView?(webView, didReceive: challenge, completionHandler: completionHandler)
        } else {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        originNavigationDelegate?.webViewWebContentProcessDidTerminate?(webView)
    }
    
    // MARK: - Private
    private func getWebPageTitle(webView: WKWebView) {
        //        webView.evaluateJavaScript("document.title") { (result, error) in
        //            webView.title = result as? String
        //        }
    }
}


// MARK: - WKUIDelegate
extension JGWebView {
    public func webView(_ webView: JGWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        var newWebView = originUIDelegate?.webView?(webView,
                                           createWebViewWith: configuration,
                                           for: navigationAction,
                                           windowFeatures: windowFeatures)
        if newWebView == nil {
            let jgWebView = JGWebView(frame: CGRect.zero, configuration: configuration)
            jgWebView.parentId = webView.id
            newWebView = jgWebView
        }
        
        return newWebView
    }
    
    public func webViewDidClose(_ webView: WKWebView) {
        originUIDelegate?.webViewDidClose?(webView)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if originUIDelegate?.responds(to: #selector(webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:))) ?? false {
            originUIDelegate?.webView?(webView, runJavaScriptAlertPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
        } else {
            completionHandler()
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        if originUIDelegate?.responds(to: #selector(webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:))) ?? false {
            originUIDelegate?.webView?(webView, runJavaScriptConfirmPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
        } else {
            completionHandler(true)
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        if originUIDelegate?.responds(to: #selector(webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:))) ?? false {
            originUIDelegate?.webView?(webView, runJavaScriptTextInputPanelWithPrompt: prompt, defaultText: defaultText, initiatedByFrame: frame, completionHandler: completionHandler)
        } else {
            completionHandler(nil)
        }
    }
    
    public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return originUIDelegate?.webView?(webView, shouldPreviewElement: elementInfo) ?? true
    }
    
    public func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        return originUIDelegate?.webView?(webView, previewingViewControllerForElement: elementInfo, defaultActions: previewActions)
    }
    
    public func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        originUIDelegate?.webView?(webView, commitPreviewingViewController: previewingViewController)
    }
}
