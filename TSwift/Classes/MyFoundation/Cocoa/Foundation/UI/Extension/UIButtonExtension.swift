//
//  UIButtonExtension.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/18.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension UIButton {
    
    var title: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    var backgroundImage: UIImage? {
        get {
            return backgroundImage(for: .normal)
        }
        set {
            setBackgroundImage(newValue, for: .normal)
        }
    }
}
