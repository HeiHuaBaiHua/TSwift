//
//  WeiboCellViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/2.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import ReactiveSwift

class WeiboCellViewModel: ListCellModelProtocol {
    private let dealloc = DeinitLogItem(WeiboCellViewModel.self)

    let weibo: Weibo!
    
    var cellHeight: CGFloat
    let weiboInfoVM: WeiboCellInfoViewModel
    let weiboContentVM: WeiboCellContentViewModel
    var retweetedWeiboContentVM: WeiboCellContentViewModel?
    
    init(weibo: Weibo) {
        self.weibo = weibo
        
        weiboInfoVM = WeiboCellInfoViewModel(weibo: weibo)
        weiboContentVM = WeiboCellContentViewModel(weibo: weibo)
        cellHeight = weiboInfoVM.contentHeight + weiboContentVM.contentHeight
        
        if weibo.retweetedWeibo != nil {
            
            retweetedWeiboContentVM = WeiboCellContentViewModel(weibo: weibo.retweetedWeibo!)
            cellHeight += (Interval * 0.5 + retweetedWeiboContentVM!.contentHeight)
        }
        
        cellHeight += Interval
    }
}
