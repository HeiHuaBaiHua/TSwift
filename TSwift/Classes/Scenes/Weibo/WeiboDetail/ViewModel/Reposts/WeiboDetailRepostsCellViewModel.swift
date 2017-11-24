//
//  WeiboDetailRepostsCellViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailRepostsCellViewModel: ListCellModelProtocol {

    private(set) var text: String!
    private(set) var image: UIImage?
    
    init(weibo: Weibo) {
        
        text = "礼貌性的转发\(weibo.id)下"
        image = "tabbar_compose_photo".image
    }
}
