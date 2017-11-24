//
//  Router.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class Router {

    @discardableResult
    static func perform(targetName: String, actionName: String, parameters: [String: Any]? = nil) -> Any? {
        
        guard let target: AnyObject = NSClassFromString(targetName) else { return nil }
        
        let action = NSSelectorFromString(actionName)
        let notFoundAction = NSSelectorFromString("notFound")
        if target.responds(to: action) {
            
            if parameters == nil {
                return target.perform(action).takeUnretainedValue()
            } else {
                return target.perform(action, with: parameters!).takeUnretainedValue()
            }
        } else if (target.responds(to: notFoundAction)) {
            return target.perform(notFoundAction).takeUnretainedValue()
        } else {
            
            let errorController: AnyObject = NSClassFromString("errorController")!
            return errorController.perform(NSSelectorFromString("default")).takeUnretainedValue()
        }
    }
    
    static var currentNavVC: UINavigationController {
        get {
            let tabbarVC = UIApplication.shared.delegate!.window!!.rootViewController as! UITabBarController
            return tabbarVC.selectedViewController as! UINavigationController
        }
    }
}
