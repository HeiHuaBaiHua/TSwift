//
//  TargetWeibo.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

@objc(TargetWeibo)
class TargetWeibo: NSObject {
    
    static func weiboListVC() -> UIViewController {
        return WeiboListViewController()
    }
    
    static func weiboDetailVC(params: [String: Any]) -> UIViewController? {
        guard let weiboData = params["weibo"] as? Data,
        let weibo = try? JSONDecoder().decode(Weibo.self, from: weiboData) else {
            return nil
        }
        
        return WeiboDetailViewController(weibo: weibo)
    }
}
