//
//  Router+Web.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Router {
    
    static func pushToWebVC(url: String, title: String? = nil) {
        
        guard let webVC = perform(targetName: "TargetWeb", actionName: "webVCWithParams:", parameters: ["url": url]) as? UIViewController else {
            return
        }
        
        webVC.title = title
        webVC.hidesBottomBarWhenPushed = true
        currentNavVC.pushViewController(webVC, animated: true)
    }
}
