//
//  YYText+Reactive.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/7/12.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//
import UIKit
import YYText
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: YYLabel {
    
    public var text: BindingTarget<String?> {
        return makeBindingTarget { $0.text = $1 }
    }
    
    public var attributedText: BindingTarget<NSAttributedString?> {
        return makeBindingTarget { $0.attributedText = $1 }
    }
}
