//
//  WeiboCell.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import ReactiveSwift
import ReactiveCocoa

class WeiboCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) { return nil }
    private let dealloc = DeinitLogItem(self)

    var infoBinder: WeiboCellInfoBinder!
    var contentBinder: WeiboCellContentBinder!
    var retweetedWeiboBinder: WeiboCellContentBinder!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configuration()
        layoutUI()
    }
    
    func configuration() {
        selectionStyle = .none
        
        infoBinder = WeiboCellInfoBinder()
        contentBinder = WeiboCellContentBinder()
        retweetedWeiboBinder = WeiboCellContentBinder()
    }
    
    var viewModel: WeiboCellViewModel! {
        didSet {
            
            infoBinder.viewModel = viewModel.weiboInfoVM
            
            contentBinder.viewModel = viewModel.weiboContentVM
            contentBinder.view.snp.updateConstraints { (make) in
                make.height.equalTo(viewModel.weiboContentVM.contentHeight)
            }
            
            retweetedWeiboBinder.view.isHidden = viewModel.retweetedWeiboContentVM == nil
            if !retweetedWeiboBinder.view.isHidden {
                retweetedWeiboBinder.viewModel = viewModel.retweetedWeiboContentVM
                retweetedWeiboBinder.view.snp.updateConstraints { (make) in
                    make.height.equalTo(viewModel.retweetedWeiboContentVM!.contentHeight + Interval)
                }
            }
        }
    }
}

//MARK: Utils
extension WeiboCell {
    
    fileprivate func layoutUI() {
        
        contentView.addSubview(infoBinder.view)
        contentView.addSubview(contentBinder.view)
        contentView.addSubview(retweetedWeiboBinder.view)
        retweetedWeiboBinder.view.backgroundColor = UIColor(hex: 0xf5f5f5)
        
        infoBinder.view.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        let userInfoHeight = 54
        contentBinder.view.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(userInfoHeight)
            make.left.right.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        retweetedWeiboBinder.view.snp.makeConstraints { (make) in
            make.top.equalTo(contentBinder.view.snp.bottom).offset(Interval * 0.5)
            make.left.right.equalTo(contentView)
            make.height.equalTo(1)
        }
    }
}
