//
//  SegmentViewProtocol.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

@objc protocol SegmentViewDataSource: NSObjectProtocol {
    
    
    @objc optional func heightOfHeader(in segmentView: UIView) -> CGFloat
    @objc optional func segmentView(_ segmentView: UIView, attributesForTitleAt index: Int, selected: Bool) -> [String: Any]
    
    func numberOfItems(in segmentView: UIView) -> Int
    func segmentView(_ segmentView: UIView, itemViewAt index: Int) -> UIView
    func segmentView(_ segmentView: UIView, titleForItemAt index: Int) -> String
}

protocol SegmentViewProtocol {
    
    weak var dataSource: SegmentViewDataSource? { set get}
    func reload()
    func reloadView()
    func reloadTitle()
    
    var selectedIndex: Int{ set get }
    var headerBackgroundColor: UIColor? { set get}
    var didScrollToItemHandler: ((_ segmentView: UIView, _ index: Int) -> ())? { set get}
}
