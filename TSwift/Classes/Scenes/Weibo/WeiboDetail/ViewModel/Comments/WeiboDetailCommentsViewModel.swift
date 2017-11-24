//
//  WeiboDetailCommentsViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailCommentsViewModel: ListViewModel {

    private var noError = false
    
    override func fetchDataSignal(page: Int) -> APIProducer<[ListCellModelProtocol]> {
        if !noError {
            noError = true
            return APIProducer(error: APIError(1246463))
        }
        
        return WeiboAPIManager().weiboCommentListProducer(id: "", page: page, pageSize: 0).map({ (comments) -> [ListCellModelProtocol] in
            
            return comments!.map({ (comment) -> WeiboDetailCommentsCellViewModel in
                return WeiboDetailCommentsCellViewModel(comment: comment)
            })
        })
    }

}
