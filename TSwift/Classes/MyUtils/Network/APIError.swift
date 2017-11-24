//
//  APIError.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/7/10.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

protocol ErrorRawValue {
    var rawValue: Int { get }
}

enum TaskError: Int, ErrorRawValue {
    case `default` = 101
    case timeout
    case canceled
    case noNetwork
    case noData
    case noMoreData
}

extension Int: ErrorRawValue {
    var rawValue: Int { return self }
}

struct APIError: Swift.Error {
    
    let code: Int
    var info = ""
    var reason: String {
        switch code {
        case TaskError.noData.rawValue: return "空空如也~"
        case TaskError.timeout.rawValue: return "请求超时~"
        case TaskError.noNetwork.rawValue: return "未检测到网络连接~"
        case TaskError.noMoreData.rawValue: return "没有更多了~"
        default: return info.count > 0 ? info : "请求失败了~"
        }
    }
    
    init(_ error: ErrorRawValue) {
        self.code = error.rawValue
    }
    
    init(_ reason: String) {
        self.code = TaskError.default.rawValue
        self.info = reason
    }
    
    init(_ taskError: TaskError) {
        self.code = taskError.rawValue
    }
    
    static func == (left: APIError, right: ErrorRawValue) -> Bool {
        return left.code == right.rawValue
    }
    
    static func != (left: APIError, right: ErrorRawValue) -> Bool {
        return left.code != right.rawValue
    }
}
