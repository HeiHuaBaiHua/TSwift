//
//  User.swift
//  TSwift
//
//  Created by 黑花白花 on 2017/6/4.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import HandyJSON

struct User: Codable {

    var id = ""
    var name: String!
    var avatr: String!
    var verified: Bool!
}

extension User: HandyJSON {
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< id <-- "idstr"
        mapper <<< avatr <-- "avatar_large"
    }
}
