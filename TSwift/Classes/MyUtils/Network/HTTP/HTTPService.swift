//
//  HTTPService.swift
//  TAlamoFire
//
//  Created by 黑花白花 on 2017/5/17.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

enum HTTPServiceEnvironment {
    case test
    case develop
    case release
}

enum HTTPService {
    
    case one(HTTPServiceEnvironment)
    case two(HTTPServiceEnvironment)
    case three(HTTPServiceEnvironment)
}

extension HTTPService {
    
    var host: String {
        
        switch self {
        case .one(let environment):
            switch environment {
                
            case .test: return "http://127.0.0.1:8888"
            case .develop: return "https://api.weibo.com/2"
            case .release: return "https://api.weibo.com/2"
            }
            
        case .two(let environment):
            switch environment {
                
            case .test: return ""
            case .develop: return ""
            case .release: return ""
            }
            
        case .three(let environment):
            switch environment {
                
            case .test: return ""
            case .develop: return ""
            case .release: return ""
            }
        }
    }
}
