//
//  WeiboDetailRepostsViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

class WeiboDetailRepostsViewModel: ListViewModel {
    
    override func fetchDataSignal(page: Int) -> APIProducer<[ListCellModelProtocol]> {
        
        return WeiboAPIManager().weiboRepostListProducer(id: "", page: page, pageSize: 0).map({ (weibos) -> [ListCellModelProtocol] in
            
            return weibos!.map({ (weibo) -> WeiboDetailRepostsCellViewModel in
                return WeiboDetailRepostsCellViewModel(weibo: weibo)
            })
        })
    }
}
