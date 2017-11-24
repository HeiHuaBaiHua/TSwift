//
//  WeiboListViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/1.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import SnapKit

class WeiboListViewController: UIViewController {
    private let dealloc = DeinitLogItem(self)
    
    let listBinder = WeiboListBinder(viewModel: WeiboListViewModel())
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        
        configuration()
        
        listBinder.refreshData()
    }
    
//MARK: Utils
    
    private func layoutUI() {
        
        view.addSubview(listBinder.view)
        addChildViewController(listBinder)
        listBinder.view.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func configuration() {
        
        title = "TWeiboList"
        view.backgroundColor = UIColor.groupTableViewBackground
    }
}
