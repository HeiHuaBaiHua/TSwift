//
//  Router+Profile.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Router {
    static private let Profile = "TargetProfile"
    
    static var profileVC: UIViewController {
        return perform(targetName: Profile, actionName: "profileVC") as! UIViewController
    }
    
    static func pushToRegisterVC() {
        
        let registerVC = perform(targetName: Profile, actionName: "registerVC") as! UIViewController
        registerVC.hidesBottomBarWhenPushed = true
        currentNavVC.pushViewController(registerVC, animated: true)
    }
    
    static func pushToLoginVC() {
        
        let loginVC = perform(targetName: Profile, actionName: "loginVC") as! UIViewController
        loginVC.hidesBottomBarWhenPushed = true
        currentNavVC.pushViewController(loginVC, animated: true)
    }
}
