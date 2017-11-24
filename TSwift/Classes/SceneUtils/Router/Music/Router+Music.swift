//
//  Router+Discover.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Router {
    static private let Discover = "TargetMusic"
    
    static var MusicVC: UIViewController {
        return perform(targetName: Discover, actionName: "MusicVC") as! UIViewController
    }
}
