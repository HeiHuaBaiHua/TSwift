//
//  WeiboDetailTableBinder.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailTableBinder: UIViewController {
    required init?(coder aDecoder: NSCoder) { return nil }
    
    var viewModel: ListViewModelProtocol
    init(view: HHTableView, viewModel: ListViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view = view
        
        bindListView()
        bindErrorView()
    }
}

//MARK: UIScrollViewDelegate
extension WeiboDetailTableBinder {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let listView = view as! HHTableView
        if (!listView.isFirstScrollResponder ||
            listView.contentOffset.y <= 0) {
            listView.contentOffset = .zero;
        }
        listView.showsVerticalScrollIndicator = listView.isFirstScrollResponder;
    }
}

//MARK: Override
extension WeiboDetailTableBinder: TableBinderProtocol {
    
    func refreshData() {
        if viewModel.allData.isEmpty {
            tableView.showHUD()
        }
        viewModel.refreshAction?.apply(nil).start()
    }
    
    func bindListHeader() {
        
        viewModel.refreshAction?.events.observeResult {[unowned self] (event) in
            self.tableView.hideHUD()
            
            let result = event.value
            if (result?.error == nil) {
                
                self.tableView.reloadData()
                if self.tableView.mj_footer != nil {
                    self.tableView.mj_footer.resetNoMoreData()
                }
            }
        }
    }
    
    var tableView: UITableView {
        return view as! UITableView
    }
    
    var cellClass: AnyClass {
        return UITableViewCell.self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.allData[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
