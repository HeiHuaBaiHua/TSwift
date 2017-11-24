//
//  WeiboDetailViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

protocol WeiboDetailViewModelProtocol {
    
    var titles: [String] { get }
    
    var weiboDetailCellViewModel: WeiboCellViewModel { get }
    var likesViewModel: WeiboDetailLikesViewModel { get }
    var repostsViewModel: WeiboDetailRepostsViewModel { get }
    var commentsViewModel: WeiboDetailCommentsViewModel { get }
}
extension WeiboDetailViewModel: WeiboDetailViewModelProtocol{}

class WeiboDetailViewModel {
    private let dealloc = DeinitLogItem(WeiboDetailViewModel.self)
    
    private(set) var titles: [String]
    
    private(set) var weiboDetailCellViewModel: WeiboCellViewModel
    private(set) var likesViewModel: WeiboDetailLikesViewModel
    private(set) var repostsViewModel: WeiboDetailRepostsViewModel
    private(set) var commentsViewModel: WeiboDetailCommentsViewModel
    init(weibo: Weibo) {
        
        weiboDetailCellViewModel = WeiboCellViewModel(weibo: weibo)
        weiboDetailCellViewModel.cellHeight -= 33
        
        likesViewModel = WeiboDetailLikesViewModel()
        repostsViewModel = WeiboDetailRepostsViewModel()
        commentsViewModel = WeiboDetailCommentsViewModel()
        
        func formatCount(_ prefix: String, _ count: Int) -> String {
            if count < 10000 { return prefix + String(count) }
            return "\(prefix)\(count/10000)万"
        }
        titles = [formatCount("转发", weibo.repostsCount),
                  formatCount("评论", weibo.commentsCount),
                  formatCount("赞", weibo.attitudesCount)]
    }
}
