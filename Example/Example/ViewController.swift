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
    
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3) + .milliseconds(0)) { [weak self] in
//            let configuration = WKSnapshotConfiguration()
//            let frame = webView.bounds.applying(CGAffineTransform.init(scaleX: 0.5, y: 0.5))
//            configuration.rect = webView.bounds
//            configuration.snapshotWidth = NSNumber(value: Double(frame.size.width))
//            webView.takeSnapshot(with: configuration, completionHandler: { [weak self] (image, erro) in
//                let imageView = UIImageView(image: image)
//                imageView.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1).cgColor
//                imageView.layer.borderWidth = 2.0
//                imageView.frame = frame
//                self?.view.addSubview(imageView)
//            })
//        }
    }
}

