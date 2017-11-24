//
//  Router+Message.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Router {
    static private let Message = "TargetChat"
    
    static var messageListVC: UIViewController {
        return perform(targetName: Message, actionName: "messageListVC") as! UIViewController
    }
}
