//
//  Router+Compose.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Router {
    static private let Compose = "TargetCompose"
    
    static var composeVC: UIViewController {
        return perform(targetName: Compose, actionName: "composeVC") as! UIViewController
    }
}
