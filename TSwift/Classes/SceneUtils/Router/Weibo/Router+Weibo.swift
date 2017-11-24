//
//  Router+Home.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Router {
    static private let Weibo = "TargetWeibo"
    
    static func pushToWeiboListVC() {
        guard let weiboListVC = perform(targetName: Weibo, actionName: "weiboListVC") as? UIViewController else {
            return
        }
        
        weiboListVC.hidesBottomBarWhenPushed = true
        currentNavVC.pushViewController(weiboListVC, animated: true)
    }
    
    static func pushToWeiboDetail(weiboData: Data?) {
        guard let weiboData = weiboData,
        let weiboDetailVC = perform(targetName: Weibo, actionName: "weiboDetailVCWithParams:", parameters: ["weibo": weiboData]) as? UIViewController else {
            return
        }
        
        weiboDetailVC.hidesBottomBarWhenPushed = true
        currentNavVC.pushViewController(weiboDetailVC, animated: true)
    }
}
