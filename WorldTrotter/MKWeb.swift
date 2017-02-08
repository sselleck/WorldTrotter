//
//  MKWeb.swift
//  WorldTrotter
//
//  Created by Samantha Selleck on 2/7/17.
//  Copyright © 2017 CSC. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        let myURL = URL(string:"https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        view = webView
    }
}

