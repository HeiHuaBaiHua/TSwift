//
//  Router+Root.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension Router {
    static private let Root = "TargetRoot"
    
    static var tabbarVC: UIViewController {
        return perform(targetName: Root, actionName: "tabbarVC") as! UIViewController
    }
    
    static func tempVC(onClickHandler: @escaping () -> ()) -> UIViewController {
        
        let parameter = ["onClickHandler": onClickHandler]
        return perform(targetName: Root, actionName: "tempVCWithParameters:", parameters: parameter) as! UIViewController
    }
}
