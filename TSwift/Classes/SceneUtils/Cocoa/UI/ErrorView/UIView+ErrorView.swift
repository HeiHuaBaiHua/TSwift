//
//  UIView+ErrorView.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/23.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    
    var errorView: ErrorViewProtocol {
        set {}
        get {
            
            var myErrorView: ErrorView!
            if let view = viewWithTag(errorViewTag) {
                myErrorView = view as! ErrorView
            } else {
                myErrorView = addErrorView()
            }
            bringSubview(toFront: myErrorView)
            
            return myErrorView as ErrorViewProtocol
        }
    }
    
    private var errorViewTag: Int { return 10047 }
    private func addErrorView() -> ErrorView {
        
        let errorView: ErrorView = ErrorView.IBInstance()
        errorView.frame = bounds
        errorView.backgroundColor = backgroundColor
        errorView.isHidden = true
        errorView.tag = errorViewTag
        addSubview(errorView)
        
        if !(self is UIScrollView) {
            errorView.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
        
        return errorView
    }
}
