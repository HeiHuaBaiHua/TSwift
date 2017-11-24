//
//  HomeTableViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/2.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import MJRefresh

class WeiboListBinder: UIViewController {
    required init?(coder aDecoder: NSCoder) { return nil }
    private let dealloc = DeinitLogItem(self)
    
    
    let viewModel: ListViewModelProtocol
    init(viewModel: ListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        layoutUI()
        
        bindErrorView()
        bindListView()
    }
}

//MARK: UITableViewDataSource && Delegate
extension WeiboListBinder: TableBinderProtocol {
    
    var cellClass: AnyClass {
        return WeiboCell.self
    }
    
    var tableView: UITableView {
        return view as! UITableView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.allData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.allData[indexPath.section].cellHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeiboCell.description()) as! WeiboCell
        cell.viewModel = viewModel.allData[indexPath.section] as? WeiboCellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cellModel = viewModel.allData[indexPath.section] as! WeiboCellViewModel
        Router.pushToWeiboDetail(weiboData: try? JSONEncoder().encode(cellModel.weibo))
    }
}

//MARK: Utils
extension WeiboListBinder {
    
    fileprivate func layoutUI() {
        
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.neverAdjustContentInset()
        
        self.view = tableView
    }
}
