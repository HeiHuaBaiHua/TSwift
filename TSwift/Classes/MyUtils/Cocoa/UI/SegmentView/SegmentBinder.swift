//
//  SegmentBinder.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class SegmentBinder: SegmentView {
    private let dealloc = DeinitLogItem(self)

    fileprivate var selectedTag = 0
    var didScrollToItemHandler: ((UIView, Int) -> ())?
    weak var dataSource: SegmentViewDataSource? {
        didSet {
            
            layoutContentView()
            selectedIndex = selectedTag
        }
    }
    
    fileprivate var titleWidth: CGFloat = 0
    fileprivate var titleHeight: CGFloat = 35
    fileprivate var selectedButton: UIButton?
}

//MARK: Interface
extension SegmentBinder: SegmentViewProtocol {
    func reload() {
        reloadTitle()
        reloadView()
    }
    
    func reloadView() {}
    
    func reloadTitle() {
        
        let count = itemCount()
        for index in 0..<Int(count) {
            
            let titleButton = titleView.viewWithTag(InitialTag + index) as! UIButton
            
            let titleText = title(at: index)
            titleButton.setAttributedTitle(NSAttributedString(string: titleText, attributes: attributesForTitle(at: index, selected: false)), for: .normal)
            titleButton.setAttributedTitle(NSAttributedString(string: titleText, attributes: attributesForTitle(at: index, selected: true)), for: .selected)
        }
    }
    
    
    var headerBackgroundColor: UIColor? {
        get {
            return titleView.backgroundColor
        }
        set {
            titleView.backgroundColor = newValue
        }
    }

    var selectedIndex: Int {
        get {
            return (selectedButton == nil ? selectedTag : selectedButton!.tag - InitialTag)
        }
        set {
            selectedTag = newValue
            guard newValue < titleView.subviews.count else {
                return
            }
            
            didSelected(button: titleView.viewWithTag(newValue + InitialTag) as! UIButton)
        }
    }
}

//MARK: Action
extension SegmentBinder {
    
    @objc fileprivate func didSelected(button: UIButton) {
        guard selectedButton != button else {
            return
        }
        
        let index = button.tag - InitialTag
        didScrollToItemHandler?(self, index)
        
        selectedButton?.isSelected = false
        selectedButton = button
        selectedButton?.isSelected = true
        contentView.setContentOffset(CGPoint(x: ScreenWidth * CGFloat(index) , y: 0), animated: true)
    }
}

//MARK: UIScrollViewDelegate
extension SegmentBinder: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        indicatorView.x = scrollView.contentOffset.x * (titleWidth / ScreenWidth)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / ScreenWidth) + InitialTag;
        didSelected(button: titleView.viewWithTag(index) as! UIButton)
    }
}

//MARK: Utils
extension SegmentBinder {
    
    fileprivate func layoutContentView() {
        
        let screenItemCount: CGFloat = 5
        let headHeight = headerHeight()
        let itemWidth = ScreenWidth / screenItemCount
        let count = itemCount()
        
        titleWidth = ScreenWidth / min(count, screenItemCount)
        titleHeight = headHeight
        titleView.contentSize = CGSize(width: itemWidth * count, height: 0)
        titleView.snp.updateConstraints { (make) in
            make.height.equalTo(titleHeight)
        }
        
        contentView.delegate = self
        contentView.contentSize = CGSize(width: ScreenWidth * count, height: 0)
        
        for idx in 0..<Int(count) {
            addTitle(at: idx)
            addItemView(at: idx)
        }
        
        titleView.bringSubview(toFront: indicatorView)
        indicatorView.frame = CGRect(x: 0, y: titleHeight - 3, width: titleWidth, height: 2)
    }
    
    fileprivate func addTitle(at index: Int) {
    
        let titleButton = UIButton(type: .custom)
        titleView.addSubview(titleButton)
        
        titleButton.tag = InitialTag + index
        titleButton.frame = CGRect(x: titleWidth * CGFloat(index), y: 0, width: titleWidth, height: titleHeight)
        titleButton.backgroundColor = UIColor.clear
        
        let titleText = title(at: index)
        titleButton.setAttributedTitle(NSAttributedString(string: titleText, attributes: attributesForTitle(at: index, selected: false)), for: .normal)
        titleButton.setAttributedTitle(NSAttributedString(string: titleText, attributes: attributesForTitle(at: index, selected: true)), for: .selected)
        titleButton.addTarget(self, action: #selector(didSelected(button:)), for: .touchUpInside)
    }

    fileprivate func addItemView(at index: Int) {
        
        let item = itemView(at: index)
        item.frame = CGRect(x: ScreenWidth * CGFloat(index), y: 0, width: ScreenWidth, height: height - titleHeight)
        contentView.addSubview(item)
    }
}

//MARK: Forward
extension SegmentBinder {
    
    fileprivate func headerHeight() -> CGFloat {
        guard let dataSource = self.dataSource,
            dataSource.responds(to: #selector(SegmentViewDataSource.heightOfHeader(in:))) else {
                return 35
        }
        
        return max(35, dataSource.heightOfHeader!(in: self))
    }
    
    fileprivate func itemCount() -> CGFloat {
        return CGFloat(dataSource == nil ? 0 : dataSource!.numberOfItems(in: self))
    }
    
    fileprivate func itemView(at index: Int) -> UIView {
        return dataSource == nil ? UIView() : dataSource!.segmentView(self, itemViewAt: index)
    }
    
    fileprivate func title(at index: Int) -> String {
        return dataSource == nil ? "" : dataSource!.segmentView(self, titleForItemAt: index)
    }
    
    fileprivate func attributesForTitle(at index: Int, selected: Bool) -> [String: Any] {
        guard let dataSource = self.dataSource,
            dataSource.responds(to: #selector(SegmentViewDataSource.segmentView(_:attributesForTitleAt:selected:))) else {
                return [NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                        NSForegroundColorAttributeName: UIColor(hex: selected ? 0x252525 : 0x999999)]
        }
        
        return dataSource.segmentView!(self, attributesForTitleAt: index, selected: selected)
    }
}
