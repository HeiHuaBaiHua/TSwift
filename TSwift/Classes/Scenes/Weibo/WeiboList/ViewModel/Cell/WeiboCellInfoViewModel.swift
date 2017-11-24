//
//  WeiboCellInfoViewModel.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class WeiboCellInfoViewModel {
    private let dealloc = DeinitLogItem(WeiboCellInfoViewModel.self)
    
    var weibo: Weibo!
    var contentHeight: CGFloat = 55 + 33
    
    let name = MutableProperty("")
    let avatarUrl: MutableProperty<URL?> = MutableProperty(nil)
    let createDate = MutableProperty("")
    
    let likesCount = MutableProperty("")
    let repostsCount = MutableProperty("")
    let commentsCount = MutableProperty("")
    
    let isLiked = MutableProperty(false)
    lazy var likeAction: AnyAPIAction = {
        return AnyAPIAction(execute: {[unowned self] (_) -> AnyAPIProducer in
            
            self.switchLikesStatus()
            return WeiboAPIManager().switchLikeStatusProducer(id: "").on(failed: { [unowned self] (_) in
                self.switchLikesStatus()
            })
        })
    }()

    init(weibo: Weibo) {
        self.weibo = weibo
        
        name.value = weibo.sender.name
        avatarUrl.value = weibo.sender.avatr.url
        createDate.value = weibo.createdAt

        likesCount.value = formatCount(weibo.attitudesCount)
        repostsCount.value = formatCount(weibo.repostsCount)
        commentsCount.value = formatCount(weibo.commentsCount)

        isLiked.value = weibo.favorited
    }

    private func formatCount(_ count: Int) -> String {

        if count < 10000 { return String(count) }
        return String(count / 10000) + "万"
    }
    
    private func switchLikesStatus() {
    
        isLiked.value = !isLiked.value;
        weibo.favorited = isLiked.value
        weibo.attitudesCount! += (isLiked.value ? 1 : -1)
        likesCount.value = formatCount(weibo.attitudesCount)
    }
}
