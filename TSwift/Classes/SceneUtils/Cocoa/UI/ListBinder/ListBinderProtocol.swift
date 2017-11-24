//
//  ListControllerProtocol.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/7/11.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

import MJRefresh
import ReactiveSwift
import ReactiveCocoa

protocol ListBinderProtocol {
    
    var viewModel: ListViewModelProtocol { get }
    
    var cellClass: AnyClass { get }
    
    func refreshData()
    func becomeFirstListBinder()
    
    func bindErrorView()
    
    func bindListView()
    func bindListHeader()
    func bindListFooter()
}

//MARK: TableBinder

protocol TableBinderProtocol: ListBinderProtocol, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView { get }
}

extension TableBinderProtocol {
    
    func refreshData() {
        tableView.mj_header.beginRefreshing()
    }
    
    func becomeFirstListBinder() {
        
        tableView.delegate = self
        tableView.dataSource = self
        if viewModel.allData.isEmpty {
            refreshData()
        }
    }
}

extension TableBinderProtocol {
    func bindErrorView() {
        
        viewModel.refreshAction?.events.observeResult {[unowned self] (event) in
            guard let result = event.value else { return }
            
            let noData = (self.viewModel.allData.isEmpty && result.error != nil)
            self.tableView.isScrollEnabled = !noData
            self.tableView.errorView.isHidden = !noData
            
            if noData {
                
                self.tableView.errorView.setError(result.error!)
                let retryAction = AnyAction(execute: {[unowned self] (_) -> AnyProducer in
                    self.refreshData()
                    return AnyProducer.empty
                })
                self.tableView.errorView.errorTextButton.reactive.pressed = ButtonAction(retryAction)
            }
        }
        
        if let loadMoreAction = viewModel.loadMoreAction {
            loadMoreAction.errors.observeValues({ [unowned self] (error) in
                self.tableView.toast(error.reason)
            })
        }
    }
}

extension TableBinderProtocol {
    
    func bindListView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass, forCellReuseIdentifier: cellClass.description())
        
        bindListHeader()
        bindListFooter()
    }
    
    func bindListHeader() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.viewModel.refreshAction?.apply(nil).start()
        })
        
        viewModel.refreshAction?.events.observeResult {[unowned self] (event) in
            self.tableView.mj_header.endRefreshing()
            
            let result = event.value
            if (result?.error == nil) {
                self.tableView.reloadData()
                if self.tableView.mj_footer != nil {
                    self.tableView.mj_footer.resetNoMoreData()
                }
            }
        }
    }
    
    func bindListFooter() {
        if viewModel.loadMoreAction == nil { return }
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.viewModel.loadMoreAction!.apply(nil).start()
        })
        viewModel.loadMoreAction?.events.observeResult {[unowned self] (event) in
            self.tableView.mj_footer.endRefreshing()
            
            if let result = event.value {
                
                if result.error == nil {
                    self.tableView.reloadData()
                } else if result.error! == TaskError.noMoreData {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
        }
        tableView.mj_footer.endRefreshingWithNoMoreData()
        tableView.reactive.signal(forKeyPath: "contentSize").observeValues {[weak self] (contentSize) in
            if let contentSize = contentSize as? CGSize,
               let strongSelf = self {
                
                let isHidden = contentSize.height < strongSelf.tableView.height
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    strongSelf.tableView.mj_footer.isHidden = isHidden
                })
            }
        }
    }
}
