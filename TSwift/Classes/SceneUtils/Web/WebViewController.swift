//
//  WebViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    required init?(coder aDecoder: NSCoder) { return nil }
    private let dealoc = DeinitLogItem(self)
    
    
    private var viewModel: WebViewModelProtocol
    init(viewModel: WebViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        for jsFuncName in viewModel.jsFuncNames {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: jsFuncName)
        }
    }
    
    override func viewDidLoad() {
        
        layoutUI()
        bind()
        
        refreshData()
    }
    
    private func bind() {
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        for jsFuncName in viewModel.jsFuncNames {
            webView.configuration.userContentController.add(viewModel, name: jsFuncName)
        }
        
        viewModel.javaScriptSignal.observeValues {[unowned self] (javaScript) in
            self.webView.evaluateJavaScript(javaScript, completionHandler: nil)
        }
    }
    
    private func refreshData() {
        showHUD()
        webView.load(viewModel.request)
    }
    
//MARK: Utils
    
    private func layoutUI() {
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }

//MARK: Getter
    
    lazy private var webView: WKWebView = {
        
        var config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = WKUserContentController()
        var webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
}

//MARK: WKUIDelegate
extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "JS", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "JS", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.title == nil {
            webView.reload()
        }
        hideHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideHUD()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url,
            url.absoluteString.hasPrefix("haleyaction") {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
