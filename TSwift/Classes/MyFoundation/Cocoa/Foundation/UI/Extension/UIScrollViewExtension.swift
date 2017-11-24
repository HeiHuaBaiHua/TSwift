//
//  UIScrollView+AdjustScrollInserts.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

extension UIScrollView {
    func neverAdjustContentInset() {
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension UITableView {
    override func neverAdjustContentInset() {
        if #available(iOS 11.0, *) {
            super.neverAdjustContentInset()

            self.estimatedSectionHeaderHeight = 0
            self.estimatedSectionFooterHeight = 0
        }
    }
}
