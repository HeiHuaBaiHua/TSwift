//
//  WeiboDetailView.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import SnapKit

//MARK: Interface
protocol WeiboDetailViewProtocol {
    
    var mainListView: HHTableView { get }
    var weiboDetailCell: WeiboCell { get }
    
    var weiboStatusCell: UITableViewCell { get }
    var segmentView: SegmentViewProtocol { set get }
    var repostsListView: HHTableView { get }
    var commentsListView: HHTableView { get }
    var likesListView: HHTableView { get }
    
    var repostButton: UIButton { get }
    var commentButton: UIButton { get }
    var likeButton: UIButton { get }
}
extension WeiboDetailView: WeiboDetailViewProtocol{}

class WeiboDetailView: UIView {
    required init?(coder aDecoder: NSCoder) { return nil }
    private let dealloc = DeinitLogItem(self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
        configuration()
    }
    
    //MARK: Utils
    private func layoutUI() {
        addSubview(mainListView)
        addSubview(repostButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        weiboStatusCell.addSubview(segmentView as! UIView)
        
        let statusButtonHeight: CGFloat = 33
        mainListView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 0, bottom: statusButtonHeight, right: 0))
        }
        
        repostButton.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.333)
            make.height.equalTo(statusButtonHeight)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.333)
            make.height.equalTo(statusButtonHeight)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.333)
            make.height.equalTo(statusButtonHeight)
        }
        
        let addLine: (_ closure: (_ make: ConstraintMaker) -> ()) -> () = {closure in
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor(hex: 0xe5e5e5)
            self.addSubview(lineView)
            lineView.snp.makeConstraints(closure)
        }
        
        addLine { (make) in
            make.top.equalTo(commentButton)
            make.left.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        addLine { (make) in
            make.left.centerY.equalTo(commentButton)
            make.size.equalTo(CGSize(width: 0.5, height: 20))
        }
        
        addLine { (make) in
            make.right.centerY.equalTo(commentButton)
            make.size.equalTo(CGSize(width: 0.5, height: 20))
        }
    }
    
    private func configuration() {
        backgroundColor = UIColor.white
    }
    
    static private func makeListView() -> HHTableView {
        let listView = HHTableView(frame: .zero, style: .grouped)
        listView.backgroundColor = UIColor.groupTableViewBackground
        listView.isFirstScrollResponder = false
        listView.neverAdjustContentInset()
        return listView
    }
    
    static private func makeButton(_ title: String, _ imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.title = title
        button.setImage(imageName.image, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(hex: 0x88888888), for: .normal)
        return button
    }
    
    //MARK: Getter
    lazy private(set) var mainListView: HHTableView = {
        
        $0.backgroundColor = UIColor.groupTableViewBackground
        $0.gestureChoiceHandler = {_,_ in return true}
        $0.neverAdjustContentInset()
        return $0
    }(HHTableView(frame: .zero, style: .grouped))

    lazy private(set) var weiboDetailCell: WeiboCell = {
        return WeiboCell(style: .default, reuseIdentifier: "weiboDetailCell")
    }()
    
    lazy private(set) var weiboStatusCell: UITableViewCell = {
        $0.selectionStyle = .none
        return $0
    }(UITableViewCell(style: .default, reuseIdentifier: "weiboStatusCell"))
    
    lazy var segmentView: SegmentViewProtocol = {
        return UIBuilder.segmentView(frame: ScreenMinusTopBounds)
    }()
    
    lazy private(set) var repostsListView = WeiboDetailView.makeListView()
    lazy private(set) var commentsListView = WeiboDetailView.makeListView()
    lazy private(set) var likesListView = WeiboDetailView.makeListView()

    lazy private(set) var repostButton = WeiboDetailView.makeButton("转发", "weibo_forward")
    lazy private(set) var commentButton = WeiboDetailView.makeButton("评论", "weibo_comment")
    lazy private(set) var likeButton = WeiboDetailView.makeButton("赞", "weibo_like")
}

