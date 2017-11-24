//
//  WeiboDetailCommentsCellViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailCommentsCellViewModel: ListCellModelProtocol {

    private(set) var text: String!
    private(set) var image: UIImage?
    
    init(comment: WeiboComment) {
        
        text = "象征性的评论\(comment.id)下"
        image = "tabbar_compose_photo".image
    }

}
