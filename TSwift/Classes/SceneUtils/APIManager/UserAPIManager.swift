//
//  UserAPIManager.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/27.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class UserAPIManager: HTTPAPIManager {

    func registerProducer(account: String, password: String) -> AnyAPIProducer {
        
        return arc4random() % 2 == 1 ? AnyAPIProducer(error: APIError(789465)) : AnyAPIProducer(value: true)
//        let config = HTTPDataTaskConfiguration(urlPath: "/register", method: .post,
//                                               parameters: ["account": account,
//                                                            "password": password],
//                                               responseValue: .json)
//        return producer(configuration: config)
    }
    
    func login(account: String, password: String) -> AnyAPIProducer {
        
        let config = HTTPDataTaskConfiguration(urlPath: "/login", method: .post,
                                               parameters: ["account": account,
                                                            "password": password],
                                               responseValue: .json)
        return producer(configuration: config)
    }
    
    func userInfo() -> AnyAPIProducer {
        
        let config = HTTPDataTaskConfiguration(urlPath: "/users/show.json",
                                               parameters: ["uid": "2855856634"],
                                               responseValue: .json)
        return producer(configuration: config)
    }
    
    func getVerifyCode(phoneNumber: String) -> AnyAPIProducer {
        return arc4random() % 2 == 1 ? AnyAPIProducer(error: APIError(489489)) : AnyAPIProducer(value: true)
    }
}
