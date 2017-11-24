//
//  LoginViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/2.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import ReactiveSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "...")!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}

extension LoginViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        let prefix = "..."
        if let urlPath = request.url?.absoluteString, urlPath.hasPrefix(prefix) {
            
            let code = urlPath.replacingOccurrences(of: prefix, with: "")
            SinaAPIManager().getSinaOauth(code: code).startWithValues({ (result) in
                UserDefaults.sinaToken = result["token"] ?? ""
            })
        }
        return true
    }
}
