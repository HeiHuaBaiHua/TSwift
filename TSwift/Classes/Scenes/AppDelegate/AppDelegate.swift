//
//  AppDelegate.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/5/24.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import Result
import ReactiveCocoa
import ReactiveSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window?.rootViewController = Router.tabbarVC
        return true
    }
}

