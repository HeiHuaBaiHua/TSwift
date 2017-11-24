//
//  UserDefaultsExtension.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/2.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static var sinaToken: String {
        set {
            standard.set(newValue, forKey: "sinaToken")
        }
        get {
            return standard.string(forKey: "sinaToken") ?? ""
        }
    }
    
    static var account: String {
        set {
            standard.set(newValue, forKey: "userAccount")
        }
        get {
            return standard.string(forKey: "userAccount") ?? ""
        }
    }
}
