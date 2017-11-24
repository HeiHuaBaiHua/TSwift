//
//  TargetCompose.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

@objc(TargetCompose)
class TargetCompose: NSObject {

    static func composeVC() -> UIViewController {
        return ComposeViewController()
    }
}
