//
//  HTTPConfiguration.swift
//  TAlamoFire
//
//  Created by HeiHuaBaiHua on 2017/5/15.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import Alamofire

//MARK: HTTPRequestConfiguration

class HTTPRequestConfiguration {
    
    var urlPath: String
    var timeoutInterval: TimeInterval
    
    var method: HTTPMethod
    var headers: [String: String]?
    var parameters: [String: Any]?
    var parameterEncoding: ParameterEncoding
    
    @discardableResult
    init(urlPath: String,
         method: HTTPMethod = .get,
         headers: [String: String]? = nil,
         parameters: [String: Any]? = nil,
         timeoutInterval: TimeInterval = 15.0,
         parameterEncoding: ParameterEncoding = URLEncoding.default) {
        
        self.method = method
        self.urlPath = urlPath
        self.headers = headers
        self.parameters = parameters
        self.timeoutInterval = timeoutInterval > 0 ? timeoutInterval : 15.0
        self.parameterEncoding = parameterEncoding
    }
}

//MARK: HTTPDataRequestConfiguration

class HTTPDataRequestConfiguration: HTTPRequestConfiguration {}

//MARK: HTTPUploadRequestConfiguration

class HTTPUploadRequestConfiguration: HTTPRequestConfiguration {
    var contents: [UploadFile]?
}

//MARK: HTTPTaskConfiguration

enum HTTPResponseValue {
    case data
    case json
    case string
}

class HTTPDataTaskConfiguration: HTTPDataRequestConfiguration {
    var responseValue: HTTPResponseValue
    
    @discardableResult
    init(urlPath: String,
         method: HTTPMethod = .get,
         headers: [String: String]? = nil,
         parameters: [String: Any]? = nil,
         responseValue: HTTPResponseValue = .string,
         timeoutInterval: TimeInterval = 5.0,
         parameterEncoding: ParameterEncoding = URLEncoding.default) {
        
        self.responseValue = responseValue
        super.init(urlPath: urlPath, method: method, headers: headers, parameters: parameters, timeoutInterval: timeoutInterval, parameterEncoding: parameterEncoding)
    }
}

class HTTPUploadTaskConfiguration: HTTPUploadRequestConfiguration {
    var responseValue: HTTPResponseValue
    
    @discardableResult
    init(urlPath: String,
         method: HTTPMethod = .post,
         headers: [String: String]? = nil,
         contents: [UploadFile]? = nil,
         parameters: [String: Any]? = nil,
         responseValue: HTTPResponseValue = .string,
         timeoutInterval: TimeInterval = 10.0,
         parameterEncoding: ParameterEncoding = URLEncoding.default) {
        
        self.responseValue = responseValue
        super.init(urlPath: urlPath, method: method, headers: headers, parameters: parameters, timeoutInterval: timeoutInterval, parameterEncoding: parameterEncoding)
        self.contents = contents
    }
}
