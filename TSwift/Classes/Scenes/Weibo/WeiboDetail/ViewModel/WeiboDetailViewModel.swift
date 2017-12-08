//
//  WeiboDetailViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import ReactiveSwift

protocol WeiboDetailViewModelProtocol {
    
    var titles: [String] { get }
    
    var isLiked: MutableProperty<Bool> { get }
    var likeProducer: AnyAPIProducer { get }
    
    var weiboDetailCellViewModel: WeiboCellViewModel { get }
    var likesViewModel: WeiboDetailLikesViewModel { get }
    var repostsViewModel: WeiboDetailRepostsViewModel { get }
    var commentsViewModel: WeiboDetailCommentsViewModel { get }
}
extension WeiboDetailViewModel: WeiboDetailViewModelProtocol{}

class WeiboDetailViewModel {
    private let dealloc = DeinitLogItem(WeiboDetailViewModel.self)
    
    private var weibo: Weibo!
    
    private(set) var titles = [""]
    
    private(set) var weiboDetailCellViewModel: WeiboCellViewModel
    private(set) var likesViewModel: WeiboDetailLikesViewModel
    private(set) var repostsViewModel: WeiboDetailRepostsViewModel
    private(set) var commentsViewModel: WeiboDetailCommentsViewModel
    
    private(set) var isLiked = MutableProperty(false)
    lazy var likeProducer: AnyAPIProducer = {
        
        weak var weakSelf = self
        return WeiboAPIManager().switchLikeStatusProducer(id: "").on(starting: {
            weakSelf?.switchLikesStatus()
        }, failed: { _ in
            weakSelf?.switchLikesStatus()
        })
    }()
    
    init(weibo: Weibo) {
        self.weibo = weibo
        
        weiboDetailCellViewModel = WeiboCellViewModel(weibo: weibo)
        weiboDetailCellViewModel.cellHeight -= 33
        
        likesViewModel = WeiboDetailLikesViewModel()
        repostsViewModel = WeiboDetailRepostsViewModel()
        commentsViewModel = WeiboDetailCommentsViewModel()
        
        isLiked.value = weibo.favorited
        titles = [formatCount("转发", weibo.repostsCount),
                  formatCount("评论", weibo.commentsCount),
                  formatCount("赞", weibo.attitudesCount)]
    }
    
//MARK: Utils
    private func formatCount(_ prefix: String, _ count: Int) -> String {
        if count < 10000 { return prefix + String(count) }
        return "\(prefix)\(count/10000)万"
    }
    
    private func switchLikesStatus() {
        
        isLiked.value = !isLiked.value
        weibo.favorited = isLiked.value
        weibo.attitudesCount! += (isLiked.value ? 1 : -1)
        titles[2] = formatCount("赞", weibo.attitudesCount)
    }
}
