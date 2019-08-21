//
//  JGWebView.swift
//  JGTabWebView
//
//  Created by JungMoon MacPro on 17/04/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit

open class JGWebView: WKWebView, WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate, WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

    }

    /// WebView 고유 ID
    open var `id` = UUID().uuidString
    
    /// Parent WebView의 ID
    open var parentId: String?
    
    open override var uiDelegate: WKUIDelegate? {
        set { originUIDelegate = newValue }
        get { return originUIDelegate }
    }
    
    open override var navigationDelegate: WKNavigationDelegate? {
        set { originNavigationDelegate = newValue }
        get { return originNavigationDelegate }
    }
    
    open var openPopup: ((URL, JGWebView)->Void)?
    open var closePopup: ((JGWebView)->Void)?
    open var longPressEvent: ((CGPoint, String?)->Void)?
    
    
    open override var title: String? {
        return super.title?.isEmpty ?? true ? url?.absoluteString : super.title
    }

    private var originUIDelegate: WKUIDelegate?
    private var originNavigationDelegate: WKNavigationDelegate?
    private var previewImagePath: String?
    
    override public init(frame: CGRect, configuration: WKWebViewConfiguration) {
        let userContentController = WKUserContentController()

        // Diable Long Press Event
        userContentController.addUserScript(WKUserScript(source: "document.body.style.webkitTouchCallout='none';",
                                                         injectionTime: .atDocumentEnd,
                                                         forMainFrameOnly: true))
        
        if let path = Bundle(for: type(of: self)).path(forResource: "JSTools", ofType: "js"),
            let jsCode = try? String(contentsOfFile: path, encoding: .utf8) {
            userContentController.addUserScript(WKUserScript(source: jsCode,
                                                             injectionTime: .atDocumentEnd,
                                                             forMainFrameOnly: true))
        }

        configuration.userContentController = userContentController
        configuration.applicationNameForUserAgent = JGWebView.cusotmUserAgent
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        super.init(frame: frame, configuration: configuration)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        super.navigationDelegate = self
        super.uiDelegate = self
        allowsLinkPreview = false
        allowsBackForwardNavigationGestures = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchLongTap))
        longPressGesture.delegate = self
        addGestureRecognizer(longPressGesture)
    }
    static public var cusotmUserAgent = ""
    static public func addUserAgentString(string: String) {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

        var status = true
        var runJavascript = false
        while status {
            if runJavascript == false {
                webView.evaluateJavaScript("navigator.userAgent") { (userAgent, error) in
                    _ = webView // 메모리 해제 방어용
                    JGWebView.cusotmUserAgent = "\(userAgent as? String ?? "") \(string)"
                    print("addUserAgentString: \(JGWebView.cusotmUserAgent)")
                    status = false
                }
                runJavascript = true
            }

            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        }
    }

    // MARK:- Gesture
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func touchLongTap(gesture : UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: self)
            let script = String(format: "getSourceAtPoint(%.0f, %.0f)", point.x, point.y-scrollView.adjustedContentInset.top)
            evaluateJavaScript(script, completionHandler: { [weak self] (result, error) in
                if let result = result as? String, !result.isEmpty {
                    self?.longPressEvent?(point, result)
                }
            })
        }
    }
    
    // MARK:- Public
    open func savePreviewImageToTemporary(width: CGFloat, result: @escaping ((URL) -> ())) {
        let configuration = WKSnapshotConfiguration()
        var rect = bounds
        if scrollView.contentOffset.y < 0 { // 스크롤 상단 공백 제거
            rect.origin.y = -scrollView.contentOffset.y
        }
        configuration.rect = rect
        configuration.snapshotWidth = NSNumber(value: Float(width))
        takeSnapshot(with: configuration, completionHandler: { [weak self] (image, error) in
            guard let `self` = self else { return }
            if let data = image?.pngData() {
                let fileName = "\(self.id).png"
                let path = "\(NSTemporaryDirectory())\(fileName)"
                let url = URL(fileURLWithPath: path)
                try? FileManager.default.removeItem(at: url)
                try? data.write(to: url)
                self.previewImagePath = path
                result(url)
            }
        })
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
//        getPreviewImage()
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
}


// MARK: - WKUIDelegate
extension JGWebView {
    public func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        var newWebView = originUIDelegate?.webView?(webView,
                                                    createWebViewWith: configuration,
                                                    for: navigationAction,
                                                    windowFeatures: windowFeatures)
        if newWebView == nil, let url = navigationAction.request.url {
            let jgWebView = JGWebView(frame: CGRect.zero, configuration: configuration)
            jgWebView.parentId = (webView as? JGWebView)?.id
            newWebView = jgWebView
            openPopup?(url, jgWebView)
        }
        
        return newWebView
    }

    public func webViewDidClose(_ webView: WKWebView) {
        originUIDelegate?.webViewDidClose?(webView)
        if let jgWebview = webView as? JGWebView {
            closePopup?(jgWebview)
        }
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
