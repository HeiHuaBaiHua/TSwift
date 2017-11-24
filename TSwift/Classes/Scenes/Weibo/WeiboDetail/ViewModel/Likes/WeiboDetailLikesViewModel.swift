//
//  WeiboDetailLikesViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailLikesViewModel: ListViewModel {

    override func fetchDataSignal(page: Int) -> APIProducer<[ListCellModelProtocol]> {
        return WeiboAPIManager().weiboLikeListProducer(id: "", page: page, pageSize: 0).map({ (users) -> [ListCellModelProtocol] in
            
            return users!.map({ (user) -> WeiboDetailLikesCellViewModel in
                return WeiboDetailLikesCellViewModel(user: user)
            })
        })
    }
}
