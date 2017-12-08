//
//  WeiboInfoController.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import Kingfisher
import Result
import ReactiveSwift
import ReactiveCocoa

class WeiboCellInfoBinder: UIViewController {
    private let dealloc = DeinitLogItem(self)

    override func loadView() {
        
        let infoView: WeiboCellInfoView = WeiboCellInfoView.IBInstance()
        view = infoView
        
        bindLikeAction()
    }

    var viewModel: WeiboCellInfoViewModel! {
        didSet {
            
            let view = self.view as! WeiboCellInfoView
            view.nameLabel.reactive.text <~ viewModel.name
            view.sendDateLabel.reactive.text <~ viewModel.createDate
            view.avatarButton.kf.setImage(with: viewModel.avatarUrl.value, for: .normal)
            
            view.likeButton.reactive.title <~ viewModel.likesCount
            view.likeButton.reactive.isSelected <~ viewModel.isLiked
            
            view.repostButton.reactive.title <~ viewModel.repostsCount
            view.commentButton.reactive.title <~ viewModel.commentsCount
        }
    }
    
//MARKL: Action
    private func bindLikeAction() {
        
        let view = self.view as! WeiboCellInfoView
        let likeAction = AnyAPIAction {[unowned self] _ in
            if !self.viewModel.isLiked.value {
                
                let likeIV = UIImageView(image: "weibo_like_selected".image)
                likeIV.center = view.likeButton.center
                view.superview!.addSubview(likeIV)
                
                let positionAnimation = CABasicAnimation(keyPath: "position.y")
                positionAnimation.toValue = likeIV.center.y - 30
                
                let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                scaleAnimation.values = [0.1, 1.0, 1.5]
                scaleAnimation.keyTimes = [0, 0.5, 0.8, 1]
                
                let animationGroup = CAAnimationGroup()
                animationGroup.animations = [positionAnimation, scaleAnimation]
                animationGroup.duration = 0.5
                likeIV.layer.add(animationGroup, forKey: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    likeIV.removeFromSuperview()
                }
            }
            
            return self.viewModel.likeProducer
        }
        
        view.likeButton.reactive.pressed = ButtonAction(likeAction)
        likeAction.errors.observeValues {[unowned self] (error) in
            self.view.toast(error.reason)
        }
    }
}

