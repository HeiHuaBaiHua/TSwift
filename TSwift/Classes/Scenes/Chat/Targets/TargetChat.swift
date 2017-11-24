//
//  TargetChat.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

@objc(TargetChat)
class TargetChat: NSObject {

    static func messageListVC() -> UIViewController {
        return MessageListViewController()
    }
}
