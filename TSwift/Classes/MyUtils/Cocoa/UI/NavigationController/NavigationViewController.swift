//
//  NavigationViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIColor(hex: 0x2f2e3d).image, for: .default)
        UINavigationBar.appearance().backIndicatorImage = "UI_backIcon".image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = "UI_backIcon".image
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clear], for: .highlighted)
    }
}
