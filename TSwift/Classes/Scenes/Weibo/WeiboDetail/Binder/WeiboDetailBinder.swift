//
//  WeiboDetailBinder.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import MJRefresh
import ReactiveSwift

class WeiboDetailBinder: NSObject {
    private let dealloc = DeinitLogItem(self)
    
    
    var view: WeiboDetailViewProtocol!
    let viewModel: WeiboDetailViewModelProtocol!
    
    let likesBinder: WeiboDetailLikesBinder!
    let repostsBinder: WeiboDetailRepostsBinder!
    let commentsBinder: WeiboDetailCommentsBinder!
    fileprivate var listBinders: [WeiboDetailTableBinder] {
        return [repostsBinder, commentsBinder, likesBinder] as [WeiboDetailTableBinder]
    }
    
    init(view: WeiboDetailViewProtocol, viewModel: WeiboDetailViewModelProtocol) {
        self.view = view
        self.viewModel = viewModel

        likesBinder = WeiboDetailLikesBinder(view: view.likesListView, viewModel: viewModel.likesViewModel)
        repostsBinder = WeiboDetailRepostsBinder(view: view.repostsListView, viewModel: viewModel.repostsViewModel)
        commentsBinder = WeiboDetailCommentsBinder(view: view.commentsListView, viewModel: viewModel.commentsViewModel)
        super.init()
        
        bindListView()
        bindLikeAction()
        bindSegmentView()
        bindScrollResponder()
    }
}

extension WeiboDetailBinder {
    
    fileprivate func bindLikeAction() {
        
        let likeAction = AnyAPIAction {[unowned self] _ in
            
            let imageName = self.viewModel.isLiked.value ? "weibo_like" : "weibo_like_selected"
            let likeIV = UIImageView(image: imageName.image)
            likeIV.center = self.view.likeButton.imageView!.center
            self.view.likeButton.addSubview(likeIV)
            
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimation.values = [1.0, 1.3, 1.8, 2.1]
            scaleAnimation.keyTimes = [0, 0.3, 0.6, 1]
            scaleAnimation.duration = 0.5
            
            likeIV.layer.add(scaleAnimation, forKey: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                likeIV.removeFromSuperview()
            }
            
            return self.viewModel.likeProducer
        }
        
        view.likeButton.reactive.isSelected <~ viewModel.isLiked
        view.likeButton.reactive.pressed = ButtonAction(likeAction)
        likeAction.events.observeResult {[unowned self] (event) in
            guard let result = event.value else { return }
            
            if let error = result.error {
                self.view.mainListView.toast(error.reason)
            } else {
                self.view.segmentView.reloadTitle()
            }
        }
    }
}

//MARK: ScrollResponder
extension WeiboDetailBinder {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let listView = view.mainListView
        let weiboStatusCellTop = listView.rect(forSection: 1).origin.y
        if  listView.contentOffset.y >= weiboStatusCellTop &&
            listView.isFirstScrollResponder {
            switchScrollResponder(toMainList: false)
        }
        
        if  listView.contentOffset.y >= weiboStatusCellTop ||
            !listView.isFirstScrollResponder {
            listView.contentOffset = CGPoint(x: 0, y: weiboStatusCellTop)
        }
        listView.showsVerticalScrollIndicator = listView.isFirstScrollResponder
    }
    
    fileprivate func bindScrollResponder() {
        
        let likesListOffset = view.likesListView.reactive.signal(forKeyPath: "contentOffset")
        let repostsListOffset = view.repostsListView.reactive.signal(forKeyPath: "contentOffset")
        let commentsListOffset = view.commentsListView.reactive.signal(forKeyPath: "contentOffset")
        
        Signal.merge(likesListOffset, repostsListOffset, commentsListOffset).observeValues {[weak self] (offset) in
            guard let offset = offset as? CGPoint, let strongSelf = self else {
                return
            }
            
            if !strongSelf.view.mainListView.isFirstScrollResponder &&
                offset.y <= 0 {
                strongSelf.switchScrollResponder(toMainList: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    strongSelf.view.likesListView.contentOffset = .zero
                    strongSelf.view.repostsListView.contentOffset = .zero
                    strongSelf.view.commentsListView.contentOffset = .zero
                })
            }
        }
    }
    
    private func switchScrollResponder(toMainList: Bool) {
        
        view.mainListView.isFirstScrollResponder = toMainList;
        view.likesListView.isFirstScrollResponder = !toMainList;
        view.repostsListView.isFirstScrollResponder = !toMainList;
        view.commentsListView.isFirstScrollResponder = !toMainList;
    }
}

//MARK: SegmentViewDataSource
extension WeiboDetailBinder: SegmentViewDataSource {
    fileprivate func bindSegmentView() {
        
        view.segmentView.didScrollToItemHandler = {[unowned self] (_, index) in
            self.listBinders[index].refreshData()
        }
        view.segmentView.headerBackgroundColor = UIColor.purple
        view.segmentView.dataSource = self
    }
    
    func numberOfItems(in segmentView: UIView) -> Int {
        return viewModel.titles.count
    }
    
    func segmentView(_ segmentView: UIView, itemViewAt index: Int) -> UIView {
        return listBinders[index].view
    }
    
    func segmentView(_ segmentView: UIView, titleForItemAt index: Int) -> String {
        return viewModel.titles[index]
    }
}

//MARK: UITableViewDataSource && Delegate
extension WeiboDetailBinder: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func bindListView() {
        let listView = view.mainListView
        listView.delegate = self
        listView.dataSource = self
        
        view.weiboDetailCell.viewModel = viewModel.weiboDetailCellViewModel
        
        listView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.listBinders[self.view.segmentView.selectedIndex].refreshData()
        })
        
        for bind in self.listBinders {
            bind.viewModel.refreshAction?.events.observeResult {(event) in
                listView.mj_header.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? viewModel.weiboDetailCellViewModel.cellHeight : ScreenMinusTopHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return indexPath.section == 0 ? view.weiboDetailCell : view.weiboStatusCell
    }
}
