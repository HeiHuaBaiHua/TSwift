//
//  HTTPRequestGenerator.swift
//  TAlamoFire
//
//  Created by HeiHuaBaiHua on 2017/5/15.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit
import Alamofire

final class HTTPRequestGenerator {
    
//MARK: Interface
    
    static let `default` = {
        return HTTPRequestGenerator()
    }()
    
    func dataRequest(configuration config: HTTPDataRequestConfiguration) -> DataRequest {
        return manager.request(urlRequest(config: config))
    }
    
    func uploadRequest(configuration config: HTTPUploadRequestConfiguration, _ completion: ( (SessionManager.MultipartFormDataEncodingResult) -> Void)? ) {
        
        let request = urlRequest(config: config)
        manager.upload(multipartFormData: { (uploadData) in
            
            if let parameters = config.parameters {
                
                for (key, value) in parameters {
                    uploadData.append(String(describing: value).data!, withName: key, mimeType: "text/plain")
                }
            }
            
            if let contents = config.contents {
                
                for file in contents {
                    uploadData.append(file.fileData, withName: file.uploadKey, fileName: file.fileName, mimeType: file.fileType.string)
                }
            }
        }, with: request, encodingCompletion: completion)
    }
    
//MARK: Private
    
    private static let defaultHTTPHeaders = ["X-Sessionid": "97D775D3-D8C1-4905-8EDF-4A0A38017ED9",
                                             "X-Log-Uid": "5694309732",
                                             "X-Validator": "EiWjke1JJfQ8Hqn/1HDPXyBOEhXwd3RgoqPc9XDJgyQ=",
                                             "User-Agent" : "Weibo/9713 (iPhone; iOS 10.2; Scale/2.00)",
                                             "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    
    private init() {}
    
    private var currentService = HTTPService.one(HTTPServiceEnvironment.develop)
    
    private let manager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        var defaultHTTPHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        for (key, value) in HTTPRequestGenerator.defaultHTTPHeaders {
            defaultHTTPHeaders[key] = value
        }
        configuration.httpAdditionalHeaders = defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    private func formatURL(urlPath: String) -> String {
        
        if urlPath.hasPrefix("http") {
            return urlPath
        } else {
            return currentService.host + urlPath
        }
    }
    
    private func urlRequest(config: HTTPRequestConfiguration) -> URLRequest {
        do {
            
            let url = formatURL(urlPath: config.urlPath)
            var originalRequest = try URLRequest(url: url, method: config.method, headers: config.headers)
            originalRequest.timeoutInterval = config.timeoutInterval
            
            let encodedURLRequest = try config.parameterEncoding.encode(originalRequest, with: config.parameters)
            return encodedURLRequest
        } catch {
            
            var request = URLRequest(url: URL(string: "http://www.baidu.com/404")!)
            request.timeoutInterval = 0.1
            return request
        }
    }
}

//MARK: UploadFile
enum UploadFileType {
    case PNG
    case JPG
    case MP3
    
    var string: String {
        switch self {
        case .PNG: return "image/png"
        case .JPG: return "image/jpeg"
        case .MP3: return "audio/mp3"
        }
    }
}

class UploadFile {
    
    let uploadKey: String
    let fileName: String
    let fileType: UploadFileType
    let fileData: Data
    
    init(data: Data, fileName: String, fileType: UploadFileType, uploadKey: String) {
        self.fileData = data
        self.fileType = fileType
        self.uploadKey = uploadKey
        
        switch fileType {
        case .PNG:
            self.fileName = fileName + ".png"
        case .JPG:
            self.fileName = fileName + ".jpg"
        case .MP3:
            self.fileName = fileName + ".mp3"
        }
    }
}
