//
//  TargetProfile.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

@objc(TargetProfile)
class TargetProfile: NSObject {

    static func profileVC() -> UIViewController {
        return ProfileViewController.IBInstance()
    }
    
    static func registerVC() -> UIViewController {
        return RegisterViewController.IBInstance()
    }
    
    static func loginVC() -> UIViewController {
        return LoginViewController.IBInstance()
    }
}
