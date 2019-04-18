//
//  ViewController.swift
//  Example
//
//  Created by JungMoon MacPro on 17/04/2019.
//  Copyright © 2019 JungMoon. All rights reserved.
//

import UIKit
import WebKit
import JGTabWebView

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = JGTabWebView().newTabWebView()
        webView.frame = view.bounds
        webView.load(URLRequest(url: URL(string: "http://m.zum.com")!))
        view.addSubview(webView)
    }
}

