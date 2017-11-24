//
//  Weibo.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import HandyJSON

enum WeiboHrefType {
    case url(String)
    case topic(String)
    case nickname(String)
}

class Weibo: Codable {
    required init() {}
    
    var id: String = ""
    var sender: User!
    
    var text: String?
    var picUrls: [[String: String]]?
    var favorited: Bool!
    var createdAt: String!
    var repostsCount: Int!
    var commentsCount: Int!
    var attitudesCount: Int!
    var retweetedWeibo: Weibo?
}

extension Weibo: HandyJSON {
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< id <-- "idstr"
        mapper <<< sender <-- "user"
        mapper <<< picUrls <-- "pic_urls"
        mapper <<< createdAt <-- "created_at"
        mapper <<< repostsCount <-- "reposts_count"
        mapper <<< commentsCount <-- "comments_count"
        mapper <<< attitudesCount <-- "attitudes_count"
        mapper <<< retweetedWeibo <-- "retweeted_status"
    }
}
