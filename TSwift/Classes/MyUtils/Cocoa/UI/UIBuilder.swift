//
//  UIBuilder.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class UIBuilder {
    
    static func segmentView(frame: CGRect) -> SegmentViewProtocol {
        return SegmentBinder(frame: frame)
    }
    
    static func navigationController(rootVC: UIViewController) -> UINavigationController {
        return NavigationViewController(rootViewController: rootVC)
    }
}




