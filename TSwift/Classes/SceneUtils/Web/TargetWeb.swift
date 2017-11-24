//
//  TargetWeb.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

@objc(TargetWeb)
class TargetWeb: NSObject {
    
    static func webVC(params: [String: String]) -> UIViewController? {
        guard let url = params["url"] else {
            return nil
        }
        
        let viewModel = WebViewModel(urlString: url)
        return WebViewController(viewModel: viewModel)
    }
}
