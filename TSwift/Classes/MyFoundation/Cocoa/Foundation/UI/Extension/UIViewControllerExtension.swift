//
//  UIViewController+Storyboard.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/23.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func IBInstance<T: UIViewController>() -> T {
        let className = self.description().components(separatedBy: ".").last!
        return instance(withStoryboardName: className, identifier: className) as! T
    }
    
    static func instance(withStoryboardName storyboardName: String, identifier: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

extension UIViewController {
    func toast(_ text: String) {
        view?.toast(text)
    }
    
    func showHUD(_ text: String? = nil) {
        view?.showHUD(text)
    }
    
    func hideHUD() {
        view?.hideHUD()
    }
}
