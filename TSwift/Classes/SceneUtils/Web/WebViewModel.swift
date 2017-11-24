//
//  WebViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewModelProtocol: WKScriptMessageHandler {
    
    var request: URLRequest{ get }
    
    var jsFuncNames: [String] {get}
    var javaScriptSignal: NSignal<String> { get }
}

class WebViewModel: NSObject {
    private let dealloc = DeinitLogItem(self)

    private(set) var request: URLRequest
    private(set) var jsFuncNames = [String]()
    
    fileprivate let javaScript = NSignal<String>.pipe()
    var javaScriptSignal: NSignal<String> {
        return javaScript.output
    }
    
    init(urlString: String) {
        
        let url = urlString.url ?? URL(string: "404")!
        request = URLRequest(url: url)
        jsFuncNames = ["testJS"]
    }
}

extension WebViewModel: WebViewModelProtocol {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard jsFuncNames.contains(message.name),
            let params = message.body as? [String: Any] else {
            return
        }
        
        let callBackName = params["callback"] as? String
        switch message.name {
        case "testJS":
            testJS(callback: callBackName)
        default: break
        }
    }
    
    private func testJS(callback: String?) {
        if let callback = callback {
            
            let params = ["arg1": "xxx", "arg2": "xxx"].jsDictionaryString
            let javaScript = "\(callback)(\(params))"
            self.javaScript.input.send(value: javaScript)
        }
    }
}
