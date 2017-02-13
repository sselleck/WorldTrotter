//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Samantha Selleck on 2/8/17.
//  Copyright © 2017 CSC. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
}
