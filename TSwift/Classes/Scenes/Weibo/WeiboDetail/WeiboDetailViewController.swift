//
//  WeiboDetailViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailViewController: UIViewController {
    required init?(coder aDecoder: NSCoder) { return nil }
    private let dealloc = DeinitLogItem(self)
    
    let binder: WeiboDetailBinder
    init(weibo: Weibo) {
        
        binder = WeiboDetailBinder(view: WeiboDetailView(frame: ScreenBounds), viewModel: WeiboDetailViewModel(weibo: weibo))
        super.init(nibName: nil, bundle: nil)
        
        view = binder.view as! UIView
        title = "TWeiboDetail"
    }

}

