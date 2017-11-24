//
//  TargetRoot.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

@objc(TargetRoot)
class TargetRoot: NSObject {
    
    static func tabbarVC() -> UIViewController {
        return TabBarController()
    }
    
    static func tempVC(parameters: [String: Any]) -> UIViewController? {
        
        if let handler = parameters["onClickHandler"] as? () -> () {
            return TempViewController(onClickHandler: handler)
        } else {
            return nil
        }
    }
}

