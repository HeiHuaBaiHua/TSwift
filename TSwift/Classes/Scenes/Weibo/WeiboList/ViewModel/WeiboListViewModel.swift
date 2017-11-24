//
//  WeiboListViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/6/2.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboListViewModel: ListViewModel {
    private let dealloc = DeinitLogItem(WeiboListViewModel.self)
    
    override func fetchDataSignal(page: Int) -> APIProducer<[ListCellModelProtocol]> {
        return WeiboAPIManager().homeTimeLineProducer(page: page, pageSize: pageSize).map({ (result) -> [ListCellModelProtocol] in
            
            return result!.map({ (weibo) in
                return WeiboCellViewModel(weibo: weibo)
            })
        })
    }
}
