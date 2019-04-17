//
//  WKNavigationDelegateProxy.swift
//  JGTabWebView
//
//  Created by JungMoon MacPro on 17/04/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit

class WKNavigationDelegateProxy: NSObject, WKNavigationDelegate {
    open var delegate: WKNavigationDelegate
    
    /// 초기화
    ///
    /// - Parameter navigationDelegate: Origin WKNavigationDelegate 객체
    init(_ navigationDelegate: WKNavigationDelegate) {
        delegate = navigationDelegate
        super.init()
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if delegate.responds(to: #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)
            as ((WKNavigationDelegate) -> (WKWebView, WKNavigationAction, @escaping(WKNavigationActionPolicy) -> Void) -> Void)?)) {
            delegate.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }

    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if delegate.responds(to: #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)
            as ((WKNavigationDelegate) -> (WKWebView, WKNavigationResponse, @escaping(WKNavigationResponsePolicy) -> Void) -> Void)?)) {
            delegate.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        delegate.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        delegate.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        delegate.webView?(webView, didCommit: navigation)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate.webView?(webView, didFinish: navigation)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate.webView?(webView, didFail: navigation, withError: error)
    }
    
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if delegate.responds(to: #selector(webView(_:didReceive:completionHandler:))) {
            delegate.webView?(webView, didReceive: challenge, completionHandler: completionHandler)
        } else {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        delegate.webViewWebContentProcessDidTerminate?(webView)
    }
}
