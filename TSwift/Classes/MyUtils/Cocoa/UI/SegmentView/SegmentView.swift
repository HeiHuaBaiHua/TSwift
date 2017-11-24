//
//  SegmentView.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import SnapKit

class SegmentView: UIView {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
        configuration()
    }
    
    //MARK: Utils
    
    private func configuration() {
        backgroundColor = UIColor.white
    }
    
    private func layoutUI() {
        indicatorView.addSubview(colorView)
        titleView.addSubview(indicatorView)
        
        addSubview(titleView)
        addSubview(contentView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(35)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.left.right.equalTo(self)
        }
        
        colorView.snp.makeConstraints { (make) in
            make.center.equalTo(indicatorView)
            make.height.equalTo(indicatorView)
            make.width.equalTo(indicatorView).multipliedBy(0.33)
        }
    }
    
    //MARK: Getter
    
    lazy private(set) var titleView: UIScrollView = {
        $0.backgroundColor = UIColor(hex: 0xe5e5e5)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.neverAdjustContentInset()
        return $0
    }(UIScrollView())

    lazy private(set) var indicatorView: UIView = {
        $0.backgroundColor = UIColor.clear
        return $0
    }(UIView(frame: CGRect.zero))
    
    lazy private(set) var colorView: UIView = {
        $0.backgroundColor = UIColor(hex: 0xf14b5e)
        return $0
    }(UIView(frame: CGRect.zero))
    
    lazy private(set) var contentView: UIScrollView = {
        
        $0.bounces = false
        $0.isPagingEnabled = true
        $0.backgroundColor = UIColor(hex: 0xe5e5e5)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.neverAdjustContentInset()
        return $0
    }(UIScrollView())
}

