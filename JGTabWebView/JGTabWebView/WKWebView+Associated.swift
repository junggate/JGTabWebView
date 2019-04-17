//
//  WKWebView+Associated.swift
//  JGTabWebView
//
//  Created by JungMoon MacPro on 16/04/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit

public extension WKWebView {
    /// Asooicated Object Keys
    private struct AssociatedKeys {
        static var `id` = "WKWebView.AssociatedKeys.id"
        static var parentId = "WKWebView.AssociatedKeys.parentId"
        static var title = "WKWebView.AssociatedKeys.title"
        static var jgNavigationDelegate = "WKWebView.AssociatedKeys.jgNavigationDelegate"
        static var navigationDelegateProxy = "WKWebView.AssociatedKeys.navigationDelegateProxy"
        static var jgUiDelegate = "WKWebView.AssociatedKeys.jgUiDelegate"
        static var uiDelegateProxy = "WKWebView.AssociatedKeys.uiDelegateProxy"
    }
    
    /// WebView 고유 ID
    var `id`: String? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.id) as? String }
        set (manager) { objc_setAssociatedObject(self, &AssociatedKeys.id, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Parent WebView의 ID
    var parentId: String? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.parentId) as? String }
        set (manager) { objc_setAssociatedObject(self, &AssociatedKeys.parentId, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 현재 페이지 제목
    var title: String? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.title) as? String }
        set (manager) { objc_setAssociatedObject(self, &AssociatedKeys.title, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @objc var jgNavigationDelegate: WKNavigationDelegate? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.jgNavigationDelegate) as? WKNavigationDelegate }
        set (manager) { objc_setAssociatedObject(self, &AssociatedKeys.jgNavigationDelegate, manager, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    var navigationDelegateProxy: AnyObject? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.navigationDelegateProxy) as AnyObject }
        set (manager) { objc_setAssociatedObject(self, &AssociatedKeys.navigationDelegateProxy, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @objc var jgUiDelegate: WKUIDelegate? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.jgUiDelegate) as? WKUIDelegate }
        set (manager) { objc_setAssociatedObject(self, &AssociatedKeys.jgUiDelegate, manager, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    var uiDelegateProxy: AnyObject? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.uiDelegateProxy) as AnyObject }
        set (manager) { objc_setAssociatedObject(self, &AssociatedKeys.uiDelegateProxy, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

}
